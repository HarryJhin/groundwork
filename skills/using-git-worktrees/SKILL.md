---
name: using-git-worktrees
description: 격리된 워크스페이스를 확보한다. 네이티브 도구를 우선하고 없을 때만 git worktree로 폴백한다. Use when 기능 작업 착수, 설계 실행 직전, 현재 워크스페이스와 분리가 필요할 때.
---

# using-git-worktrees

작업이 격리된 워크스페이스에서 일어나게 한다.
에이전트 실행 환경(이 스킬을 돌리는 코딩 에이전트 제품)이 워크트리 도구를 제공하면 그것을 우선한다.
없을 때만 수동 git worktree로 폴백한다.

**핵심 원칙**: 기존 격리를 먼저 탐지한다.
그다음 실행 환경의 도구. 그다음 git 폴백. 실행 환경과 싸우지 않는다.

## Input and output

**입력**은 새로 만들 브랜치 이름과 기능명이다.
호출자가 넘기면 그것을 쓰고 넘기지 않으면 지금 착수하는 작업에서 짓되 사용자에게 한 번 확인받는다.
워크트리 디렉터리 선호는 아래 「Directory selection」이 정한 순서로 찾는다.

**출력**은 준비된 워크스페이스의 경로와 브랜치 이름, 베이스라인 테스트 결과다.
「Confirm a clean baseline」의 보고 문안이 그 형식이고 워크트리를 만들지 않은 경로에서는 그 사실을 대신 보고한다.
이 스킬은 다음 단계로 자동으로 넘기지 않고 호출자에게 돌아간다.

**경로 기준**: 이 문서의 상대 경로는 두 시점으로 갈린다.
「Detect existing isolation」와 「Create the isolated workspace」의 경로는 시작 시점 repo 루트 기준이고 「Project setup」 이후의 경로는 새로 만든 워크스페이스 루트 기준이다.
각 셸 블록은 그 기준 디렉터리에서 돈다.

## Detect existing isolation

**무엇을 만들기 전에 이미 격리된 워크스페이스에 있는지 확인한다.**

```bash
GIT_DIR=$(cd "$(git rev-parse --git-dir)" 2>/dev/null && pwd -P)
GIT_COMMON=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd -P)
CURRENT_BRANCH=$(git branch --show-current)
```

**아래 셸 블록은 모두 같은 셸에서 돈다.**
여기서 잡은 값을 뒤 블록이 참조하므로 셸이 끊기면 이 블록부터 다시 돌린다.
`CURRENT_BRANCH`는 지금 있는 브랜치이고 1b에서 새로 만들 브랜치는 `NEW_BRANCH`로 따로 잡는다.

**서브모듈 가드**: `GIT_DIR != GIT_COMMON`은 git 서브모듈 안에서도 참이다.
"이미 워크트리다"라고 결론짓기 전에 서브모듈이 아닌지 확인한다.

```bash
# 경로가 나오면 워크트리가 아니라 서브모듈이다. 일반 repo로 취급한다
git rev-parse --show-superproject-working-tree 2>/dev/null
```

**`GIT_DIR != GIT_COMMON`이고 서브모듈이 아니면**: 이미 연결된 워크트리에 있다.
「Project setup」으로 건너뛴다.
워크트리를 또 만들지 않는다.

브랜치 상태와 함께 보고한다.
- 브랜치 위: "이미 격리된 워크스페이스 `<경로>`, 브랜치 `<이름>`."
- detached HEAD: "이미 격리된 워크스페이스 `<경로>`(detached HEAD, 외부 관리). 종료 시점에 브랜치 생성이 필요하다."

**`GIT_DIR == GIT_COMMON`이거나 서브모듈이면**: 일반 repo 체크아웃이다.

사용자가 워크트리 선호를 이미 밝혔는가.
프로젝트 지침 파일과 이 세션에 주어진 지침을 본다.
밝힌 것이 없으면 만들기 전에 동의를 구한다.

> "격리된 워크트리를 만들까요? 현재 브랜치를 변경에서 보호합니다."

이미 선언된 선호가 있으면 묻지 않고 따른다.
사용자가 거절하면 제자리에서 작업하고 「Project setup」으로 간다.

## Create the isolated workspace

이 순서로 시도한다.

### Native worktree tooling (preferred)

사용자가 격리 워크스페이스를 요청했다(「Detect existing isolation」에서 동의).
워크트리를 만드는 수단이 이미 있는가.
`EnterWorktree`·`WorktreeCreate` 같은 이름의 도구, `/worktree` 커맨드, `--worktree` 플래그일 수 있다.
있으면 그것을 쓰고 「Project setup」으로 간다.

네이티브 도구는 디렉터리 배치·브랜치 생성·정리를 자동으로 처리한다.
네이티브 도구가 있는데 `git worktree add`를 쓰면 실행 환경이 보지도 관리하지도 못하는 상태가 생긴다.

네이티브 워크트리 도구가 없을 때만 1b로 간다.

### git worktree fallback

**1a가 해당하지 않을 때만 쓴다.**
네이티브 도구가 없어 git으로 직접 워크트리를 만드는 경우다.

#### Directory selection

이 우선순위를 따른다.
명시된 사용자 선호가 관찰된 파일시스템 상태보다 항상 우선한다.

1. **프로젝트 지침 파일과 이 세션 지침에 선언된 워크트리 디렉터리 선호를 확인한다.**
   사용자가 이미 지정했으면 묻지 않고 쓴다.
2. **프로젝트 안의 기존 워크트리 디렉터리를 확인한다.**
   repo 루트에서 돌린다.
   ```bash
   ls -d .worktrees 2>/dev/null     # 우선(숨김)
   ls -d worktrees 2>/dev/null      # 대안
   ```
   있으면 쓴다.
   둘 다 있으면 `.worktrees`가 이긴다.
3. **다른 근거가 없으면** 프로젝트 루트의 `.worktrees/`를 기본으로 한다.

고른 결과를 같은 셸에 담는다.
아래 안전 확인과 워크트리 생성이 이 값을 쓴다.

```bash
LOCATION=<위에서 고른 디렉터리>   # 예: .worktrees
NEW_BRANCH=<새로 만들 브랜치 이름>
```

#### Safety check (project-internal directories only)

**워크트리를 만들기 전에 디렉터리가 ignore되는지 반드시 확인한다.**

```bash
git check-ignore -q "$LOCATION"
```

`$LOCATION`이 위에서 고른 그 디렉터리다.
후보 둘을 함께 검사하면 고르지 않은 쪽이 ignore돼 있다는 이유로 통과해버린다.

**ignore되지 않으면**: .gitignore에 추가하고 그 변경을 커밋한 뒤 진행한다.

**왜 중요한가**: 워크트리 내용물이 통째로 리포에 커밋되는 것을 막는다.

#### Create the worktree

```bash
path="$LOCATION/$NEW_BRANCH"

git worktree add "$path" -b "$NEW_BRANCH"
cd "$path"
```

**샌드박스 폴백**: `git worktree add`가 권한 에러(샌드박스 거부)로 실패하면 샌드박스가 워크트리 생성을 막아 현재 디렉터리에서 작업한다고 사용자에게 알린다.
그다음 셋업과 베이스라인 테스트를 제자리에서 돌린다.

## Project setup

프로젝트 유형을 탐지해 해당 셋업을 돌린다.

```bash
if [ -f package.json ]; then npm install; fi
if [ -f Cargo.toml ]; then cargo build; fi
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
if [ -f pyproject.toml ]; then poetry install; fi
if [ -f go.mod ]; then go mod download; fi
```

## Confirm a clean baseline

워크스페이스가 깨끗한 상태에서 시작하는지 테스트로 확인한다.

```bash
TEST_CMD='npm test'   # 또는 'cargo test' / 'pytest' / 'go test ./...'
eval "$TEST_CMD"
```

**테스트가 실패하면**: 실패를 보고하고 진행할지 조사할지 묻는다.

**테스트가 통과하면**: 어느 경로로 왔는지에 맞춰 보고한다.

워크트리를 새로 만들었으면(1a·1b 성공):
```text
워크트리 준비 완료: <전체 경로>
테스트 통과 (<N>개, 실패 0)
<기능명> 구현 준비됨
```

이미 격리된 워크스페이스였으면(「Detect existing isolation」에서 건너뜀):
```text
기존 워크스페이스 사용: <전체 경로>, 브랜치 <이름>
테스트 통과 (<N>개, 실패 0)
<기능명> 구현 준비됨
```

워크트리를 만들지 못했으면(사용자 거절 또는 샌드박스 폴백):
```text
격리 없이 현재 디렉터리에서 작업: <전체 경로> (<사유>)
테스트 통과 (<N>개, 실패 0)
<기능명> 구현 준비됨
```

## Quick reference

| 상황 | 행동 |
|---|---|
| 이미 연결된 워크트리 | 생성 건너뜀 (「Detect existing isolation」) |
| 서브모듈 안 | 일반 repo로 취급 (「Detect existing isolation」의 가드) |
| 네이티브 워크트리 도구 있음 | 그것을 쓴다 (1a) |
| 네이티브 도구 없음 | git worktree 폴백 (1b) |
| `.worktrees/` 존재 | 쓴다 (ignore 확인) |
| `worktrees/` 존재 | 쓴다 (ignore 확인) |
| 둘 다 존재 | `.worktrees/` |
| 둘 다 없음 | 지침 확인 후 `.worktrees/` 기본 |
| 디렉터리가 ignore 안 됨 | .gitignore 추가 + 커밋 |
| 생성 시 권한 에러 | 샌드박스 폴백, 제자리 작업 |
| 베이스라인 테스트 실패 | 실패 보고 + 확인 |
| package.json·Cargo.toml 없음 | 의존성 설치 건너뜀 |

## Common rationalizations

| 변명 | 실제 |
|---|---|
| "워크트리가 아닌 게 뻔한데 확인이 필요한가" | 「Detect existing isolation」를 돌린다. 실행 환경이 만든 격리와 서브모듈은 둘 다 눈으로는 속는다. 탐지 커맨드가 결론을 낸다. |
| "네이티브 도구 찾느니 `git worktree add`가 빠르다" | 네이티브 도구가 배치·브랜치·정리를 소유한다. 우회는 가장 흔한 실수이고 실행 환경이 보지도 관리하지도 못하는 상태를 만든다. |
| "워크트리 디렉터리는 당연히 ignore돼 있다" | `git check-ignore`를 돌린다. ignore되지 않은 워크트리 디렉터리는 트리 전체를 리포에 커밋한다. |
| "디렉터리 이름은 아무거나 된다" | 명시된 사용자 선호가 기존 프로젝트 디렉터리를 이기고 그것이 `.worktrees/` 기본을 이긴다. |
| "워크스페이스가 새것이니 베이스라인 테스트는 나중에" | 더러운 베이스라인은 이후 모든 실패를 모호하게 만든다. 지금 돌린다. 실패를 넘어 진행할지는 사용자가 정한다. |
