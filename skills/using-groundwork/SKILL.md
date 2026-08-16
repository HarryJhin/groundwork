---
name: using-groundwork
description: Use when starting any conversation - groundwork 설계 flow 진입을 강제한다. 요청 해석이 갈리거나 틀린 방향이 늦게 드러나는 작업에서 코드·탐색·질문보다 먼저 이 규율을 적용한다.
---

# using-groundwork

groundwork flow 진입 규율이다.
세션 시작 훅이 이 문서 전문을 컨텍스트에 주입하고, 여기서 정한 판별식이 나머지 스킬을 언제 부를지 정한다.

<SUBAGENT-STOP>
특정 태스크를 실행하도록 디스패치된 서브에이전트라면 이 스킬을 무시한다.
이 규율은 메인 루프 전용이다.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
groundwork 클래스 작업에서는 코드·탐색·질문에 앞서 groundwork flow로 진입한다.
flow는 설계에서 종료까지 이어지는 스킬 사슬이고 단계와 소유 스킬은 아래 「The Rule」의 표에 있다.

flow 진입은 선택이 아니다.
합리화로 빠져나가지 않는다.
</EXTREMELY-IMPORTANT>

## 이 문서의 범위

부트스트랩은 진입 스위치다.
무엇을 언제 부를지만 정한다.
아래 규약은 담지 않으니 필요하면 여기서 찾지 말고 소유 스킬을 로드한다.

| 규약 | 소유 스킬 |
|---|---|
| 산출물 경로·명명·번호 | `groundwork:finding-unknowns` |
| 설계 문서에 담는 것과 담지 않는 것 | `groundwork:finding-unknowns` |
| 리뷰 관점(lens) 목록과 디스패치 방식 | `groundwork:design-review` |
| 태스크 분해 규범 | `groundwork:executing-design` |
| 모델 티어와 벤더 교차 디스패치 | `groundwork:using-groundwork`의 `choosing-model-tier.md` |
| 각 단계의 절차 | 아래 flow 표가 지목하는 스킬 |

## groundwork 클래스 판별

판별 기준은 **틀린 방향으로 갔을 때 그 사실이 얼마나 늦게 드러나는가**다.
아래 셋 중 하나라도 `예`면 groundwork 클래스다.

1. **요청을 두 가지 이상으로 읽을 수 있나.**
   해석이 갈리는데 어느 쪽인지 요청에 없으면 예다.
2. **틀린 것을 만들어도 검증이 통과하나.**
   테스트·타입·린트가 방향 착오를 못 잡으면 예다.
   문법은 맞는데 만들라던 것이 아닌 경우가 여기다.
3. **되돌리는 비용이 만드는 비용에 맞먹나.**
   데이터 형식, 공개 인터페이스, 사용자에게 이미 나간 동작이 여기 든다.

셋 다 `아니오`면 flow 없이 바로 처리한다.

**규모는 판별 기준이 아니다.**
파일 수와 변경 줄 수로 가르지 않는다.
정답이 하나뿐인 멀티파일 리팩터는 flow가 세금이고, 한 줄이어도 그 한 줄이 제품 결정이면 flow가 필요하다.
크기가 아니라 위 세 물음으로 가른다.

판별이 서지 않으면 1번 물음만 다시 본다.
요청을 두 가지로 읽을 수 있는데도 어느 쪽인지 모른 채 시작하는 것이 가장 비싼 실패다.

## The Rule (진입 강제)

관련되거나 요청된 스킬은 어떤 응답·행동보다 먼저 invoke한다.
확인 질문, 코드 탐색, 파일 열람도 그 뒤다.
상황에 안 맞으면 그때 그만두면 된다.

groundwork 클래스 작업에는 다음을 강제한다.

1. **진입**: 코드·탐색 전에 `groundwork:finding-unknowns`로 unknowns부터 찾아낸다.
2. **발산 리다이렉트**: 실행 환경이 제공하는 아이디어 발산·요구 탐색 스킬이 먼저 걸려도 groundwork 클래스면 거기 머물지 않고 `groundwork:finding-unknowns`로 넘어간다.
   finding-unknowns가 필요한 발산을 내부에서 이끈다.
3. **게이트**: 설계 문서는 `groundwork:design-review`를 거쳐야 하고 여기에 사용자 명시 승인이 더해져야 구현으로 간다.
   리뷰를 돌릴지와 어느 범위로 돌릴지는 그 스킬이 첫 단계에서 사용자에게 묻는다.
   저자가 대신 정하지 않고 스킬 호출 자체를 건너뛰지도 않는다.
   리뷰는 `통과`·`조건부 통과`·`건너뜀` 3가지 중 하나로 끝나며 어느 쪽인지 사용자에게 밝힌다.
   침묵·모호 발화는 승인이 아니다.
4. **flow**: 사슬의 단계마다 소유가 다르다.

   | 단계 | 소유 |
   |---|---|
   | bootstrap | 이 문서 |
   | finding-unknowns | `groundwork:finding-unknowns` |
   | design-review | `groundwork:design-review` |
   | executing-design | `groundwork:executing-design`(기본) 또는 `groundwork:subagent-driven-development`(태스크가 많고 독립이고 기계적일 때) |
   | test-driven-development | `groundwork:test-driven-development` |
   | requesting-code-review | `groundwork:requesting-code-review`(받은 피드백 처리는 `groundwork:receiving-code-review`) |
   | finish | `groundwork:finish` |

   **설계 승인이 마지막 사용자 게이트다.**
   그 뒤 분해·구현·검증·종료는 자율이다.
   태스크 분해는 실행 스킬이 착수 시점에 하고 커밋되는 문서로 남지 않는다.
   그래서 승인 시점에 범위·제외 범위·수용 기준이 판정 가능한 상태여야 하고, 흐린 채 통과하면 바로잡을 지점이 뒤에 없다.

5. **작성 규범**: 설계 문서·스킬·ADR을 쓰기 전에 `groundwork:writing-for-junior`(맥락 없는 주니어 독자 기준의 작성 규범과 판정 렌즈)를 로드한다.
   리뷰에서 반려된 뒤 고치는 것이 아니라 쓰는 시점에 적용한다.

invoke할 때는 "Using [skill] to [purpose]"를 알리고 스킬을 그대로 따른다.
체크리스트가 있으면 항목마다 todo를 만든다.

## Skill Priority

여러 스킬이 걸리면 process 스킬이 먼저다.
process 스킬이 접근을 잡고 그 뒤 구현 스킬이 실행한다.

- "X를 만들자" → groundwork 클래스면 `groundwork:finding-unknowns` 먼저. groundwork 클래스가 아니면 실행 환경이 제공하는 발산·요구 탐색 스킬을 쓰고 그런 스킬이 없으면 바로 처리한다.
- "이 버그 고쳐" → `groundwork:systematic-debugging` 먼저, 그다음 도메인 스킬.

## Red Flags

아래 생각이 들면 멈춘다.
합리화 중이라는 신호다.

| 생각 | 실제 |
|---------|---------|
| "이건 그냥 간단한 질문이야" | 질문도 작업이다. 스킬을 확인한다. |
| "맥락부터 더 모아야 해" | 스킬 확인이 확인 질문보다 먼저다. |
| "코드베이스부터 좀 볼게" | 스킬이 탐색 방법을 알려준다. 먼저 확인한다. |
| "파일 하나만 고치면 되니 flow는 과해" | 크기는 판별 기준이 아니다. 「groundwork 클래스 판별」의 세 물음으로 가른다. |
| "멀티파일이니 무조건 flow" | 이것도 크기 판정이다. 정답이 하나뿐이면 flow는 세금이다. 세 물음으로 가른다. |
| "이 스킬 기억나" | 스킬은 바뀐다. 현재 버전을 읽는다. |
| "일단 이것 하나만 먼저" | 무엇이든 하기 전에 확인한다. |
| "요청이 애매하지만 내가 알아서 읽으면 돼" | 1번 물음이 `예`다. 그게 flow 진입 조건이다. |
| "테스트가 통과하니 방향도 맞을 것이다" | 2번 물음이 그 착각을 겨눈다. 검증은 문법을 보지 의도를 보지 않는다. |

## 우선순위

사용자 지시 > groundwork > 다른 플러그인 스킬 > 기본 동작.

groundwork는 설계·리뷰 flow와 실행층 규율을 함께 담는다.
실행층은 다음이 정본이고 같은 규율의 다른 플러그인 스킬이 함께 걸리면 groundwork 것을 쓴다.

| 규율 | 정본 |
|---|---|
| 설계 실행과 태스크 분해 | `groundwork:executing-design` |
| 테스트 주도 개발 | `groundwork:test-driven-development` |
| 체계적 디버깅 | `groundwork:systematic-debugging` |
| 완료 전 검증 | `groundwork:verification-before-completion` |
| 코드 리뷰 요청 | `groundwork:requesting-code-review` |
| 받은 리뷰 처리 | `groundwork:receiving-code-review` |
| 워크스페이스 격리 | `groundwork:using-git-worktrees` |
| 독립 문제의 병렬 조사 | `groundwork:dispatching-parallel-agents` |
| 역인터뷰 품질 | `groundwork:finding-unknowns`(인터뷰 절차) |
| 모델 티어 배정 | `groundwork:using-groundwork`의 `choosing-model-tier.md` |

### 기본 동작보다 우선하는 질문

「기본 동작」에는 세션의 기본 성향도 든다.
확인 질문 없이 진행하려는 성향이 그 예다.
사용자만 결정할 수 있는 사항이나 확인이 필요한 질문은 그 성향을 이유로 생략하지 않는다.
groundwork 클래스 작업이 아니어도 이 규율은 적용된다.

`AskUserQuestion`으로 물을 때는 주제 하나당 질문 하나를 담는다.
선택지를 제시할 수 있으면 각 선택지와 그 결과를 한 줄로 제시한다.
자세한 절차의 정본은 `groundwork:finding-unknowns`의 「인터뷰 절차」다.

## User Instructions

사용자 지시(CLAUDE.md·직접 요청)가 스킬에 우선하고 스킬이 기본 동작에 우선한다.
사용자가 명시로 지시했을 때만 스킬 워크플로우나 지시를 건너뛴다.
