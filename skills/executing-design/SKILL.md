---
name: executing-design
description: Use when implementing an approved design document in the current session.
---

# executing-design

## Execution contract

입력은 승인된 설계 문서 경로다. 메인 실행자가 구현하고 태스크 리뷰만 격리한다. 대화와 리포에서 실행할 설계가 하나로 식별되면 그 경로를 쓴다. 대상이 모호하면 어떤 설계를 실행할지 확인한다.
출력은 구현·검증 결과와 설계 변경·잔여 문제다. 설계 경로와 실행 스크래치 경로를 `groundwork:finish`에 함께 넘긴다.
작업 경로는 리포 루트 기준, `scripts/`와 아래 프롬프트 링크는 이 스킬 디렉터리 기준이다. 커맨드는 작업 리포에서 실행하고 스크립트는 설치된 스킬의 실제 경로로 호출한다.
태스크 사이에 계속할지 묻지 않는다. 기술 문제는 자율 해결하고 새로운 도메인 결과·범위 변경 또는 해소할 수 없는 막힘은 설명하고 확인한다.

## Choose the execution path

구현은 이 세션에서 직접 하는 것이 기본이다. 태스크가 여럿이고 독립적이며 기계적이고, 약한 모델의 비용 이득이 전달·재구성 비용을 넘으면 `groundwork:subagent-driven-development`를 쓸 수 있다.

## Set up and resume

`groundwork:using-git-worktrees`로 작업 격리를 확보하거나 이미 제공된 작업 트리를 확인한다. 사용자의 명시 지시 없이 main·master에서 구현하지 않는다.
실행 스크래치는 git worktree와 다르다. 아래의 `DESIGN_FILE`, `BASE`, `HEAD`, `FIX_BASE`, `MERGE_BASE`는 실제 설계 경로와 해당 커밋으로 치환할 자리다. 셸 변수로 가정하지 않는다.

1. `scripts/design-scratch DESIGN_FILE`을 호출해 stdout의 경로를 스크래치로 쓴다. `.groundwork/run/<design-basename>/`에 진행 기록과 리뷰 패키지가 모인다.
2. `<scratch>/progress.md` 첫 줄에 설계 경로를 적는다. 다른 설계를 가리키는 기록은 사용하지 않는다.
3. 태스크 목록·완료 커밋·수정 라운드·중요 판단·보류 문제·검증 결과를 기록한다. 완료한 태스크는 반복하지 않고 미완료 태스크나 열린 수정 라운드부터 재개한다.
4. 압축 후에는 진행 기록과 `git log`를 확인한다. 스크래치가 지워졌으면 커밋에서 복원하고 확인할 수 없는 잔여는 밝힌다.

스크래치는 `finish`에 넘기기 전 지우지 않는다.

## Break the work into tasks

설계의 목표·흐름·수용 기준과 전역 제약을 읽는다.
태스크는 자기 산출물과 의미 있는 검증·리뷰 경계를 가진 단위로 가른다. 셋업·설정·문서는 해당 기능 태스크에 포함하고, 강결합 변경은 합친다.
각 태스크에 변경 파일과 책임, 선행 태스크, 이웃 태스크와 주고받는 정확한 인터페이스, 검증 방법을 적는다. 심볼과 사양은 조사로 확인한다.
분해는 todo와 진행 기록에 남긴다. 착수 전 태스크 제목과 완료 시 동작을 짧게 알리고 승인 답을 기다리지 않는다.
테스트 인프라가 없으면 변경을 판정할 검증 방법을 스스로 정해 기록한다.

## Task loop

### Implement and verify

태스크 시작 커밋을 `BASE`로 기록한다. 테스트 가능한 동작은 실패하는 테스트부터 구현하고, 변경에 맞는 검증을 실행해 출력을 확인한다. 테스트·디버깅 방법에 도움이 필요할 때만 해당 스킬을 읽는다.
태스크를 마치면 작업 트리의 빌드·관련 테스트를 확인하고 커밋한 끝을 `HEAD`로 기록한다.

### Review the task

`scripts/review-package DESIGN_FILE BASE HEAD`로 커밋 목록·stat·diff 파일을 만든다. stdout의 경로를 리뷰어에게 넘기고 패키지 내용을 메인 컨텍스트에 복사하지 않는다.
[task-reviewer-prompt.md](task-reviewer-prompt.md)에 태스크 요구, 설계의 정확한 값·형식·관계 제약, 구현 주장과 검증 결과, 패키지 경로를 동봉한다. 메인 구현에서는 브리프·리포트 파일 대신 해당 내용을 넘길 수 있다.
리뷰는 설계 준수와 코드 품질을 모두 판정한다. 구현자는 리뷰어가 보기도 전에 발견의 심각도나 표시 여부를 제한하지 않는다.
diff로 확인할 수 없는 요구는 메인이 실제 공백인지 판단한다.

### Resolve findings

기술 발견은 근거를 확인해 해결한다. 설계의 구현 지시와 리뷰가 충돌해도 동일 서비스 계약을 만족하면 에이전트가 정하고 필요한 문서·기록을 갱신한다.
정책 변경 제안은 사용자 영향·목표·제약의 새 근거를 확인한다. 재검토가 필요하면 기존 합의와 달라진 점을 `groundwork:finding-unknowns`의 [Explain the decision before asking](../finding-unknowns/SKILL.md#explain-the-decision-before-asking)에 따라 설명하고 사용자와 결정한다. 구현 편의만을 근거로 한 제안은 기각한다.
Minor는 진행 기록에 보류하고 최종 리뷰로 넘긴다. 설계 준수 실패·실제 공백·Critical·Important는 수정하고 덮는 검증을 다시 실행한다.
수정 패키지는 `scripts/review-package DESIGN_FILE FIX_BASE HEAD`로 만들고 [re-review-prompt.md](re-review-prompt.md)에 직전 발견과 새 검증 결과를 넘긴다. `FIX_BASE`는 직전 리뷰가 본 head다.
태스크당 수정·범위 한정 재리뷰는 최대 3라운드다. 라운드와 커밋·열린 발견을 기록한다.
상한에서도 남으면 실행자가 판정과 근거를 기록한다. 오탐·논쟁 사항이나 뒤 작업이 의존하지 않는 실제 문제는 보류할 수 있다. 뒤 작업이 의존하는 실제 파손은 멈추고 설명한다.
완료 줄에는 커밋과 보류 건수를 적고 다음 태스크로 간다.

## Final review and handoff

기본 브랜치와 현재 브랜치의 분기 커밋을 `MERGE_BASE`로 확인한다. `scripts/review-package DESIGN_FILE MERGE_BASE HEAD` 패키지와 보류 기록을 격리된 리뷰어에게 `groundwork:requesting-code-review`로 넘긴다.
최종 발견은 한 묶음으로 고치고 수정 범위 재리뷰를 한 번 한다. 남은 발견은 판정·근거와 함께 보류하거나 의존 작업을 멈춘다. 반복 라운드를 늘리지 않는다.
구현·검증 결과, 설계와 달라진 결정, 잔여 문제를 보고하고 설계 경로·스크래치 경로를 `groundwork:finish`에 넘긴다. 정리는 그 스킬이 통합 처리 후 한다.

## Revise the design document

구현 실수면 코드를 고친다. 설계의 정책·기술 결정·가정이 바뀌면 해당 문서를 고치고 `updated`를 갱신한다.
변경된 계약이 기존 구현에 미치는 영향을 확인해 맞추고 리뷰한다. 문서만 실제 코드에 맞춰 계약 위반을 지우지 않는다.
