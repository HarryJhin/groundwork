---
name: writing-for-junior
description: Use when 설계 문서·스킬을 쓰거나 고칠 때, 자기완결 판독성을 검토할 때, 용어·참조·서술 구조를 점검할 때.
---

# writing-for-junior

## Execution contract

입력은 쓰거나 고치는 문서와 유형이다. 유형이 없으면 경로와 형식으로 판단하고 식별되지 않으면 공통 규범만 적용한다. 저자가 아래 규범으로 문서를 쓰며 출력은 해당 문서다. 다음 리뷰로 자동 전환하지 않는다.
이 규범은 문서에 적용한다. 코드 주석의 허용 조건과 표기는 사용자·리포의 주석 정책을 따르며, 이 규범을 근거로 코드 해설을 추가하거나 식별자·표준 기술 용어를 모호한 일상어로 바꾸지 않는다.
판독 검토에서는 격리된 독자가 같은 규범을 적용한다. `groundwork:design-review`는 이 판독 검토를 호출하지 않는다.
이 문서와 판정 파일의 링크는 이 스킬 디렉터리 기준이다.

## Reader definition

독자는 일반 기술 지식과 문서 전문, 리포와 위치가 명시된 참조물을 가진다. 프로젝트·조직의 고유 지식이나 작성 대화는 모르며, 한 참조를 해소하려고 리포를 통독하지 않는다. "주니어"는 능력이 아니라 이 맥락의 부재를 가리킨다.

## Authoring norms

### Knowledge boundary

고유 용어·약칭·코드명과 문장이 성립하는 선행 조건은 문서 안에 정의한다. 표준 자료로 해소되는 일반 지식은 다시 설명하지 않는다. 경계가 애매하면 고유 지식으로 다룬다.
표준 용어를 다른 뜻으로 쓰지 않는다. 이미 프로젝트에 굳어진 용어면 차이를 정의하고, 새 용어면 뜻에 맞는 이름을 고른다.
더 흔한 동의어로 의미가 유지되면 바꾼다. 전문 용어는 해당 분야에서 통용되면 사용할 수 있다. 통용 명칭이 있는 개념에 조어를 붙이지 않는다. 유지할 이유가 있는 조어는 통용 명칭과 범위 차이를 병기한다.
약어는 첫 등장에 풀어쓴다.

### Reference resolution

참조는 선행 정의·위치를 명시한 참조물·일반 지식으로 해소돼야 한다. 작성 대화만이 해소 경로이면 결함이다.
외부 실체는 정식 명칭·정체·위치를 밝힌다. 상대 경로에는 기준 디렉터리를 적고 실제 파일·절이 있는지 확인한다.

### Forward reference

정의는 사용보다 앞에 둔다. 앞에 둘 수 없으면 첫 사용에 정체와 상세 위치를 붙인다.

### Statement readability

독립 진술을 한 문장에 겹치거나 조건·부정을 중첩하지 않는다. 지시어의 대상을 명확히 하고 한 결정에 필요한 정보는 한자리에 모은다. 뜻을 한 번 읽어 판독할 수 있는지를 검사하며 문체 취향으로 반려하지 않는다.

### Standalone readability

결정·요구는 작성 대화나 배경 서사 없이 판독되게 쓴다. 필요한 근거는 해당 결정 옆에 둔다.

### Notation systems

번호·코드 체계를 혼용하면 읽는 법을 밝힌다. 자리표시자 형태를 통일한다.

### Production-circumstance leakage

저자의 고민·리뷰 흔적·형식 선택의 변호·완결성 선언을 본문에 남기지 않는다. 그 문장을 지워도 규칙 적용이나 내용 이해에 빠지는 것이 없으면 제거한다. 주제 자체의 근거나 실행에 필요한 환경 제약은 제거 대상이 아니다.

### Structural duplication

열거의 개수·순서·위치를 본문에 복제하지 않는다. 이름 있는 항목은 이름으로 가리킨다. 항목을 추가하거나 지울 때 함께 고쳐야 하는 구조 설명은 제거한다.
라운드 상한처럼 개수가 규칙이거나 절차의 순서 자체가 내용이면 유지한다.

## Required sections by document type

스킬에는 입력·실행자·출력·경로 기준을 명시하고, 셸 블록에는 변수 대입과 상태 공유 전제를 밝힌다.
설계 문서에는 도입부, `Scope`, `Non-goals`, `User flows and scenarios`, `Cross-cutting concerns`, `Acceptance criteria`를 둔다. 고유 용어가 3개 이상이면 `Terminology`도 둔다. 설계 절 구성은 `groundwork:finding-unknowns`를 따른다.

## Review readability

명시적인 판독 검토에서는 [junior-read-prompt.md](junior-read-prompt.md)를 격리된 독자에게 준다. 스킬이면 [delta-skill.md](delta-skill.md)도 함께 준다. 이 스킬을 개정한 뒤에는 같은 방식으로 자기 문서를 검토한다.

## Read supporting evidence

아래 자료는 규범의 근거나 판정 기준을 재검토할 때 해당 파일만 연다.

| 검토할 내용 | 자료 |
|---|---|
| 저자의 자기 관측 한계 | [why-authors-cannot-see-it.md](references/why-authors-cannot-see-it.md) |
| 참조·전방 참조·정보 분산 | [comprehension-mechanics.md](references/comprehension-mechanics.md) |
| 문서 결함의 실무 분포 | [api-doc-failures.md](references/api-doc-failures.md) |
| 신규 독자의 맥락 경계 | [newcomer-barriers.md](references/newcomer-barriers.md) |
| 어휘 판정과 승인 어휘 목록 | [plain-language-and-controlled-vocabulary.md](references/plain-language-and-controlled-vocabulary.md) |
| 독자에게 불필요한 제작 사정 | [writer-based-prose.md](references/writer-based-prose.md) |

인용을 옮길 때 원문 대조 여부도 함께 옮긴다.
