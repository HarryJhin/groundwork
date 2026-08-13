---
name: using-groundwork
description: Use when starting any conversation - groundwork 설계 flow 진입을 강제한다. 새 기능·멀티파일·낯선 도메인 작업에서 코드·탐색·질문보다 먼저 이 규율을 적용한다.
---

<SUBAGENT-STOP>
특정 태스크를 실행하도록 디스패치된 서브에이전트라면 이 스킬을 무시한다.
이 규율은 메인 루프 전용이다.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
groundwork 클래스 작업(새 기능·멀티파일·낯선 도메인)에서는 코드·탐색·질문에 앞서 groundwork flow로 진입한다.
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
| 리뷰 관점(lens) 목록과 디스패치 방식 | `groundwork:spec-review`, `groundwork:plan-review` |
| 각 단계의 절차 | 아래 flow 표가 지목하는 스킬 |

## groundwork 클래스 판별

- 대상: 새 기능, 멀티파일 변경, 낯선 도메인 작업.
- 제외: 한 문장 diff로 설명되는 국소 수정. 이런 작업은 flow 없이 바로 처리한다.

## The Rule (진입 강제)

관련되거나 요청된 스킬은 어떤 응답·행동보다 먼저 invoke한다.
확인 질문, 코드 탐색, 파일 열람도 그 뒤다.
상황에 안 맞으면 그때 그만두면 된다.

groundwork 클래스 작업에는 다음을 강제한다.

1. **진입**: 코드·탐색 전에 `groundwork:finding-unknowns`로 unknowns부터 찾아낸다.
2. **발산 리다이렉트**: 실행 환경이 제공하는 아이디어 발산·요구 탐색 스킬이 먼저 걸려도 groundwork 클래스면 거기 머물지 않고 `groundwork:finding-unknowns`로 넘어간다.
   finding-unknowns가 필요한 발산을 내부에서 이끈다.
3. **게이트**: 스펙은 `groundwork:spec-review`, 플랜은 `groundwork:plan-review`를 거쳐야 하고 여기에 사용자 명시 승인이 더해져야 다음 단계로 간다.
   리뷰를 돌릴지와 어느 범위로 돌릴지는 각 리뷰 스킬이 첫 단계에서 사용자에게 묻는다.
   저자가 대신 정하지 않고 스킬 호출 자체를 건너뛰지도 않는다.
   두 스킬은 `통과`·`조건부 통과`·`건너뜀` 3가지 중 하나로 끝나며 어느 쪽인지 사용자에게 밝힌다.
   침묵·모호 발화는 승인이 아니다.
4. **flow**: 사슬의 단계마다 소유가 다르다.

   | 단계 | 소유 |
   |---|---|
   | bootstrap | 이 문서 |
   | finding-unknowns | `groundwork:finding-unknowns` |
   | spec-review | `groundwork:spec-review` |
   | writing-plans | `groundwork:writing-plans` |
   | plan-review | `groundwork:plan-review` |
   | executing-plan | `groundwork:subagent-driven-development`(기본) 또는 `groundwork:executing-plan`(서브에이전트를 쓸 수 없거나 격리 이득이 없을 때) |
   | test-driven-development | `groundwork:test-driven-development` |
   | requesting-code-review | `groundwork:requesting-code-review`(받은 피드백 처리는 `groundwork:receiving-code-review`) |
   | finish | `groundwork:finish` |

   플랜 승인이 마지막 사용자 게이트다.
   그 뒤 구현·검증·종료는 자율이다.

5. **작성 규범**: 스펙·플랜·스킬·ADR을 쓰기 전에 `groundwork:writing-for-junior`(맥락 없는 주니어 독자 기준의 작성 규범과 판정 렌즈)를 로드한다.
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
| "이 정도는 flow 없이 돼" | groundwork 클래스면 flow가 방법을 정한다. |
| "이 스킬 기억나" | 스킬은 바뀐다. 현재 버전을 읽는다. |
| "일단 이것 하나만 먼저" | 무엇이든 하기 전에 확인한다. |
| "flow는 과해" | 작은 일도 커진다. flow를 쓴다. |

## 우선순위

사용자 지시 > groundwork > 다른 플러그인 스킬 > 기본 동작.

groundwork는 설계·리뷰 flow와 실행층 규율을 함께 담는다.
실행층은 다음이 정본이고 같은 규율의 다른 플러그인 스킬이 함께 걸리면 groundwork 것을 쓴다.

| 규율 | 정본 |
|---|---|
| 테스트 주도 개발 | `groundwork:test-driven-development` |
| 체계적 디버깅 | `groundwork:systematic-debugging` |
| 완료 전 검증 | `groundwork:verification-before-completion` |
| 코드 리뷰 요청 | `groundwork:requesting-code-review` |
| 받은 리뷰 처리 | `groundwork:receiving-code-review` |
| 워크스페이스 격리 | `groundwork:using-git-worktrees` |
| 독립 문제의 병렬 조사 | `groundwork:dispatching-parallel-agents` |

## User Instructions

사용자 지시(CLAUDE.md·직접 요청)가 스킬에 우선하고 스킬이 기본 동작에 우선한다.
사용자가 명시로 지시했을 때만 스킬 워크플로우나 지시를 건너뛴다.
