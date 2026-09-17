---
name: systematic-debugging
description: Use when 버그·테스트 실패·예상 밖 동작·빌드 실패·성능 문제를 만났을 때.
---

# systematic-debugging

## Investigate before changing code

문제를 맡은 구현자가 실패 로그와 관련 코드에서 원인을 확인한 뒤 수정을 제안·적용한다. 재현되지 않으면 관측을 보강하고, 가설 하나를 최소 변경으로 검증한다. 원인 없이 수정 위에 수정을 쌓지 않는다.
실패를 재현하는 테스트나 일회성 스크립트로 수정 전 실패·수정 후 통과와 회귀 여부를 확인한다. 커맨드는 대상 리포 루트에서 실행한다.

수정이 3회 실패하면 같은 접근을 반복하지 않고 공유 상태·결합·아키텍처를 재검토한다. 더 수정하기 전에 사용자와 문제를 논의한다.
환경·외부 시스템 문제로 원인을 통제할 수 없으면 확인한 증거와 한계를 기록하고 필요한 대응을 검증한다.

출력은 원인 근거, 수정, 검증 결과와 남은 문제다. 완료 증거 확인은 `groundwork:verification-before-completion`을 따른다.

## Use the debugging assets

아래 자산은 이 스킬 디렉터리 기준이며 해당 문제가 있을 때만 확인한다.

- `find-polluter.sh`: 어느 테스트가 파일을 남기는지 찾을 때 사용법을 확인해 실행한다.
- `condition-based-waiting-example.ts`: 비동기 조건 대기 헬퍼가 필요할 때 활용한다.
