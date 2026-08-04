# 스킬 설계를 위한 설득 원리

## 개요

LLM은 사람과 같은 설득 원리에 반응한다. 이 심리를 이해하면 더 효과적인 스킬을 설계한다. 조종하려는 게 아니라 압박 속에서도 핵심 관행이 지켜지게 하려는 것이다.

**연구 기반:** Meincke et al. (2025)는 7가지 설득 원리를 N=28,000 AI 대화로 시험했다. 설득 기법은 순응률을 두 배 넘게 높였다(33% → 72%, p < .001).

## 일곱 가지 원리

### 1. 권위 (Authority)
**정체:** 전문성·자격·공식 출처에 따르는 것.

**스킬에서 작동하는 방식:**
- 명령형 언어: "YOU MUST", "Never", "Always"
- 협상 불가 프레이밍: "No exceptions"
- 결정 피로와 합리화를 없앤다

**언제 쓰나:**
- 규율을 강제하는 스킬(TDD, 검증 요구)
- 안전이 걸린 관행
- 확립된 베스트 프랙티스

**예:**
```markdown
✅ Write code before test? Delete it. Start over. No exceptions.
❌ Consider writing tests first when feasible.
```

### 2. 약속 (Commitment)
**정체:** 앞선 행동·발언·공개 선언과 일관되려는 것.

**스킬에서 작동하는 방식:**
- 선언을 요구한다: "스킬 사용을 알려라"
- 명시적 선택을 강제한다: "A, B, C 중 하나를 고르라"
- 추적을 쓴다: 체크리스트용 todo

**언제 쓰나:**
- 스킬이 실제로 지켜지게 할 때
- 다단계 프로세스
- 책임 메커니즘

**예:**
```markdown
✅ When you find a skill, you MUST announce: "I'm using [Skill Name]"
❌ Consider letting your partner know which skill you're using.
```

### 3. 희소성 (Scarcity)
**정체:** 시간 제한이나 한정된 가용성에서 오는 긴급함.

**스킬에서 작동하는 방식:**
- 시간 제약 요구: "진행하기 전에"
- 순차 의존: "X 직후 즉시"
- 미루기를 막는다

**언제 쓰나:**
- 즉시 검증 요구
- 시간에 민감한 워크플로우
- "나중에 하지"를 막을 때

**예:**
```markdown
✅ After completing a task, IMMEDIATELY request code review before proceeding.
❌ You can review code when convenient.
```

### 4. 사회적 증거 (Social Proof)
**정체:** 남들이 하는 것, 다들 정상으로 여기는 것에 맞추는 것.

**스킬에서 작동하는 방식:**
- 보편 패턴: "Every time", "Always"
- 실패 양태: "Y 없는 X = 실패"
- 규범을 세운다

**언제 쓰나:**
- 보편 관행을 문서화할 때
- 흔한 실패를 경고할 때
- 표준을 강화할 때

**예:**
```markdown
✅ Checklists without todo tracking = steps get skipped. Every time.
❌ Some people find a todo list helpful for checklists.
```

### 5. 유대 (Unity)
**정체:** 공유 정체성, "우리라는 느낌", 내집단 소속.

**스킬에서 작동하는 방식:**
- 협력적 언어: "우리 코드베이스", "우리는 동료다"
- 공유 목표: "우리 둘 다 품질을 원한다"

**언제 쓰나:**
- 협력 워크플로우
- 팀 문화를 세울 때
- 비위계적 관행

**예:**
```markdown
✅ We're colleagues working together. I need your honest technical judgment.
❌ You should probably tell me if I'm wrong.
```

### 6. 상호성 (Reciprocity)
**정체:** 받은 이득을 되갚아야 한다는 의무감.

**작동 방식:**
- 아껴 쓴다. 조종처럼 느껴질 수 있다
- 스킬에는 거의 필요 없다

**언제 피하나:**
- 거의 항상(다른 원리가 더 효과적)

### 7. 호감 (Liking)
**정체:** 좋아하는 상대와 협력하려는 선호.

**작동 방식:**
- **순응 유도에는 쓰지 마라**
- 정직한 피드백 문화와 충돌한다
- 아첨을 낳는다

**언제 피하나:**
- 규율 강제에는 항상

## 스킬 유형별 원리 조합

| 스킬 유형 | 쓸 것 | 피할 것 |
|------------|-----|-------|
| 규율 강제 | 권위 + 약속 + 사회적 증거 | 호감, 상호성 |
| 안내/기법 | 적당한 권위 + 유대 | 과한 권위 |
| 협력 | 유대 + 약속 | 권위, 호감 |
| 레퍼런스 | 명료성만 | 모든 설득 |

## 왜 통하나: 심리

**분명한 경계선 규칙은 합리화를 줄인다:**
- "YOU MUST"는 결정 피로를 없앤다
- 절대 언어는 "이건 예외인가?" 질문을 없앤다
- 명시적 반(反)합리화는 특정한 빠져나갈 구멍을 막는다

**실행 의도는 자동 행동을 만든다:**
- 명확한 트리거 + 요구 행동 = 자동 실행
- "When X, do Y"가 "generally do Y"보다 효과적이다
- 순응의 인지 부하를 줄인다

**LLM은 준인간(parahuman)이다:**
- 이런 패턴이 담긴 인간 텍스트로 훈련됐다
- 훈련 데이터에서 권위 언어는 순응에 앞선다
- 약속 시퀀스(발언 → 행동)가 자주 모델링됐다
- 사회적 증거 패턴(모두가 X를 한다)이 규범을 세운다

## 윤리적 사용

**정당:**
- 핵심 관행이 지켜지게 하기
- 효과적인 문서 만들기
- 예측 가능한 실패 막기

**부당:**
- 개인 이득을 위한 조종
- 거짓 긴급함 만들기
- 죄책감에 기댄 순응 유도

**시험:** 사용자가 이 기법을 온전히 이해한다면, 그것이 사용자의 진짜 이익에 부합하겠는가?

## 연구 인용

**Cialdini, R. B. (2021).** *Influence: The Psychology of Persuasion (New and Expanded).* Harper Business.
- 설득의 일곱 원리
- 영향력 연구의 실증적 기반

**Meincke, L., Shapiro, D., Duckworth, A. L., Mollick, E., Mollick, L., & Cialdini, R. (2025).** Call Me A Jerk: Persuading AI to Comply with Objectionable Requests. University of Pennsylvania.
- 7가지 원리를 N=28,000 LLM 대화로 시험
- 설득 기법으로 순응률이 33% → 72%로 상승
- 권위·약속·희소성이 가장 효과적
- LLM 행동의 준인간 모델을 입증

## 빠른 참조

스킬을 설계할 때 묻는다:

1. **어떤 유형인가?** (규율 대 안내 대 레퍼런스)
2. **어떤 행동을 바꾸려는가?**
3. **어떤 원리가 맞나?** (규율엔 보통 권위 + 약속)
4. **너무 많이 섞는가?** (일곱 개를 다 쓰지 마라)
5. **윤리적인가?** (사용자의 진짜 이익에 부합하나?)
