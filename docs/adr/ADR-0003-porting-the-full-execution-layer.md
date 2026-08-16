# ADR-0003: Port the full execution layer

## Title

superpowers의 실행층 스킬 열 종을 groundwork로 번역 이식하고 서브에이전트 주도 개발이 의존하는 보조 스크립트 세 개를 함께 가져온다.

## Status

Accepted

## Date

2026-07-25

## Context

S1과 S2가 flow 앞단(설계·리뷰·플랜)을 지었다.
뒷단은 미구축이었고 실행층 규율(TDD·체계적 디버깅·완료 전 검증·코드 리뷰·워크스페이스 격리)을 부트스트랩이 "하네스에 그 규율을 담은 스킬이 있으면 그것을 쓴다"로 외부에 위임했다.
이 위임에는 두 문제가 있다.

첫째, dead-ref가 이미 존재했다.
이식을 마친 `writing-skills`가 `groundwork:test-driven-development`와 `groundwork:systematic-debugging`을 REQUIRED BACKGROUND로 참조하는데 두 스킬이 없었다.
참조가 가리키는 대상이 없으면 그 지시는 실행되지 않는다.

둘째, 위임 대상이 불확실하다.
"하네스에 있으면"은 하네스마다 다르고 Codex 배포에는 아예 없을 수 있다.
groundwork의 목표가 개발방법론 전체를 하나로 담는 것이라면 실행층을 외부 조건부로 두는 설계는 그 목표와 어긋난다.

서브에이전트 주도 개발은 보조 스크립트에 의존한다.
태스크 브리프 추출, 리뷰 패키지 생성, 플랜별 워크스페이스 해소 셋이다.
이 스크립트들이 존재하는 이유는 컨텍스트 경제다.
컨트롤러가 태스크 텍스트와 diff를 자기 컨텍스트로 통과시키면 그것이 남은 세션 내내 상주하고 매 턴 다시 읽힌다.
스크립트가 산출물을 파일로 넘겨 그 비용을 없앤다.
스크립트 없이 스킬 본문 지시만 두면 매 디스패치마다 에이전트가 절차를 재구성해야 하고 재구성이 어긋나면 컨텍스트 경제라는 설계 의도 자체가 무너진다.

## Decision

superpowers 실행층을 전량 이식한다.
부분 이식으로 남기지 않는다.

flow 사슬 네 단계에 대응하는 스킬을 둔다.
`executing-plan`, `test-driven-development`, `requesting-code-review`, `finish`다.
여기에 실행 보조 여섯을 더한다.
`subagent-driven-development`, `verification-before-completion`, `using-git-worktrees`, `systematic-debugging`, `receiving-code-review`, `dispatching-parallel-agents`다.

`subagent-driven-development`가 플랜 실행의 기본 경로이고 `executing-plan`은 서브에이전트를 쓸 수 없거나 격리 이득이 없을 때의 경로다.
두 경로 모두 종료를 `finish`에 넘긴다.

보조 스크립트 세 개(`sdd-workspace`·`task-brief`·`review-package`)를 `skills/subagent-driven-development/scripts/`에 이식한다.
워크스페이스 경로만 groundwork 규약에 맞춰 `.superpowers/sdd/`에서 `.groundwork/sdd/`로 바꾼다.
`task-brief`의 태스크 헤딩 매치는 원본 형식(`### Task N: <이름>`)을 그대로 쓰고 플랜 규약도 같은 형식을 따른다.

`implementation-plan`은 소멸한다.
실행 절이 `subagent-driven-development`와 `executing-plan`으로, 종료 절이 `finish`로 갈린다.
`status: closed` 기입 형식의 정본은 `finish`의 산출물 종료 표기 절이 된다.

부트스트랩의 실행층 위임 문장을 삭제하고 각 규율의 groundwork 정본을 지목하는 목록으로 바꾼다.

## Consequences

Positive:
- flow 아홉 단계 전부가 실재하는 스킬을 지목한다.
  부트스트랩에 "미구축" 표기가 남지 않는다.
- `writing-skills`의 dead-ref 두 건이 닫힌다.
- 실행층 규율이 하네스 조건부가 아니게 되어 Claude Code와 Codex가 같은 규율을 받는다.
- 컨텍스트 경제 장치(브리프·리뷰 패키지 파일화)가 스킬 지시가 아니라 실행 가능한 스크립트로 존재한다.

Negative:
- 스킬 수가 크게 는다.
  전체를 파악하려면 읽을 파일이 많아지고 스킬 사이 참조도 함께 늘어 한 스킬을 고칠 때 확인할 지점이 는다.
- 사본이 원본과 갈린다.
  superpowers가 실행층 스킬을 개선해도 groundwork 사본에 자동으로 오지 않는다.
  두 리포를 대조하는 수동 작업이 생기고 시간이 지나면 어느 쪽이 최신인지 불분명해진다.
- 스크립트가 bash와 git에 대한 실행 의존을 들여온다.
  지금까지 groundwork의 실행 코드는 SessionStart 훅 하나였다.
  스크립트가 도는 환경(셸 없는 하네스, 샌드박스)에서 실패하면 서브에이전트 주도 개발의 컨텍스트 경제가 무너진다.
  스킬 본문이 diff를 직접 가져오는 폴백을 담지만 그 폴백은 컨트롤러 컨텍스트를 태운다.
- Codex 배포에서 스크립트 동작을 검증하지 않았다.
  Codex가 `skills/`를 공유하므로 파일은 실리지만 그 하네스에서 서브에이전트 디스패치와 스크립트 실행이 어떻게 작동하는지는 미확인이다.
- `task-brief`가 태스크 헤딩 형식(`### Task N:`)에 결합돼 다른 형식으로 쓴 플랜에서는 태스크를 찾지 못한다.
  형식 결합을 받아들인 대가다.

## Compliance

- 부트스트랩 flow 표의 아홉 단계가 전부 실재하는 스킬 또는 명시된 대체 경로를 지목한다.
- `skills/` 안에 "미이식"·"이식 예정" 표기가 남지 않는다.
- 모든 `groundwork:<이름>` 참조가 실재하는 스킬 디렉터리로 해소된다.
- 스크립트 세 개가 `bash -n`을 통과하고 실제 플랜 파일에서 동작한다.
- 스크립트가 만드는 `.groundwork/`는 자기 자신을 ignore해 커밋되지 않는다.

## Notes

- Author: jjh
- Version: 0.1
- Changelog:
  - 0.1: 최초 작성 (S3 착수 시점의 사용자 결정 기록)
