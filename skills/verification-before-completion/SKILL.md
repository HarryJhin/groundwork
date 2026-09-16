---
name: verification-before-completion
description: Use before claiming a change is complete, a bug is fixed, or a check passed.
---

# verification-before-completion

## Verify the claim

입력은 하려는 주장과 대상 변경이다. 요청·설계의 완료 기준을 리포 설정·CI와 대조해 그 주장을 판정할 검증 방법을 정한다. 테스트 인프라가 없어도 실행·관측·정적 검사 등 변경에 맞는 방법을 선택한다.
서비스의 완료 기준이 미정이면 `groundwork:finding-unknowns`로 확인한다.

검증을 실행하고 종료 코드·출력·검사 범위를 확인한다. 현재 대상 트리와 범위가 같은 기존 증거는 재사용할 수 있으며, 이후 변경이 영향을 준 검사는 다시 실행한다.
부분 검사로 전체 성공을 주장하지 않는다. 버그 수정은 원래 증상이 재현되는 검사로 확인하고, 회귀 테스트는 수정 전 실패·수정 후 통과를 확인한다.
위임한 구현은 실제 diff와 요구를 대조한다. 보고된 검증은 대상 커밋·명령·결과를 확인하고, 증거가 부족한 부분을 검증한다.

## Report the evidence

실행한 검사와 결과, 확인하지 못한 범위·실패·잔여 문제를 보고한다. 검증 수단이 없거나 검사가 실패하면 그 상태를 밝히고 통과를 주장하지 않는다.
