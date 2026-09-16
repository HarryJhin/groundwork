---
name: using-git-worktrees
description: Use when feature work needs isolation or an approved design is ready for implementation.
---

# using-git-worktrees

## Execution contract

입력은 작업 목표와 제공된 브랜치·경로 지시다. 출력은 작업 경로·브랜치·격리 수단·정리 주체와 시작 시점의 검증 결과다.
경로는 시작 리포 루트 기준이며, 준비 뒤의 검증은 작업 워크스페이스에서 실행한다.

## Detect and prepare isolation

`git rev-parse --git-dir`, `--git-common-dir`, `--show-superproject-working-tree`와 현재 브랜치를 확인한다. git 디렉터리와 공통 디렉터리의 실제 경로가 다르고 서브모듈이 아니면 연결된 워크트리다. 호스트가 이미 제공한 격리는 재사용하고 관리 주체를 기록한다.
사용자가 지정한 작업 방식·브랜치·경로를 따른다. 지정하지 않은 이름과 위치는 작업에서 정해 알리며, 작업 격리 자체를 허락받는 절차는 두지 않는다.
새 격리가 필요하면 실행 환경의 네이티브 워크트리 도구를 우선하고, 없으면 `git worktree add`를 쓴다.

수동 워크트리의 경로는 명시 지시 → 기존 `.worktrees/` → 기존 `worktrees/` → `.worktrees/` 순으로 고른다. 리포 내부 경로는 생성 전에 `git check-ignore`로 선택한 경로의 제외 여부를 확인한다. 제외되지 않았으면 `.gitignore`에 반영한다.
생성한 워크트리의 경로·브랜치·생성 주체를 기록해 `finish`에 넘긴다. 디렉터리 이름만으로 기존 워크트리를 에이전트 소유로 간주하지 않는다.
생성이 실패하면 원인을 조사한다. 제공된 작업 트리나 기능 브랜치에서 안전하게 진행할 수 있으면 사유를 알리고 사용한다. 사용자 지시 없이 main·master에서 구현하거나 기존 변경을 덮어쓰지 않는다.

## Set up and verify the baseline

리포 지침·잠금 파일·CI에서 필요한 셋업과 검증 명령을 확인한다. 파일 확장자만 보고 여러 패키지 관리자의 설치를 실행하지 않는다.
이번 변경과 관련된 시작 상태를 검증한다. 실패는 원인을 조사해 기존 문제와 작업의 막힘을 구분하고, 변경과 무관한 실패는 증거를 남긴 채 진행할 수 있다.
검증 방법은 에이전트가 정한다. 서비스의 완료 기준 자체가 미정일 때는 `groundwork:finding-unknowns`로 사용자와 결정한다.
