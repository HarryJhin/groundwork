# ADR-0011: Define the handoff between the execution skills and finish

## Title

실행 스킬이 `finish`에 넘기는 것을 둘로 못박고, 삭제 권한을 `finish` 하나로 모으고, 종료 표기를 통합보다 앞에 두어 커밋되게 한다.
스크래치 디렉터리를 워크트리와 이름으로 갈라 `design-workspace`를 `design-scratch`로 개명한다.

## Status

Accepted

`docs/adr/ADR-0008-collapsing-the-plan-stage.md`의 후속이다.
그 문서가 없앤 플랜 승인 게이트가 실행 구간과 종료 구간 사이의 마지막 동기화 지점이었고, 그것이 사라진 뒤 남은 계약 공백을 메운다.
ADR-0008의 결정을 뒤집지 않는다.

## Date

2026-08-16

## Context

### Terminology

이 리포의 스킬은 `skills/<이름>/SKILL.md`에 있고 아래에서 `groundwork:<이름>` 형태로 가리킨다.

- **flow**: groundwork가 강제하는 스킬 사슬.
  설계에서 종료까지 이어진다.
  진입 규율은 `skills/using-groundwork/SKILL.md`에 있다.
- **실행 스킬**: 승인된 설계 문서를 태스크로 쪼개 구현까지 끌고 가는 스킬.
  기본 경로인 `groundwork:executing-design`과 조건부 경로인 `groundwork:subagent-driven-development` 둘을 함께 가리킨다.
- **워크트리**: `groundwork:using-git-worktrees`가 만드는 git worktree.
  브랜치의 작업 트리이고 커밋된 코드가 여기 산다.
- **실행 스크래치**: 실행 스킬이 워크트리 안에 만드는 `<repo 루트>/.groundwork/run/<설계 문서 파일명에서 확장자를 뺀 값>/`.
  커밋되지 않는다.
  `.groundwork/`가 자기 자신을 무시하는 `.gitignore`를 지녀 `git status`에 나타나지 않는다.
- **진행 기록**: 실행 스크래치의 `progress.md`.
  태스크 완료 줄과 함께 보류 판정·보류 Minor·막힘 사유를 담는다.
- **fix 루프**: 태스크 리뷰가 낸 발견을 고치고 다시 리뷰받는 순환.
  실행 스킬이 라운드 상한을 두고 돌린다.
- **보류**: fix 루프의 상한에서 발견을 고치지 않고 근거와 함께 넘긴 처리.
  진행 기록에 판정과 그 근거를 적는다.
- **렌즈**: 설계 문서를 한 가지 관점에서만 판정하는 리뷰어.
  `groundwork:design-review`가 서브에이전트로 띄운다.
- **`junior-read`**: 렌즈 하나.
  맥락 없는 독자가 문서만으로 이해하고 실행할 수 있는지를 본다.
  판정 기준은 `groundwork:writing-for-junior`가 소유한다.
- **TDD**: 테스트 주도 개발(test-driven development).
  구현보다 테스트를 먼저 쓰고 실패를 확인한 뒤 통과시킬 최소 구현을 쓰는 절차.
  이 리포의 정본은 `groundwork:test-driven-development`다.

flow의 마지막 두 단계는 실행 스킬과 `groundwork:finish`다.
둘 사이의 계약이 한쪽에만 적혀 있었고 그 결과 네 문제가 있었다.

### One word pointed at two directories

`groundwork:executing-design`의 「Setup」이 네 줄 간격으로 `워크스페이스`를 두 뜻으로 썼다.
앞은 워크트리이고 뒤는 `design-workspace` 스크립트가 만든 실행 스크래치였다.

같은 스킬의 「Handoff」가 `rm -rf <workspace>`를 지시했다.
앞 정의를 잡은 에이전트는 커밋된 코드가 든 워크트리를 지운다.
통합 결정 전에 브랜치 작업이 사라지는 경로이고 스크립트 이름의 `workspace`가 그 오독을 뒷받침했다.

### finish lacked the report the execution skills promised

두 실행 스킬이 "남은 그 발견은 `groundwork:finish`가 선택지를 제시할 때 사용자에게 올라간다"고 적었다.
`groundwork:finish` 본문에 `발견`도 `보류`도 나오지 않았다.
그 스킬의 「Present the options」는 메뉴를 "정확히 이 3선택"으로 못박아 다른 것을 붙이지 못하게 한다.
리뷰어의 반대를 무릅쓰고 내린 보류 판정이 사용자에게 도달할 경로가 실제로는 없었다.

근거가 되는 진행 기록도 `groundwork:finish` 호출 **전에** 지워졌다.
실행 스킬의 「Handoff」가 실행 스크래치를 삭제한 뒤 그 스킬을 부르는 순서였다.
`groundwork:finish`는 그 사실을 "그 워크스페이스는 실행 스킬이 이미 지웠다"로 적어 두었다.
두 문서가 서로를 근거로 삼아 같은 정보를 버리고 있었다.

### status: closed was never committed

`groundwork:finish`의 절 순서가 선택 실행 → 워크스페이스 정리 → 산출물 종료 표기였다.
그 스킬의 선택 1은 base 브랜치로 머지한 뒤 `git branch -d`로 작업 브랜치를 지우고, 선택 2는 원격에 푸시하고 Pull Request를 만든다.
어느 쪽이든 종료 표기를 기입하는 시점에는 그 변경을 실을 커밋이 남지 않는다.
「Mark the artifact closed」에 커밋 지시도 없었다.

설계 문서는 커밋 산출물이고 `status`는 그 수명 표기다.
표기가 리포에 남지 않았다.

### Two skills defined the task review differently

`groundwork:requesting-code-review`가 "필수: 실행 스킬로 설계 문서를 실행할 때 각 태스크 후"를 자기 리뷰 시점으로 선언하고 `BASE_SHA=$(git rev-parse HEAD~1)`로 시작하는 절차를 제시했다.

같은 자리의 실행 스킬 절차는 다르다.
태스크 시작 커밋을 `BASE`로 기록해 두고 `skills/executing-design/scripts/review-package`로 넘긴다.
`groundwork:subagent-driven-development`는 `HEAD~1`을 "절대 쓰지 않는다"로 금지한다.
커밋이 여럿인 태스크에서 마지막 하나만 남기고 나머지를 버리기 때문이다.

TDD 루프가 태스크당 여러 커밋을 만드는 것이 기본이다.
`skills/using-groundwork/SKILL.md`의 정본 표가 코드 리뷰 요청의 정본으로 `groundwork:requesting-code-review`를 지목하므로, 그 표를 따라 이 스킬을 로드한 에이전트는 태스크 diff의 대부분을 리뷰 없이 통과시킨다.

## Decision

### Separate the names of the two directories

워크트리와 실행 스크래치를 각각 그 이름으로 부른다.
두 실행 스킬과 `groundwork:finish`가 자기 첫머리에 그 구분을 정의한다.
스크립트를 `design-scratch`로 개명한다.
이름에 `workspace`가 남으면 다음 독자가 같은 오독을 한다.

### Concentrate deletion rights in finish

실행 스킬은 워크트리도 실행 스크래치도 지우지 않는다.
`groundwork:finish`가 워크트리를 지운 경우에만 실행 스크래치가 함께 사라진다.
그 스킬의 선택 2와 선택 3에서는 둘 다 남는다.
Pull Request 피드백이 그 워크트리에서 일어나고 진행 기록이 그때 다시 읽히기 때문이다.

### Add "Report the outstanding findings" to finish

선택지 제시보다 앞에 둔다.
진행 기록의 보류·보류 Minor·막힘 줄과 최종 리뷰의 잔여 발견을 그대로 낸다.
문항이 아니라 통지다.
요약하거나 골라 내지 않는다.
보류 판정은 저자가 리뷰어의 반대를 무릅쓰고 내린 것이라 그 판정 자체가 사용자가 볼 대상이다.

### Mark the artifact closed before integration and commit it

`groundwork:finish`의 절 순서를 아래로 고정하고, 절 순서가 곧 실행 순서임을 그 문서가 명시한다.

1. 테스트 확인
2. 환경 탐지
3. base 브랜치 확인
4. 잔여 발견 보고
5. 산출물 종료 표기
6. 선택지 제시
7. 선택 실행
8. 워크트리 정리
9. 실행 스크래치 정리

종료 표기 커밋이 작업 브랜치의 마지막 커밋이 되어 통합이 그것을 함께 나른다.
사용자가 명시로 폐기를 요청한 경로에서는 `git branch -D`가 그 커밋도 함께 버리므로 버린 작업에 종료 표기가 남지 않는다.

### Fix what the execution skills hand over at two items

설계 문서 파일의 경로와 실행 스크래치의 경로다.
넘기지 않으면 `groundwork:finish`가 사용자에게 되묻는다.
실행 스킬의 「연속 실행」이 없앤 확인 질문이 마지막에 되살아난다.

### Make the execution skills the single source of truth for task review

`groundwork:requesting-code-review`에 「Where this skill does not apply」를 두어 태스크 리뷰와 fix 루프의 재리뷰를 실행 스킬로 넘긴다.
브랜치 전체를 보는 최종 리뷰만 이 스킬의 프롬프트(`skills/requesting-code-review/code-reviewer-prompt.md`)를 쓰고, 그때도 diff는 실행 스킬이 `review-package`로 만든다.

같은 스킬의 셸 절차에서 `BASE_SHA` 기본값을 `git merge-base`로 바꾼다.
`HEAD~1`을 기본값으로 쓰지 말라는 근거를 그 자리에 함께 적는다.

### Make the confirmation round cumulative

`groundwork:design-review`는 발견을 고친 뒤 닫기 전에 확인 라운드를 한 번 돈다.
그 대상을 마지막 개정이 건드린 절이 아니라 그 리뷰의 전 라운드에서 고친 절 전체로 바꾼다.

재리뷰는 `REVIEW_VERDICT: FAIL`을 낸 렌즈만 다시 부른다.
1라운드에서 `REVIEW_VERDICT: PASS`를 낸 렌즈의 담당 절을 1라운드 개정이 깨뜨리고 2라운드가 다른 절을 고치면, 그 파손을 재리뷰도 확인 라운드도 보지 않았다.

같은 문서가 `통과`의 뜻을 좁혀 적는다.
결함이 없다는 판정이 아니라 이 문서로 구현을 시작할 수 있다는 판정이다.

### Define the session split after a conditional pass

`skills/using-groundwork/choosing-model-tier.md`는 설계 단계와 실행 단계를 서로 다른 모델의 세션으로 나눌 수 있게 하고, 그 성립 조건을 설계 문서의 자기완결성 하나로 둔다.
`groundwork:design-review`가 처리하지 못한 발견을 남긴 채 닫는 `조건부 통과`가 그 조건을 만족하는지 적혀 있지 않았다.

남은 발견이 `junior-read`의 것이면 분할하지 않는다.
다른 렌즈의 것이면 그 발견을 새 세션에 넘기고 분할한다.
`junior-read`의 잔여는 맥락 없는 독자가 이 문서를 읽지 못한다는 뜻이고 새 세션이 정확히 그 독자다.

### Remove the remaining SPEC- prefix

`docs/adr/ADR-0010-renaming-spec-to-design-doc.md`가 산출물 경로를 `docs/specs/SPEC-NNNN-<topic>.md`에서 `docs/designs/DESIGN-NNNN-<topic>.md`로 옮겼다.
`groundwork:finding-unknowns`의 번호 예약이 `docs/designs/`의 접두를 여전히 `SPEC-`으로 적고 있었다.
존재하지 않는 접두를 스캔 대상으로 지목하는 것이라 아카이브 참조가 아니라 오작동 지시다.
`groundwork:writing-adr`의 번호 축 설명도 같이 고친다.

## Consequences

Positive:
- 커밋된 코드가 든 워크트리를 종료 단계에서 지우는 경로가 사라진다.
- 보류 판정과 막힘 사유가 사용자에게 도달한다.
  fix 루프의 "조용한 폐기는 금지다"가 flow 끝까지 성립한다.
- `status: closed`가 통합에 실려 리포에 남는다.
- 태스크 리뷰에서 `HEAD~1`로 diff 대부분이 누락되는 경로가 사라진다.
- 중간 라운드 개정이 검증 없이 남던 구멍이 좁아진다.
- 두 스크립트의 stdout이 경로 한 줄이라 호출자가 파싱하지 않는다.
  관측값은 stderr로 나간다.

Negative:
- **네 번째 연쇄 개명이다.**
  ADR-0009가 `sdd-workspace`를 `spec-workspace`로, ADR-0010이 그것을 `design-workspace`로 바꾼 직후에 `design-scratch`로 또 옮긴다.
  ADR-0009가 "다음 개명에서 같은 일이 반복된다"고 적은 그 반복이다.
- **확인 라운드가 무거워진다.**
  누적 목록으로 대상을 잡으므로 라운드가 길어질수록 마지막에 부르는 렌즈가 늘어난다.
  비용 증가분은 측정하지 않았다.
- **`통과`의 뜻을 좁힌 것이 방어적으로 읽힐 수 있다.**
  잔여를 명시했을 뿐 없애지 않았다.
  확인 라운드가 낸 발견을 고친 개정은 여전히 검증되지 않는다.
- **`groundwork:finish`가 무거워졌다.**
  절이 셋 늘고 절 순서에 의존하는 규칙이 생겼다.
  순서를 바꾸면 종료 표기 커밋·잔여 발견 보고·진행 기록 보존 셋이 동시에 깨진다.
  그 사실을 문서에 적었으나 순서 자체를 기계로 강제하지는 않는다.
- **선택 2와 선택 3에서 실행 스크래치가 무기한 남는다.**
  작업이 안착한 뒤 누가 지우는지 정하지 않았다.
  `.groundwork/`가 `.gitignore` 대상이라 `git status`로는 드러나지 않아 쌓이는 것이 보이지 않는다.
- **ADR-0009와 ADR-0010의 Compliance 항목이 낡는다.**
  두 문서가 `spec-workspace`·`design-workspace` 이름을 전제로 적은 검증 항목이 이 결정 뒤에는 다른 이름을 봐야 한다.
  ADR은 수락 후 불변이므로 고치지 않고 이 문서가 그 사실을 적는다.
- **이 개정도 groundwork flow를 거치지 않았다.**
  리포 루트의 `CLAUDE.local.md`가 이 리포를 flow에서 면제한다.
  설계 문서도 리뷰도 없이 대화에서 결정하고 바로 적용했다.

## Compliance

아래 경로는 모두 리포 루트 기준이다.

- `skills/executing-design/scripts/`에 `design-scratch`와 `review-package`가 있고 둘 다 `bash -n` 문법 검사를 통과한다.
- 두 스크립트가 stdout으로 경로 한 줄만 낸다.
- `skills/`와 리포 문서에서 `design-workspace` 문자열이 나오지 않는다(`docs/adr/`의 수락된 ADR은 제외).
- 두 실행 스킬의 「Handoff」에 삭제 지시가 없고 `groundwork:finish`에 넘길 것 둘이 적혀 있다.
- `skills/finish/SKILL.md`에 「Report the outstanding findings」와 「Clean up the execution scratch」가 있다.
  「Mark the artifact closed」가 「Present the options」보다 앞에 있고 커밋 커맨드를 담는다.
- `skills/requesting-code-review/SKILL.md`에 「Where this skill does not apply」가 있고 셸 절차의 `BASE_SHA` 기본값이 `HEAD~1`이 아니다.
- `skills/design-review/SKILL.md`의 확인 라운드가 누적 개정 절 목록을 대상으로 삼는다.
- `skills/using-groundwork/choosing-model-tier.md`에 리뷰 반환별 분할 가능 여부 표가 있다.
- `skills/`에서 `SPEC-` 문자열이 나오지 않는다.
- `skills/`에 `설계 문서으로` 같은 조사 파손이 없다.
- 모든 마크다운 상대 링크가 실재 파일로 해소된다.

## Notes

- Author: jjh
- Version: 0.1
- Changelog:
  - 0.1: 최초 작성
