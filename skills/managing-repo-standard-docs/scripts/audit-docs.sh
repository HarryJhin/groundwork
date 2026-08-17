#!/usr/bin/env bash
# 리포 표준 문서 감사 (읽기 전용). SKILL.md 「Audit the repository」.
# 사용: bash audit-docs.sh [repo_dir]
# 출력: 문서별 존재·위치, 부재 목록, community profile.
# 쓰기·수정 없음. git·(선택)gh만 사용.
set -u

REPO="${1:-$PWD}"
cd "$REPO" 2>/dev/null || { echo "경로 없음: $REPO" >&2; exit 1; }

# 3개 위치(.github → 루트 → docs)에서 인식되고 파일명 대소문자 규정이 없거나
# 전대문자 규정이 있는 문서. 정확 매칭한다.
# CONTRIBUTING·PR 템플릿·CHANGELOG·이슈 템플릿은 판정이 달라 아래에서 따로 처리한다.
FILES="README.md CODE_OF_CONDUCT.md SECURITY.md SUPPORT.md GOVERNANCE.md"

# name을 .github → . → docs 순으로 탐색해 첫 매칭 경로를 출력한다. 없으면 rc=1.
# 둘째 인자가 "i"면 파일명 대소문자를 무시한다. GitHub이 "not case sensitive"라고
# 명시한 CONTRIBUTING과 PR 템플릿에만 쓴다.
locate() {
  local name="$1" nocase="${2:-}" loc found flag="-name"
  [ "$nocase" = "i" ] && flag="-iname"
  for loc in .github . docs; do
    [ -d "$loc" ] || continue
    found="$(find "$loc" -maxdepth 1 "$flag" "$name" 2>/dev/null | head -1)"
    if [ -n "$found" ]; then
      printf '%s\n' "${found#./}"; return 0
    fi
  done
  return 1
}

# 다중 PR 템플릿은 지원 폴더 안 PULL_REQUEST_TEMPLATE/ 디렉터리 형태로도 유효하다.
locate_pr_dir() {
  local d
  for d in .github/PULL_REQUEST_TEMPLATE PULL_REQUEST_TEMPLATE docs/PULL_REQUEST_TEMPLATE; do
    if [ -d "$d" ] && find "$d" -maxdepth 1 -type f 2>/dev/null | grep -q .; then
      printf '%s/\n' "$d"; return 0
    fi
  done
  return 1
}

echo "=== 리포 표준 문서 감사: $REPO ==="
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

# CONTRIBUTING과 PR 템플릿은 파일명 대소문자를 가리지 않는다.
if p="$(locate CONTRIBUTING.md i)"; then
  printf '  ✓ %-24s %s\n' "CONTRIBUTING.md" "$p"
else
  printf '  ✗ %-24s (없음)\n' "CONTRIBUTING.md"
  MISSING="$MISSING CONTRIBUTING.md"
fi

if p="$(locate_pr_dir)" || p="$(locate PULL_REQUEST_TEMPLATE.md i)"; then
  printf '  ✓ %-24s %s\n' "PULL_REQUEST_TEMPLATE" "$p"
else
  printf '  ✗ %-24s (없음)\n' "PULL_REQUEST_TEMPLATE"
  MISSING="$MISSING PULL_REQUEST_TEMPLATE.md"
fi

# CHANGELOG는 GitHub이 인식하지 않는다. Keep a Changelog가 정한 위치는 리포 루트다.
if [ -f "CHANGELOG.md" ]; then
  printf '  ✓ %-24s CHANGELOG.md\n' "CHANGELOG.md"
else
  printf '  ✗ %-24s (없음, 루트)\n' "CHANGELOG.md"
  MISSING="$MISSING CHANGELOG.md"
fi

# 이슈 템플릿은 .github/ISSUE_TEMPLATE/ 아래만 유효하다.
if [ -d ".github/ISSUE_TEMPLATE" ] && find ".github/ISSUE_TEMPLATE" -maxdepth 1 -type f 2>/dev/null | grep -q .; then
  printf '  ✓ %-24s .github/ISSUE_TEMPLATE/\n' "ISSUE_TEMPLATE/"
else
  printf '  ✗ %-24s (없음, .github/ISSUE_TEMPLATE/)\n' "ISSUE_TEMPLATE/"
  MISSING="$MISSING ISSUE_TEMPLATE/"
  for stray in ISSUE_TEMPLATE docs/ISSUE_TEMPLATE; do
    [ -d "$stray" ] && echo "    ! $stray/ 이 있으나 GitHub은 .github/ 밖의 이슈 템플릿을 무시한다"
  done
fi

echo
if [ -n "$MISSING" ]; then
  echo "[부재]$MISSING"
else
  echo "[부재] 없음"
fi

# community profile (원격 있으면)
echo
if command -v gh >/dev/null 2>&1 && origin="$(git remote get-url origin 2>/dev/null)" && [ -n "$origin" ]; then
  slug="$(printf '%s' "$origin" | sed -E 's#^.*[:/]([^/]+/[^/]+)$#\1#; s#\.git$##')"
  if hp="$(gh api "repos/$slug/community/profile" --jq '.health_percentage' 2>/dev/null)"; then
    echo "[community profile] $slug: health_percentage=$hp%"
    echo "  주의: GitHub은 이 수치의 채점 항목을 공개하지 않는다. 위 [존재]와 채점 항목은 다르다."
    echo "  채점에는 들어가지만 이 스킬이 감사하지 않는 것: 리포 설명(description), LICENSE."
    echo "  감사하지만 채점에 안 들어가는 것: SUPPORT, GOVERNANCE, CHANGELOG."
    echo "  SECURITY.md는 조직 소유 리포에서만 채점된다."
    echo "  그래서 [부재] 없음인데 100%가 아닐 수 있다. LICENSE나 리포 설명을 먼저 확인하라."
    echo "  완전성은 위 [존재]로 판단한다(references/github-standard.md)."
  else
    echo "[community profile] 조회 실패(비공개·미인증·원격 없음). 위 [존재]로 판단."
  fi
else
  echo "[community profile] gh 미설치 또는 origin 원격 없음 → skip"
fi
