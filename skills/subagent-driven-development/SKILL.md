---
name: subagent-driven-development
description: Use when an approved design document has many independent mechanical tasks that benefit from isolated implementers.
---

# subagent-driven-development

## Execution contract

입력은 승인된 설계 문서 경로다. 메인 컨트롤러가 분해·조정을 맡고 태스크별 구현자와 리뷰어를 격리한다. 실행 대상 식별과 경로 기준은 `groundwork:executing-design`의 [Execution contract](../executing-design/SKILL.md#execution-contract)를 따른다.
출력은 구현·검증 결과와 설계 변경·잔여 문제이며 설계 경로·실행 스크래치 경로를 `groundwork:finish`에 함께 넘긴다.
이 스킬의 링크는 스킬 디렉터리 기준, 작업 경로는 리포 루트 기준이다.

## Choose and prepare

태스크가 여럿이고 독립적·기계적이며, 모델 비용 이득이 전달·재구성 비용을 넘을 때 쓴다. 아니면 메인이 `groundwork:executing-design`으로 직접 구현한다.
설계 읽기·스크래치 확보·진행 기록·재개·태스크 분해는 `groundwork:executing-design`의 [Set up and resume](../executing-design/SKILL.md#set-up-and-resume)와 [Break the work into tasks](../executing-design/SKILL.md#break-the-work-into-tasks)를 따른다.

## Dispatch an implementer

태스크 요구·정확한 인터페이스와 제약·검증 방법을 `<scratch>/task-<N>-brief.md`에 적는다. 새 구현자에게 브리프 경로와 작업 경로를 [implementer-prompt.md](implementer-prompt.md)로 넘긴다.
같은 파일이나 상태를 바꾸는 구현자는 동시에 실행하지 않는다. 컨트롤러는 자기 세션 전체나 이미 파일에 있는 본문을 디스패치 메시지에 복사하지 않는다.
구현자는 `<scratch>/task-<N>-report.md`에 변경·검증 커맨드와 출력·커밋·잔여 문제를 적고 최종 응답에는 경로와 상태만 반환한다.

## Review and resolve

태스크 시작·끝 커밋을 기록하고 `groundwork:executing-design`의 [Review the task](../executing-design/SKILL.md#review-the-task)에 따라 패키지 경로·브리프·리포트·정확한 제약을 격리된 리뷰어에게 넘긴다.
발견의 결정 권한은 `groundwork:executing-design`의 [Resolve findings](../executing-design/SKILL.md#resolve-findings)를 따른다.
수정은 구현자에게 맡기고 검증 결과를 리포트에 덧붙이게 한다. 재리뷰는 수정 diff와 직전 발견만 다룬다.
이 경로의 상한은 태스크당 5라운드다. 1~3라운드는 기존 구현자를 재개하고, 4~5라운드는 더 유능한 새 구현자에게 파일로 맥락을 넘긴다. 라운드·커밋·발견·판정을 진행 기록에 남긴다.
상한 뒤에는 컨트롤러가 근거와 함께 판정한다. 뒤 작업이 의존하는 실제 파손은 멈추고, 나머지는 보류 기록으로 최종 리뷰에 넘긴다.
최종 리뷰와 설계 개정은 `groundwork:executing-design`의 [Final review and handoff](../executing-design/SKILL.md#final-review-and-handoff)와 [Revise the design document](../executing-design/SKILL.md#revise-the-design-document)를 따른다. 스크래치나 워크트리를 먼저 지우지 않는다.
