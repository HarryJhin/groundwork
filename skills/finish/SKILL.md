---
name: finish
description: 구현이 끝나고 테스트가 통과한 뒤 작업을 통합하는 방법을 정하고 산출물에 종료 표기를 남긴다. Use when 전 태스크 완료, 브랜치 마무리, 머지·PR 결정, 개발 종료.
---

# finish

**핵심 원칙**: 통합 결정은 사용자의 것이다.
그 결정을 받기 전에 무엇도 지우지 않는다.

## Terminology

이 문서는 두 종류의 디렉터리를 다루고 이름을 갈라 쓴다.
같은 말로 부르면 아래의 `git worktree remove`와 스크래치 삭제가 어느 쪽을 겨누는지 갈리지 않는다.

- **워크트리**: `groundwork:using-git-worktrees`(격리 워크스페이스를 확보하는 스킬)가 만든 git worktree.
  브랜치의 작업 트리이고 커밋된 코드가 여기 산다.
  이 스킬의 「Clean up the worktree」가 다루는 대상이다.
- **실행 스크래치**: 실행 스킬이 `design-scratch` 스크립트로 만든 `<repo 루트>/.groundwork/run/<설계 문서 파일명에서 확장자를 뺀 값>/`.
  워크트리 **안에** 있고 커밋되지 않는다.
  진행 기록·브리프·리뷰 패키지가 여기 모인다.
  이 스킬의 「Clean up the execution scratch」가 다루는 대상이다.

## Input, actors, output

**입력**은 셋이다.

- 방금 끝낸 작업의 워크트리. 커맨드는 그 안에서 시작한다.
- 실행한 설계 문서 파일의 경로.
  `groundwork:executing-design`이나 `groundwork:subagent-driven-development`(둘 다 승인된 설계 문서를 태스크로 쪼개 구현까지 끌고 가는 실행 스킬)가 이 스킬을 부를 때 함께 넘긴다.
  아래 본문에서 `DESIGN_FILE`은 그 경로를 가리키는 이름이고 셸 변수가 아니다.
  셸 커맨드에 넣을 때는 그 자리에 실제 경로를 적는다.
  받지 못했으면 사용자에게 묻고 사용자가 산출물이 없다고 하면 「Mark the artifact closed」를 건너뛴다.
- 실행 스크래치의 경로.
  같은 호출자가 함께 넘긴다.
  받지 못했으면 `${CLAUDE_PLUGIN_ROOT}/skills/executing-design/scripts/design-scratch DESIGN_FILE`을 돌려 얻는다.
  그 디렉터리가 없거나 `progress.md`가 없으면 실행 스킬이 이미 정리한 것이므로 「Report the outstanding findings」를 건너뛰고 그 사실을 사용자에게 밝힌다.

**주체**는 작업을 마친 에이전트다.
아래에서 무주어로 적은 지시는 전부 그 에이전트 몫이고 "사용자"는 통합을 결정하는 사람이다.

**경로 기준**: 이 문서의 경로는 두 기준으로 갈린다.
`${CLAUDE_PLUGIN_ROOT}/skills/executing-design/scripts/`의 스크립트는 groundwork 플러그인이 설치된 디렉터리 기준이고 `${CLAUDE_PLUGIN_ROOT}`는 실행 시점 작업 디렉터리가 아니다.
설계 문서 경로와 셸 블록이 도는 위치는 대상 repo의 워크트리 기준이다.

**출력**은 사용자가 고른 통합 방식의 실행 결과다.
선택과 그 결과, 워크트리·브랜치를 어떻게 처리했는지, 산출물에 종료 표기를 남겨 커밋했는지, 실행 스크래치를 지웠는지 남겼는지를 보고하고 끝낸다.

**절 순서가 곧 실행 순서다.**
「Confirm the tests」에서 「Clean up the execution scratch」까지 위에서 아래로 돈다.
순서를 바꾸면 아래 셋이 깨진다.
종료 표기는 통합보다 앞서야 그 커밋이 통합에 실린다.
잔여 발견 보고는 선택지 제시보다 앞서야 사용자가 그것을 알고 고른다.
스크래치 정리는 맨 뒤여야 앞의 둘이 읽을 진행 기록이 남아 있다.

## Confirm the tests

프로젝트의 전체 테스트 스위트를 돌린다.
아래에서 프로젝트에 맞는 커맨드를 골라 `TEST_CMD`에 담고 이후 단계는 그 값을 다시 쓴다.

```bash
TEST_CMD='npm test'   # 또는 'cargo test' / 'pytest' / 'go test ./...'
eval "$TEST_CMD"
```

**테스트가 실패하면** 실패를 보고하고 멈춘다.
선택 메뉴는 green 이후에 나온다.

```text
테스트 실패 (<N>건). 완료 전에 고쳐야 한다:

[실패 내용]
```

**테스트가 통과하면** 「Detect the environment」로 간다.

## Detect the environment

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
# 지금 잡아둔다. 워크트리 안에 있는 동안이어야 한다.
# 「Execute the choice」이 디렉터리를 옮기고 「Clean up the worktree」가 이 값을 필요로 한다
WORKTREE_PATH=$(git rev-parse --show-toplevel)
FEATURE_BRANCH=$(git branch --show-current)   # detached HEAD면 빈 문자열
```

**「Confirm the tests」부터 「Clean up the worktree」까지의 셸 블록은 같은 셸에서 돈다.**
여기서 잡은 값을 뒤 단계가 그대로 참조하므로 셸이 끊기면 이 블록부터 다시 돌린다.
값이 빈 채로 `git worktree remove`나 `git branch -d`를 실행하지 않는다.

어느 메뉴를 보일지와 정리 방식이 여기서 갈린다.
두 메뉴의 문안은 「Present the options」에 있다.

| 상태 | 메뉴 | 정리 |
|---|---|---|
| `GIT_DIR == GIT_COMMON` (일반 repo) | 표준 3선택 (「Present the options」) | 정리할 워크트리 없음 |
| `GIT_DIR != GIT_COMMON`, 이름 있는 브랜치 | 표준 3선택 (「Present the options」) | 출처 기반 (「Clean up the worktree」) |
| `GIT_DIR != GIT_COMMON`, detached HEAD | 축소 2선택 (「Present the options」, 머지 없음) | 외부 관리. 그대로 둔다 |

## Confirm the base branch

base 브랜치는 이 작업이 갈라져 나온 곳이다.
대개 설계 문서·대화·브랜치 upstream에 이름이 있다.
이미 알지 못하면 묻는다: "이 브랜치는 <추정>에서 갈라진 것으로 보이는데 맞습니까?"
머지 전에 확인한다.
잘못된 base로 머지하면 되돌리는 비용이 크다.

확인한 이름을 같은 셸에 담는다.
「Execute the choice」이 이 값을 쓴다.

```bash
BASE_BRANCH=<확인한 base 브랜치 이름>
```

## Report the outstanding findings

실행 스킬의 리뷰 루프는 고치지 못한 발견을 판정과 함께 보류한 채 끝날 수 있다.
그 보류가 사용자에게 도달하는 지점이 여기 하나뿐이다.
선택지를 제시하기 전에 낸다.

실행 스크래치의 `progress.md`에서 아래 세 종류의 줄을 걷어 온다.

| 진행 기록의 줄 | 뜻 |
|---|---|
| `태스크 <N>: 보류 — <발견> — 판정: <근거>` | 리뷰어의 발견을 고치지 않고 근거와 함께 넘겼다 |
| `태스크 <N>: minor(보류): <한 줄>` | Minor라서 루프에 넣지 않았다 |
| `태스크 <N>: 막힘 — <이유>` | 그 태스크에서 멈췄다 |

최종 리뷰가 남긴 발견도 함께 낸다.
그 발견은 진행 기록이 아니라 이 세션의 최종 리뷰 반환에 있다.

셋 다 없으면 "보류된 발견 없음" 한 줄을 내고 넘어간다.
있으면 아래 형식으로 낸다.

```text
보류된 발견 <N>건. 통합 전에 확인하십시오.

- [태스크 3] <발견> — 판정: <왜 코드가 유지되는가>
- [최종 리뷰] <발견> — 판정: <근거>
- [태스크 5 · minor] <한 줄>
```

**이것은 문항이 아니다.**
답을 요구하지 않고 곧바로 「Mark the artifact closed」로 간다.
사용자가 여기서 고치자고 하면 통합을 멈추고 그 발견을 처리한 뒤 이 스킬을 처음부터 다시 시작한다.

발견을 요약하거나 골라 내지 않는다.
보류 판정은 저자가 리뷰어의 반대를 무릅쓰고 내린 것이라 그 판정 자체가 사용자가 볼 대상이다.

## Mark the artifact closed

**통합보다 먼저 한다.**
아래 「Execute the choice」이 머지하거나 푸시하고 나면 이 변경을 실을 커밋이 없어진다.
선택 1은 브랜치를 지우고 선택 2는 이미 푸시된 뒤라 PR에 들어가지 않는다.

실행한 설계 문서에 `status: closed`를 기입한다.
종료 표기 대상은 설계 문서 하나다.
태스크 분해는 실행 스크래치의 진행 기록에만 있었고 그것은 커밋 산출물이 아니다.

기입 형식은 이렇다.
frontmatter 블록 내부의 `^status:` 라인만 교체한다(중복 삽입 금지).
라인이 없으면 여는 `---` 다음 줄에 삽입한다.
frontmatter 자체가 없으면 파일 최상단에 3행(`---` / `status: closed` / `---`)을 신설한다.
status 라인은 첫 10행 안에 둔다.

**기입하고 커밋한다.**
설계 문서는 커밋 산출물이라 커밋되지 않은 표기는 리포에 남지 않는다.

```bash
git add DESIGN_FILE
git commit -m "설계 문서를 종료 표기한다"
```

이 커밋이 `FEATURE_BRANCH`의 마지막 커밋이 되고 아래 통합이 그것을 함께 나른다.

종료 후 설계 문서를 고치면 `groundwork:design-review`를 다시 돌린다.

## Present the options

**일반 repo와 이름 있는 브랜치 워크트리에서는 정확히 이 3선택을 제시한다**:

```text
구현 완료. 무엇을 하시겠습니까?

1. <base-branch>에 로컬 머지
2. 푸시하고 Pull Request 생성
3. 브랜치를 그대로 둠 (직접 처리)

어느 것으로 할까요?
```

**detached HEAD에서는 정확히 이 2선택을 제시한다**:

```text
구현 완료. detached HEAD 상태입니다(외부 관리 워크트리).

1. 새 브랜치로 푸시하고 Pull Request 생성
2. 그대로 둠 (직접 처리)

어느 것으로 할까요?
```

메뉴를 적힌 그대로 간결하게 제시하고 모든 선택지를 위 목록에서 가져온다.
작업 폐기는 사용자가 명시로 요청할 때만 일어난다(아래 「The user asks to discard」).
답을 기다린다.
통합 결정은 사용자의 것이다.

## Execute the choice

「Present the options」에서 사용자가 고른 번호에 해당하는 절만 실행한다.

### Option 1: Local merge

```bash
# CWD 안전을 위해 메인 repo 루트를 얻는다
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"

# 먼저 머지한다. 무엇을 지우기 전에 성공을 확인한다
git checkout "$BASE_BRANCH"
git pull
git merge --ff-only "$FEATURE_BRANCH"

# 머지 결과에서 테스트를 확인한다
eval "$TEST_CMD"
```

`BASE_BRANCH`는 「Confirm the base branch」에서 확인한 base 브랜치 이름이다.
`--ff-only`가 기본이고 fast-forward가 불가해 거부되면 브랜치를 base 위로 rebase한 뒤 다시 ff로 머지한다.

```bash
git checkout "$FEATURE_BRANCH"
git rebase "$BASE_BRANCH"
git checkout "$BASE_BRANCH"
git merge --ff-only "$FEATURE_BRANCH"
```

머지 결과에서 테스트가 실패하면 멈추고 워크트리와 브랜치를 그대로 둔 채 조사한다.
아무것도 푸시되지 않았으므로 머지는 로컬이고 복구 가능하다.

머지 결과가 green이면 워크트리를 정리하고(「Clean up the worktree」) 브랜치를 지운다.

```bash
git branch -d "$FEATURE_BRANCH"
```

### Option 2: Push and open a pull request

```bash
git push -u origin "$FEATURE_BRANCH"
# detached HEAD에서는 원격에 새 브랜치 이름을 지정한다:
# git push origin HEAD:refs/heads/<new-branch>
```

그다음 `$BASE_BRANCH`를 대상으로 PR을 만든다.
코드 호스팅 서비스(GitHub·GitLab 등)의 도구를 쓴다.
CLI가 있으면 그것을, 없으면 푸시할 때 대부분의 서비스가 출력하는 생성 URL을 쓴다.
repo에 PR 템플릿·관례가 있으면 따르고 URL을 사용자에게 보고한다.
GitHub PR은 squash가 기본이다.

워크트리를 유지한다.
사용자가 거기서 PR 피드백을 반영한다.

### Option 3: Leave it as is

보고한다: "브랜치 <이름>을 유지합니다. 워크트리는 <경로>에 보존됩니다."

### The user asks to discard

이 경로는 작업을 버리라는 명시 요청에 대한 응답으로만 존재한다.
먼저 확인한다.

```text
다음이 영구 삭제됩니다:
- 브랜치 <이름>
- 전체 커밋: <커밋 목록>
- 워크트리 <경로>

확인하려면 'discard'를 입력하세요.
```

정확히 그 확인을 기다린다.
도착하면:

```bash
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"
```

그다음 워크트리를 정리하고(「Clean up the worktree」) 브랜치를 강제 삭제한다.

```bash
git branch -D "$FEATURE_BRANCH"
```

## Clean up the worktree

여기서 다루는 것은 워크트리다.
실행 스크래치는 아래 「Clean up the execution scratch」가 따로 다룬다.

**선택 1과 확인된 폐기에서만 돈다.**
선택 2와 3은 항상 워크트리를 보존한다.
두 호출자 모두 이미 메인 repo 루트로 디렉터리를 옮긴 상태다(워크트리 제거는 워크트리 밖에서 돌아야 한다).
그 이동 전에 「Detect the environment」에서 잡아둔 `GIT_DIR`·`GIT_COMMON`·`WORKTREE_PATH` 값을 쓴다.

**`GIT_DIR == GIT_COMMON`이면**: 일반 repo다.
정리할 워크트리가 없다.
끝.

**`WORKTREE_PATH`가 메인 repo 루트 바로 밑의 `.worktrees/`나 `worktrees/` 안이면**: `groundwork:using-git-worktrees`가 만든 워크트리다.
정리는 이 스킬 몫이다.
여기서 메인 repo 루트는 `$MAIN_ROOT`, 곧 `git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel`이 준 경로다.

```bash
git worktree remove "$WORKTREE_PATH"
git worktree prune  # 자가 치유: 낡은 등록을 정리한다
```

**그 외**: 호스트 환경이 이 워크트리를 소유한다.
그대로 둔다.
플랫폼에 워크스페이스 종료 도구가 있으면 그것을 쓴다.

## Clean up the execution scratch

**워크트리를 지운 경우에만 돈다**(선택 1과 확인된 폐기).
실행 스크래치는 워크트리 안에 살기 때문에 워크트리를 지우면 함께 사라진다.
따로 지울 것이 없고 그 사실만 보고에 적는다.

**선택 2와 3에서는 남긴다.**
PR 피드백과 이어지는 작업이 그 워크트리에서 일어나고, 진행 기록이 보류 판정과 막힘 사유를 담고 있어 그때 다시 읽힌다.
작업이 안착하기 전에 지우면 위 「Report the outstanding findings」가 근거로 삼은 것이 사라진다.

실행 스크래치를 지우는 시점은 여기 하나다.
실행 스킬은 지우지 않는다.
실행 스킬이 지우면 이 스킬의 「Report the outstanding findings」가 읽을 진행 기록이 없어진다.

## Quick reference

| 선택 | 종료 표기가 남나 | 머지 | 푸시 | 워크트리 유지 | 실행 스크래치 유지 | 브랜치 정리 |
|---|---|---|---|---|---|---|
| 1. 로컬 머지 | ○ | ○ | × | × | × | ○ |
| 2. PR 생성 | PR 머지 시 | × | ○ | ○ | ○ | × |
| 3. 그대로 둠 | 브랜치에 | × | × | ○ | ○ | × |
| 폐기 (명시 요청만) | × | × | × | × | × | ○ (강제) |

종료 표기는 어느 선택에서든 브랜치에 커밋된다.
그것이 base에 남는지는 통합 방식이 정한다.
폐기는 `git branch -D`가 브랜치를 지우면서 그 커밋도 함께 버리므로 표기가 남지 않는다.
버린 작업이 끝난 것으로 기록되지 않는다는 뜻이라 이것이 옳은 결과다.
폐기를 고른 경우 그 사실을 보고에 적는다.

## Common rationalizations

| 변명 | 실제 |
|---|---|
| "이번 세션 앞에서 테스트가 통과했다" | 통합하려는 그 트리에서 스위트를 돌린다. green 실행은 그것이 돌아간 트리만 증명한다. |
| "당연히 머지를 원할 것이다" | 통합은 사용자의 결정이다. 메뉴를 제시하고 기다린다. |
| "이 기능이 끝난 것 같으니 폐기를 제안하겠다" | 메뉴는 적힌 그대로 완결이다. 폐기는 사용자가 그렇게 말할 때만 일어난다. |
| "'응 없애줘'도 확인으로 친다" | 입력된 `discard`만 삭제를 승인한다. |
| "PR이 올라갔으니 워크트리는 잡동사니다" | PR 피드백은 그 워크트리에서 고친다. 작업이 안착할 때까지 남는다. |
| "이 다른 워크트리가 낡아 보이니 같이 정리하겠다" | `.worktrees/`나 `worktrees/` 밑만 정리한다. 나머지는 호스트의 것이다. |
| "머지 결과 실패는 아마 불안정 테스트다" | 실패한 머지 결과는 모든 것을 멈춘다. 조사하는 동안 브랜치와 워크트리는 그대로 둔다. |
| "base 브랜치는 당연히 main이다" | 분기점을 확인하거나 묻는다. 잘못된 base로 머지하면 되돌리는 비용이 크다. |
| "푸시가 거부됐으니 force push로 해결한다" | 거부된 푸시는 원격이 움직였다는 뜻이다. 조사한다. force push는 사용자의 명시 요청에만 한다. |
| "종료 표기는 마무리니까 맨 끝에 한다" | 맨 끝은 머지·푸시 뒤다. 그때 기입한 표기는 실을 커밋이 없어 리포에 남지 않는다. 통합보다 먼저 기입하고 커밋한다. |
| "status 라인만 고치는 건 커밋할 거리가 아니다" | 설계 문서는 커밋 산출물이다. 커밋하지 않은 표기는 작업 트리에만 있다가 사라진다. |
| "보류된 발견은 실행 스킬이 이미 판정했다" | 판정한 것은 저자이고 리뷰어는 반대했다. 사용자가 그 판정을 볼 지점이 이 스킬뿐이다. |
| "발견이 많으니 중요한 것만 추린다" | 추리는 것도 저자의 판정이다. 진행 기록의 보류·막힘 줄을 전부 낸다. |
| "스크래치는 잡동사니니 먼저 지운다" | 그 안에 「Report the outstanding findings」가 읽을 진행 기록이 있다. 지우는 시점은 이 스킬의 맨 끝 하나뿐이다. |
