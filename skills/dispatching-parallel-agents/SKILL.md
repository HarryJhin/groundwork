---
name: dispatching-parallel-agents
description: 독립적인 문제 영역마다 서브에이전트 하나를 붙여 동시에 돌린다. Use when 서로 무관한 실패가 둘 이상일 때, 여러 테스트 파일·서브시스템이 각각 다른 이유로 깨졌을 때. 공유 상태나 순차 의존이 있으면 쓰지 않는다.
---

# dispatching-parallel-agents

서브에이전트에 격리된 컨텍스트로 작업을 위임한다.  
지시와 컨텍스트를 정밀하게 구성해 서브에이전트가 초점을 잃지 않게 한다.  
서브에이전트는 세션 히스토리를 상속받지 않는다.  
필요한 것만 구성해 준다.  
이렇게 하면 조율에 쓸 자기 컨텍스트도 지킨다.

무관한 실패가 여럿일 때(다른 테스트 파일, 다른 서브시스템, 다른 버그) 순차 조사는 시간을 버린다.  
각 조사가 독립이라 동시에 진행할 수 있다.

**핵심 원칙**: 독립적인 문제 영역마다 에이전트 하나를 디스패치한다.  
동시에 일하게 둔다.

**입력**은 현재 확인된 실패 목록이다.  
테스트 출력이나 에러 로그에서 뽑고 아래 「Identify independent areas」로 영역을 가른다.  
영역이 하나로 묶이면 이 스킬을 쓰지 않는다.

**주체**는 에이전트를 띄우는 조율자다.  
디스패치되는 서브에이전트는 이 문서를 읽지 않는다.

**출력**은 통합된 수정과 전체 테스트 스위트 통과다.  
아래 「Verification」을 통과하면 끝이다.

## Applicability

**쓴다**:
- 테스트 파일 둘 이상이 각각 다른 근본 원인으로 실패한다
- 여러 서브시스템이 독립적으로 깨졌다
- 각 문제를 다른 문제의 맥락 없이 이해할 수 있다
- 조사 사이에 공유 상태가 없다

**쓰지 않는다**:
- 실패가 서로 연관돼 있다(하나를 고치면 다른 것도 고쳐질 수 있다)
- 전체 시스템 상태를 이해해야 한다
- 에이전트끼리 간섭한다(같은 파일 편집, 같은 자원 사용)
- 무엇이 깨졌는지 아직 모른다(탐색적 디버깅)

구현 태스크에는 쓰지 않는다.  
구현자를 병렬로 띄우면 충돌한다.  
설계 실행의 동시성 규율은 `groundwork:subagent-driven-development`가 기준 문서다.

## Patterns

네 단계를 순서대로 돈다.

### Identify independent areas

무엇이 깨졌는지로 실패를 묶는다.  
아래는 이 문서 전체가 쓰는 예시다.

- `tool-approval-race-conditions.test.ts`: 도구 승인 흐름
- `batch-completion-behavior.test.ts`: 배치 완료 동작
- `agent-tool-abort.test.ts`: 중단 기능

각 영역이 독립이다.  
도구 승인을 고쳐도 중단 테스트에 영향이 없다.

### Write focused agent tasks

에이전트마다 다음을 준다.  
이 목록이 프롬프트 구성의 정본이고 아래 「Agent prompt structure」는 이것을 채운 예시다.

- **구체적 범위**: 테스트 파일 하나 또는 서브시스템 하나
- **명확한 목표**: 이 테스트들을 통과시킨다
- **자기완결 컨텍스트**: 그 문제를 이해하는 데 필요한 에러 메시지·테스트 이름. 세션 히스토리는 넣지 않는다
- **제약**: 다른 코드를 바꾸지 않는다
- **기대 출력**: 무엇을 발견하고 무엇을 고쳤는지 요약

### Dispatch in parallel

식별한 영역마다 디스패치 하나를, 전부 **한 응답 안에서** 발행한다.  
그래야 동시에 돈다.

```text
서브에이전트 (general-purpose): "agent-tool-abort.test.ts 실패를 고쳐라"
서브에이전트 (general-purpose): "batch-completion-behavior.test.ts 실패를 고쳐라"
서브에이전트 (general-purpose): "tool-approval-race-conditions.test.ts 실패를 고쳐라"
# 3개가 동시에 돈다
```

한 응답에 여러 디스패치를 넣으면 병렬 실행이다.  
응답마다 하나씩이면 순차 실행이다.

**에이전트마다 모델을 명시한다.**  
티어는 `${CLAUDE_PLUGIN_ROOT}/skills/using-groundwork/choosing-model-tier.md`의 「Dispatch axis: investigation tasks」에 있다(`${CLAUDE_PLUGIN_ROOT}`는 groundwork 플러그인이 설치된 디렉터리이고 실행 시점 작업 디렉터리가 아니다).  
모델을 빠뜨리면 세션 모델을 상속해 영역 수만큼 최상위 모델이 돈다.

### Review and integrate

에이전트가 돌아오면 아래 「Verification」의 절차를 따른다.

## Agent prompt structure

아래는 「Write focused agent tasks」의 항목을 채운 예시다.  
그대로 보낼 문구가 아니라 형식 견본이다.

```markdown
src/agents/agent-tool-abort.test.ts의 실패 테스트 3개를 고쳐라:

1. "should abort tool with partial output capture" - 메시지에 'interrupted at'을 기대
2. "should handle mixed completed and aborted tools" - 빠른 도구가 완료 대신 중단됨
3. "should properly track pendingToolCount" - 결과 3개를 기대했으나 0

타이밍·경쟁 조건 문제다. 네 작업은 이렇다:

1. 테스트 파일을 읽고 각 테스트가 무엇을 검증하는지 이해한다
2. 근본 원인을 식별한다. 타이밍 문제인가 실제 버그인가
3. 다음으로 고친다:
   - 임의 타임아웃을 이벤트 기반 대기로 교체
   - 중단 구현에 버그가 있으면 수정
   - 동작이 바뀐 것이면 테스트 기대값 조정

타임아웃만 늘리지 마라. 진짜 원인을 찾아라.

반환: 무엇을 발견하고 무엇을 고쳤는지 요약.
```

## Common mistakes

| 실수                                | 교정                                                   |
|-------------------------------------|--------------------------------------------------------|
| 너무 넓다: "전체 테스트를 고쳐라"   | 구체적으로: "agent-tool-abort.test.ts를 고쳐라"        |
| 컨텍스트 없음: "경쟁 조건을 고쳐라" | 컨텍스트: 에러 메시지와 테스트 이름을 붙인다           |
| 제약 없음(전부 리팩터할 수 있다)    | 제약: "프로덕션 코드를 바꾸지 마라", "테스트만 고쳐라" |
| 모호한 출력: "고쳐라"               | 구체적: "근본 원인과 변경 사항 요약을 반환하라"        |

## Verification

에이전트가 돌아온 뒤 이렇게 한다.

1. **각 요약을 검토한다**: 무엇이 바뀌었는지 이해한다
2. **충돌을 확인한다**: 에이전트들이 같은 코드를 편집했는가
3. **전체 스위트를 돌린다**: 수정들이 함께 작동하는지 확인한다
4. **표본을 확인한다**: 에이전트가 고쳤다고 보고한 수정 중 일부를 직접 열어 요약과 실제 diff가 맞는지 대조한다.  
   에이전트는 체계적 오류를 낸다
5. **변경을 통합한다**: 앞의 항목을 모두 통과한 뒤에 한다

에이전트의 성공 보고를 그대로 믿지 않는다.  
검증 규율은 `groundwork:verification-before-completion`을 따른다.
