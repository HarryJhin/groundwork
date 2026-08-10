---
name: finish
description: 구현이 끝나고 테스트가 통과한 뒤 작업을 통합하는 방법을 정하고 산출물에 종료 표기를 남긴다. Use when 전 태스크 완료, 브랜치 마무리, 머지·PR 결정, 개발 종료.
---

# finish

**핵심 원칙**: 통합 결정은 사용자의 것이다. 그 결정을 받기 전에 무엇도 지우지 않는다.

## 입력·주체·출력

**입력**은 방금 끝낸 작업의 워크스페이스다. 커맨드는 그 워크스페이스 안에서 시작한다. 7단계가 종료 표기할 스펙·플랜 파일의 경로는 호출자에게 받는다. `groundwork:executing-plan`이나 `groundwork:subagent-driven-development`가 이 스킬을 부를 때 실행한 플랜 경로와 그 플랜 Goal 절이 지목한 스펙 경로를 함께 넘긴다. 경로를 받지 못했으면 사용자에게 묻고 사용자가 산출물이 없다고 하면 7단계를 건너뛴다.

**주체**는 작업을 마친 에이전트다. 아래에서 무주어로 적은 지시는 전부 그 에이전트 몫이고 "사용자"는 통합을 결정하는 사람이다.

**출력**은 사용자가 고른 통합 방식의 실행 결과다. 선택과 그 결과, 워크트리·브랜치를 어떻게 처리했는지, 산출물에 종료 표기를 남겼는지를 보고하고 끝낸다.

## 1단계. 테스트 확인

프로젝트의 전체 테스트 스위트를 돌린다. 아래에서 프로젝트에 맞는 커맨드를 골라 `TEST_CMD`에 담고 이후 단계는 그 값을 다시 쓴다.

```bash
TEST_CMD='npm test'   # 또는 'cargo test' / 'pytest' / 'go test ./...'
eval "$TEST_CMD"
```

**테스트가 실패하면** 실패를 보고하고 멈춘다. 선택 메뉴는 green 이후에 나온다.

```
테스트 실패 (<N>건). 완료 전에 고쳐야 한다:

[실패 내용]
```

**테스트가 통과하면** 2단계로 간다.

## 2단계. 환경 탐지

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
# 지금 잡아둔다. 워크스페이스 안에 있는 동안이어야 한다.
# 5단계가 디렉터리를 옮기고 6단계 정리가 이 값을 필요로 한다
WORKTREE_PATH=$(git rev-parse --show-toplevel)
FEATURE_BRANCH=$(git branch --show-current)   # detached HEAD면 빈 문자열
```

**1단계부터 6단계까지의 셸 블록은 같은 셸에서 돈다.** 여기서 잡은 값을 뒤 단계가 그대로 참조하므로 셸이 끊기면 이 블록부터 다시 돌린다. 값이 빈 채로 `git worktree remove`나 `git branch -d`를 실행하지 않는다.

어느 메뉴를 보일지와 정리 방식이 여기서 갈린다. 두 메뉴의 문안은 4단계에 있다.

| 상태 | 메뉴 | 정리 |
|---|---|---|
| `GIT_DIR == GIT_COMMON` (일반 repo) | 표준 3선택 (4단계) | 정리할 워크트리 없음 |
| `GIT_DIR != GIT_COMMON`, 이름 있는 브랜치 | 표준 3선택 (4단계) | 출처 기반 (6단계) |
| `GIT_DIR != GIT_COMMON`, detached HEAD | 축소 2선택 (4단계, 머지 없음) | 외부 관리. 그대로 둔다 |

## 3단계. base 브랜치 확인

base 브랜치는 이 작업이 갈라져 나온 곳이다. 대개 플랜·대화·브랜치 upstream에 이름이 있다. 이미 알지 못하면 묻는다: "이 브랜치는 <추정>에서 갈라진 것으로 보이는데 맞습니까?" 머지 전에 확인한다. 잘못된 base로 머지하면 되돌리는 비용이 크다.

확인한 이름을 같은 셸에 담는다. 5단계가 이 값을 쓴다.

```bash
BASE_BRANCH=<확인한 base 브랜치 이름>
```

## 4단계. 선택지 제시

**일반 repo와 이름 있는 브랜치 워크트리에서는 정확히 이 3선택을 제시한다**:

```
구현 완료. 무엇을 하시겠습니까?

1. <base-branch>에 로컬 머지
2. 푸시하고 Pull Request 생성
3. 브랜치를 그대로 둠 (직접 처리)

어느 것으로 할까요?
```

**detached HEAD에서는 정확히 이 2선택을 제시한다**:

```
구현 완료. detached HEAD 상태입니다(외부 관리 워크스페이스).

1. 새 브랜치로 푸시하고 Pull Request 생성
2. 그대로 둠 (직접 처리)

어느 것으로 할까요?
```

메뉴를 적힌 그대로 간결하게 제시하고 모든 선택지를 위 목록에서 가져온다. 작업 폐기는 사용자가 명시로 요청할 때만 일어난다(아래 「사용자가 폐기를 요청하면」). 답을 기다린다. 통합 결정은 사용자의 것이다.

## 5단계. 선택 실행

### 선택 1: 로컬 머지

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

`BASE_BRANCH`는 3단계에서 확인한 base 브랜치 이름이다. `--ff-only`가 기본이고 fast-forward가 불가해 거부되면 브랜치를 base 위로 rebase한 뒤 다시 ff로 머지한다.

```bash
git checkout "$FEATURE_BRANCH"
git rebase "$BASE_BRANCH"
git checkout "$BASE_BRANCH"
git merge --ff-only "$FEATURE_BRANCH"
```

머지 결과에서 테스트가 실패하면 멈추고 워크트리와 브랜치를 그대로 둔 채 조사한다. 아무것도 푸시되지 않았으므로 머지는 로컬이고 복구 가능하다.

머지 결과가 green이면 워크트리를 정리하고(6단계) 브랜치를 지운다.

```bash
git branch -d "$FEATURE_BRANCH"
```

### 선택 2: 푸시하고 PR 생성

```bash
git push -u origin "$FEATURE_BRANCH"
# detached HEAD에서는 원격에 새 브랜치 이름을 지정한다:
# git push origin HEAD:refs/heads/<new-branch>
```

그다음 `$BASE_BRANCH`를 대상으로 PR을 만든다. 코드 호스팅 서비스(GitHub·GitLab 등)의 도구를 쓴다. CLI가 있으면 그것을, 없으면 푸시할 때 대부분의 서비스가 출력하는 생성 URL을 쓴다. repo에 PR 템플릿·관례가 있으면 따르고 URL을 사용자에게 보고한다. GitHub PR은 squash가 기본이다.

워크트리를 유지한다. 사용자가 거기서 PR 피드백을 반영한다.

### 선택 3: 그대로 둠

보고한다: "브랜치 <이름>을 유지합니다. 워크트리는 <경로>에 보존됩니다."

### 사용자가 폐기를 요청하면

이 경로는 작업을 버리라는 명시 요청에 대한 응답으로만 존재한다. 먼저 확인한다.

```
다음이 영구 삭제됩니다:
- 브랜치 <이름>
- 전체 커밋: <커밋 목록>
- 워크트리 <경로>

확인하려면 'discard'를 입력하세요.
```

정확히 그 확인을 기다린다. 도착하면:

```bash
MAIN_ROOT=$(git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel)
cd "$MAIN_ROOT"
```

그다음 워크트리를 정리하고(6단계) 브랜치를 강제 삭제한다.

```bash
git branch -D "$FEATURE_BRANCH"
```

## 6단계. 워크스페이스 정리

**선택 1과 확인된 폐기에서만 돈다.** 선택 2와 3은 항상 워크트리를 보존한다. 두 호출자 모두 이미 메인 repo 루트로 디렉터리를 옮긴 상태다(워크트리 제거는 워크트리 밖에서 돌아야 한다). 그 이동 전에 2단계에서 잡아둔 `GIT_DIR`·`GIT_COMMON`·`WORKTREE_PATH` 값을 쓴다.

**`GIT_DIR == GIT_COMMON`이면**: 일반 repo다. 정리할 워크트리가 없다. 끝.

**`WORKTREE_PATH`가 메인 repo 루트 바로 밑의 `.worktrees/`나 `worktrees/` 안이면**: `groundwork:using-git-worktrees`가 만든 워크트리다. 정리는 이 스킬 몫이다. 여기서 메인 repo 루트는 `$MAIN_ROOT`, 곧 `git -C "$(git rev-parse --git-common-dir)/.." rev-parse --show-toplevel`이 준 경로다.

```bash
git worktree remove "$WORKTREE_PATH"
git worktree prune  # 자가 치유: 낡은 등록을 정리한다
```

**그 외**: 호스트 환경이 이 워크스페이스를 소유한다. 그대로 둔다. 플랫폼에 워크스페이스 종료 도구가 있으면 그것을 쓴다.

## 7단계. 산출물 종료 표기

스펙과 플랜 **양쪽**에 `status: closed`를 기입한다.

기입 형식은 이렇다. frontmatter 블록 내부의 `^status:` 라인만 교체한다(중복 삽입 금지). 라인이 없으면 여는 `---` 다음 줄에 삽입한다. frontmatter 자체가 없으면 파일 최상단에 3행(`---` / `status: closed` / `---`)을 신설한다. status 라인은 첫 10행 안에 둔다.

종료 후 스펙을 고치면 `groundwork:spec-review`를, 플랜을 고치면 `groundwork:plan-review`를 다시 돌린다.

## 빠른 참조

| 선택 | 머지 | 푸시 | 워크트리 유지 | 브랜치 정리 |
|---|---|---|---|---|
| 1. 로컬 머지 | ○ | × | × | ○ |
| 2. PR 생성 | × | ○ | ○ | × |
| 3. 그대로 둠 | × | × | ○ | × |
| 폐기 (명시 요청만) | × | × | × | ○ (강제) |

## 흔한 합리화

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
