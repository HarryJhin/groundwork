#!/usr/bin/env python3
"""Fresh-context first-response probes; results require human assessment."""
import argparse
import concurrent.futures
import hashlib
import json
import subprocess
import tempfile
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PROMPTS = {
    "none": [],
    "handoff": ["skills/using-git-worktrees/SKILL.md", "skills/verification-before-completion/SKILL.md", "skills/finish/SKILL.md"],
    "bootstrap": ["skills/using-groundwork/SKILL.md"],
    "design": ["skills/using-groundwork/SKILL.md", "skills/finding-unknowns/SKILL.md"],
    "review": ["skills/design-review/SKILL.md"],
    "execution": ["skills/executing-design/SKILL.md", "skills/executing-design/task-reviewer-prompt.md"],
    "subagent": ["skills/executing-design/SKILL.md", "skills/subagent-driven-development/SKILL.md", "skills/executing-design/task-reviewer-prompt.md"],
}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--variant", choices=PROMPTS, default="design")
    parser.add_argument("--revision", help="Read prompts from this git revision; default: working tree")
    parser.add_argument("--prompt-file", action="append", help="Repo-relative prompt path; replaces the variant prompts (repeatable)")
    parser.add_argument("--cases-file", type=Path, help="Scenario JSON; default: cases.json beside this script")
    parser.add_argument("--cases", help="Comma-separated case names")
    parser.add_argument("--repeat", type=int, default=5)
    parser.add_argument("--workers", type=int, default=3)
    parser.add_argument("--out", type=Path)
    args = parser.parse_args()
    cases = json.loads((args.cases_file or Path(__file__).with_name("cases.json")).read_text())
    group = "handoff" if args.variant == "handoff" else "execution" if args.variant in {"execution", "subagent", "review"} else "design"
    names = args.cases.split(",") if args.cases else [k for k, v in cases.items() if v["group"] == group]
    if args.repeat < 1 or args.workers < 1 or any(name not in cases for name in names):
        parser.error("repeat/workers must be positive and cases must exist")
    out = (args.out or Path(tempfile.mkdtemp(prefix="groundwork-probes-"))).resolve()
    out.mkdir(parents=True, exist_ok=True)
    parts = []
    prompt_paths = args.prompt_file or PROMPTS[args.variant]
    for path in prompt_paths:
        if args.revision:
            value = subprocess.run(["git", "show", f"{args.revision}:{path}"], cwd=ROOT, capture_output=True, text=True, check=True).stdout
        else:
            value = (ROOT / path).read_text()
        parts.append(value)
    body = "\n\n".join(parts)
    system = "한국어로 답하는 코딩 에이전트다. 제공된 현재 사실을 사용해 실제 작업의 첫 사용자 응답과 바로 다음 행동을 작성한다. 도구 호출과 실제 구현은 이 테스트에서 하지 않는다. 제공되지 않은 요구나 조사 결과를 지어내지 않는다."
    if body:
        system += "\n\n" + body
    version = subprocess.run(["claude", "--version"], capture_output=True, text=True, check=True).stdout.strip()
    manifest = {"variant": args.variant, "revision": args.revision, "prompt_files": prompt_paths, "cases": names, "repeat": args.repeat, "claude_version": version, "prompt_sha256": hashlib.sha256(body.encode()).hexdigest(), "prompt_bytes": len(body.encode()), "case_sha256": hashlib.sha256(json.dumps({name: cases[name] for name in names}, ensure_ascii=False, sort_keys=True).encode()).hexdigest()}
    (out / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n")
    (out / "prompt.txt").write_text(system)
    (out / "cases.json").write_text(json.dumps({name: cases[name] for name in names}, ensure_ascii=False, indent=2) + "\n")

    def run(item):
        name, iteration = item
        case = cases[name]
        user = case["request"] + "\n확인된 현재 사실: " + case["facts"]
        started = time.monotonic()
        try:
            result = subprocess.run(["claude", "-p", "--safe-mode", "--tools", "", "--no-session-persistence", "--output-format", "json", "--system-prompt", system, user], cwd=out, capture_output=True, text=True, timeout=180)
        except subprocess.TimeoutExpired:
            return {"case": name, "iteration": iteration, "error": "timeout"}
        path = out / f"{name}-{iteration}.json"
        path.write_text(result.stdout)
        path.with_suffix(".stderr").write_text(result.stderr)
        try:
            data = json.loads(result.stdout)
        except json.JSONDecodeError:
            data = {}
        return {"case": name, "iteration": iteration, "exit_code": result.returncode, "is_error": data.get("is_error"), "seconds": round(time.monotonic() - started, 1), "modelUsage": data.get("modelUsage", {}), "path": str(path), "expected": case["expected"]}

    items = [(name, i) for name in names for i in range(1, args.repeat + 1)]
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as pool:
        results = list(pool.map(run, items))
    (out / "summary.json").write_text(json.dumps(results, ensure_ascii=False, indent=2) + "\n")
    print(out)
    if any(r.get("error") or r.get("exit_code") != 0 or r.get("is_error") is not False for r in results):
        raise SystemExit("One or more probes failed to run; inspect summary.json")


if __name__ == "__main__":
    main()
