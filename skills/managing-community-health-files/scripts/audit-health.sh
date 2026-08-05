#!/usr/bin/env bash
# 커뮤니티 헬스 파일 감사 (읽기 전용). SKILL.md 작업 1.
# 사용: bash audit-health.sh [repo_dir]
# 출력: 파일별 존재·위치, 부재 목록, 형제 .github 상속 감지, community profile.
# 쓰기·수정 없음. git·(선택)gh만 사용.
set -u

REPO="${1:-$PWD}"
cd "$REPO" 2>/dev/null || { echo "경로 없음: $REPO" >&2; exit 1; }

# 세 위치(.github → 루트 → docs)에서 인식되는 파일. 대소문자 정확 매칭.
# FUNDING.yml과 템플릿 디렉터리는 인식 위치가 달라 아래에서 따로 처리한다.
FILES="CODE_OF_CONDUCT.md CONTRIBUTING.md SECURITY.md SUPPORT.md GOVERNANCE.md PULL_REQUEST_TEMPLATE.md CODEOWNERS LICENSE README.md"

# path를 .github → . → docs 순으로 정확 대소문자 탐색. 첫 매칭 상대경로 출력, 없으면 rc=1.
locate() {
  local name="$1" loc cand dir base
  for loc in .github . docs; do
    if [ "$loc" = "." ]; then cand="$name"; else cand="$loc/$name"; fi
    dir="$(dirname "$cand")"; base="$(basename "$cand")"
    if [ -d "$dir" ] && find "$dir" -maxdepth 1 -name "$base" 2>/dev/null | grep -q .; then
      printf '%s\n' "$cand"; return 0
    fi
  done
  return 1
}

echo "=== 커뮤니티 헬스 파일 감사: $REPO ==="
echo
echo "[존재 / 위치]"
MISSING=""
for f in $FILES; do
  if p="$(locate "$f")"; then
    printf '  ✓ %-24s %s\n' "$f" "$p"
  else
    printf '  ✗ %-24s (없음)\n' "$f"
    MISSING="$MISSING $f"
  fi
done

# FUNDING.yml은 .github/의 default 브랜치에만 유효하다. 루트·docs는 GitHub이 무시한다.
if [ -f ".github/FUNDING.yml" ]; then
  printf '  ✓ %-24s .github/FUNDING.yml\n' "FUNDING.yml"
else
  printf '  ✗ %-24s (없음, .github/FUNDING.yml)\n' "FUNDING.yml"
  MISSING="$MISSING FUNDING.yml"
  for stray in FUNDING.yml docs/FUNDING.yml; do
    [ -f "$stray" ] && echo "    ! $stray 이 있으나 GitHub은 .github/ 밖의 FUNDING.yml을 무시한다"
  done
fi

# 템플릿 디렉터리 (.github 아래만 유효)
for d in ISSUE_TEMPLATE DISCUSSION_TEMPLATE; do
  if [ -d ".github/$d" ] && find ".github/$d" -maxdepth 1 -type f 2>/dev/null | grep -q .; then
    printf '  ✓ %-24s .github/%s/\n' "$d/" "$d"
  else
    printf '  ✗ %-24s (없음, .github/%s/)\n' "$d/" "$d"
    MISSING="$MISSING $d/"
  fi
done

echo
if [ -n "$MISSING" ]; then
  echo "[부재]$MISSING"
else
  echo "[부재] 없음"
fi

# 형제 조직 .github 상속 감지
echo
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "$REPO")"
SIB="$(dirname "$ROOT")/.github"
if [ "$(basename "$ROOT")" = ".github" ]; then
  echo "[상속] 이 리포가 조직 .github 정본이다. 여기 문서가 하위 리포로 상속된다."
elif [ -e "$SIB/.git" ]; then
  echo "[상속] 형제 조직 .github 리포 감지: $SIB"
  echo "       이 리포에 상속 문서 사본을 만들면 정본을 덮어써 단일 출처를 깬다."
  echo "       (이슈 템플릿은 폴더 단위라 파일 하나만 둬도 정본 폴더 전체가 무시된다)"
  echo "       고유 문서가 필요한지 먼저 판단하고, 아니면 정본($SIB)을 편집하라."
else
  echo "[상속] 형제 조직 .github 리포 없음 → 단일 리포 모델. 자체 파일로 관리."
fi

# community profile (원격 있으면)
echo
if command -v gh >/dev/null 2>&1 && origin="$(git remote get-url origin 2>/dev/null)" && [ -n "$origin" ]; then
  slug="$(printf '%s' "$origin" | sed -E 's#^.*[:/]([^/]+/[^/]+)$#\1#; s#\.git$##')"
  if hp="$(gh api "repos/$slug/community/profile" --jq '.health_percentage' 2>/dev/null)"; then
    echo "[community profile] $slug: health_percentage=$hp%"
    echo "  주의: GitHub은 이 수치의 채점 항목을 공개하지 않는다. 관측상 파일이 아닌 리포 설명도"
    echo "  포함되고, SECURITY.md는 조직 소유 리포에서만 채점된다. SUPPORT·GOVERNANCE·FUNDING은"
    echo "  어느 경우에도 안 보인다. 완전성은 위 [존재]로 판단하라(references/github-standard.md)."
  else
    echo "[community profile] 조회 실패(비공개·미인증·원격 없음). 위 [존재]로 판단."
  fi
else
  echo "[community profile] gh 미설치 또는 origin 원격 없음 → skip"
fi
