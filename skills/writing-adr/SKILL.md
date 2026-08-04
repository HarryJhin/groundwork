---
name: writing-adr
description: |
  ADR(Architecture Decision Record)의 형식·프로세스·신설 절차 정본. ADR 파일을 직접 쓰고, 위치·번호를 스캔으로 정한다.
  Use when "ADR 작성", "ADR 신설", "아키텍처 결정 기록", 구현 중 repo 아키텍처 결정을 문서로 남길 때.
---

# writing-adr

ADR은 파일 하나가 설계 결정 하나를 담는 마크다운 문서다. 이 스킬이 형식·프로세스·신설 절차·산출물 규약의 정본이고, 다른 문서에 의존하지 않는다. `references/`의 문서는 ADR 관행 일반을 다루는 외부 배경 자료다. 이 스킬의 규정을 반영하지 않으므로 형식 기준으로 삼지 않는다.

ADR은 repo 안에 산다. 그 repo의 아키텍처 결정을 그 repo가 보관하고, 코드와 함께 커밋되어 함께 옮겨 다닌다. repo 밖에 ADR을 두지 않는다.

**경로 기준**: 이 문서의 상대 경로는 두 기준으로 갈린다. `references/`처럼 이 스킬이 거느린 파일은 스킬 디렉터리 `${CLAUDE_PLUGIN_ROOT}/skills/writing-adr/` 기준이고, `${CLAUDE_PLUGIN_ROOT}`는 groundwork 플러그인이 설치된 디렉터리이지 실행 시점 작업 디렉터리가 아니다. `docs/adr/`처럼 산출물이 놓이는 경로는 대상 repo 루트 기준이고, 그 루트는 `git rev-parse --show-toplevel`로 얻는다.

## 산출물 규약

- **위치**: `<repo 루트>/docs/adr/`. repo 루트는 `git rev-parse --show-toplevel`로 얻는다.
- **명명**: `ADR-NNNN-<topic>.md`. `NNNN`은 네 자리 제로패딩이고 `<topic>`은 결정 요지의 영문 kebab-case다.
- **번호 축**: 그 repo `docs/adr/` 안에서만 증가한다. repo마다 독립이라 다른 repo의 번호는 보지 않는다.
- **스펙·플랜과 독립**: 같은 repo의 `docs/specs/SPEC-NNNN-<topic>.md`와 `docs/plans/PLAN-NNNN-<topic>.md`는 둘이 짝을 이뤄 번호를 공유하는 별도 축이고, ADR은 거기 참여하지 않는다. 한 작업이 ADR을 몇 개 남기든 스펙 번호는 줄지 않는다. 번호가 겹쳐도 파일명 접두(`ADR-` 대 `SPEC-`·`PLAN-`)가 구분한다.
- **커밋**: 그 repo의 정규 산출물이다. 결정을 낳은 코드 변경과 함께 커밋한다.
- **소비자**: 후속 세션이 `docs/adr/`를 열어 `ADR-NNNN`으로 인용한다.

## 형식 정본

ADR 파일은 최상단 h1 하나와 그 아래 `##` 섹션으로 이뤄진다. 섹션은 아래 순서를 지킨다.

| 섹션 | 내용 | 형식 |
|---|---|---|
| `## Title` | 결정을 한 문장으로 정의 | 능동태 완결 문장 |
| `## Status` | 결정의 수명 | 아래 「Status 값」 중 하나 |
| `## Date` | 결정 확정일 | ISO 8601 `YYYY-MM-DD` |
| `## Context` | 결정을 강제한 힘 | 서술 |
| `## Decision` | 결정 자체 | 능동태 서술 |
| `## Consequences` | 파급 | `Positive:` / `Negative:` 라벨 아래 `- ` 불릿 |
| `## Compliance` | 결정 준수를 판정할 이행 항목 | `- ` 불릿, 없으면 `None` |
| `## Notes` | 메타 | `- Author:` / `- Version:` / `- Changelog:` |

**h1**: `# ADR-NNNN: <짧은 제목>` 형식이다. `NNNN`을 리터럴 자리표시자로 남기지 말고 신설 시점에 확정된 실제 네 자리 번호를 채워 파일명 `ADR-NNNN-<topic>.md`의 번호와 일치시킨다. h1의 짧은 제목은 파일명의 `<topic>`을 자연어로 요약한 명사구이고, `## Title` 섹션은 결정을 한 문장으로 정의하는 완결 문장이다. 둘은 역할이 달라 같은 문장으로 채우지 않는다.

**언어**: 섹션명은 영문, 본문 내용은 한국어로 쓴다. 이 규칙의 대상은 서술문이다. `Consequences`의 `Positive:`·`Negative:`는 서술문이 아니라 형식 라벨이라 영문 그대로 둔다.

**Status 값**: `Proposed`, `Accepted`, `Rejected`, `Superseded`, `Deprecated`. `Superseded`와 `Deprecated`의 구분은 대체 ADR의 유무다. 대체 ADR을 새로 만들어 이 결정을 대신하면 `Superseded`, 대체 ADR 없이 결정을 무효화하면 `Deprecated`다.

**Alternatives 섹션을 두지 않는다**: 기각된 대안은 Context나 Decision에 녹인다.

**섹션 채우기 규칙**:
- `## Date`는 신설(제안) 시점에 오늘 날짜를 채운다. Status가 `Accepted`로 갈 때 저자가 확정일로 갱신한다.
- `## Consequences`는 `Positive:`와 `Negative:` 라벨 아래 각각 `- ` 불릿을 둔다. 한쪽 항목이 없으면 그 라벨을 생략한다. Negative는 기재 의무다(긍정 효과만 나열하면 미완성).
- `## Compliance`에 이행 항목이 없으면 불릿 없이 `None`만 적는다.
- `## Notes`는 `- Author:`, `- Version:`, `- Changelog:`를 담는다. 대체 시 `- Superseded by: ADR-NNNN` 슬롯을 더한다.

**이력 모델 두 겹**: `Notes`의 `Changelog`는 한 ADR이 수락되기 전 제안 단계의 버전 이력(`0.1`→`0.2`)을 담는다. 수락 후에는 불변으로 둔다. 결정을 번복할 때는 Changelog를 고치지 않고 새 ADR을 만들어, 원 ADR의 `Status`를 `Superseded`로 돌리고 원 ADR `## Notes`에 `- Superseded by: ADR-NNNN` 줄을 더한다.

### 스켈레톤 예시

아래는 형식 예시다. 신설 시 실제 번호·날짜·내용을 채운다.

```markdown
# ADR-0007: 테스트 러너를 vitest로 통일

## Title

프로젝트 전 패키지의 단위 테스트 러너를 vitest 하나로 통일한다.

## Status

Proposed

## Date

2026-07-24

## Context

패키지마다 jest와 mocha가 섞여 있어 설정·CI 파이프라인이 이중이다. ESM 전환 후 jest의 트랜스폼 설정이 반복해서 깨졌다.

## Decision

모든 워크스페이스 패키지가 vitest를 단일 테스트 러너로 쓴다. jest·mocha 설정과 의존성을 제거한다.

## Consequences

Positive:
- 설정·CI 파이프라인이 하나로 준다.
- ESM을 네이티브로 다뤄 트랜스폼 설정이 사라진다.

Negative:
- 기존 jest 전용 매처를 쓰는 테스트를 손봐야 한다.

## Compliance

- 새 테스트 파일은 vitest API로만 작성한다.
- CI가 jest·mocha 의존성 잔존을 검사해 실패시킨다.

## Notes

- Author: 홍길동
- Version: 0.1
- Changelog:
  - 0.1: 최초 제안 버전
```

## 신설 절차 (에이전트가 직접 수행)

**입력**: 기록할 결정의 내용, 곧 그 결정을 강제한 맥락과 결정 자체, 기각한 대안이다. 호출자가 넘기지 않으면 방금 내린 결정에서 뽑는다. 결정이 아직 확정되지 않았으면 ADR을 쓰지 않는다. 무엇으로 확정할지 사용자에게 먼저 확인한다.

**주체와 범위**: 이 스킬의 실행 범위는 `Proposed` 상태의 ADR 파일 신설까지다. 아래 「작성 프로세스」의 상태 전이는 그 뒤 다른 시점에 일어나고, 거기서 말하는 `저자`는 그 시점에 ADR을 고치는 사람을, `리뷰`는 사용자가 그 결정을 판정하는 절차를 가리킨다.

헬퍼 스크립트는 없다. 아래 단계를 에이전트가 직접 수행한다.

**REQUIRED SUB-SKILL**: 4단계(파일 작성) 전에 `groundwork:writing-for-junior`(세션 맥락 없는 주니어 독자 기준의 작성 규범과 판정 렌즈)를 로드한다. ADR을 읽을 사람은 결정을 뒤집으려는 다음 사람이고 그 결정이 나온 대화를 갖지 않는다. Context·Decision의 용어와 참조가 특히 걸린다.

**1. 위치**
- repo 루트를 `git rev-parse --show-toplevel`로 얻어 `<repo 루트>/docs/adr/`를 대상으로 삼는다.
- cwd가 git repo가 아니면 진행하지 말고 사용자에게 확인한다. 임의 경로로 폴백하지 않는다.

**2. 디렉터리·번호**
- 대상 디렉터리가 없으면 만든다(그 repo의 첫 ADR이면 `docs/adr/`를 새로 연다).
- `docs/adr/` 하나만 스캔한다. `ADR-[0-9][0-9][0-9][0-9]-*.md`를 훑어 최대 번호 +1이고, 매치가 없으면 `0001`이다. 네 자리 제로패딩을 쓰고 네 자리가 아닌 파일은 무시한다.
- `docs/specs/`·`docs/plans/`는 스캔하지 않는다. ADR은 그 번호 축에 참여하지 않는다(위 「산출물 규약」).

**3. `<topic>`**
- 결정 요지의 영문 kebab-case로 짓는다.

**4. 파일 작성**
- `ADR-NNNN-<topic>.md`를 위 형식 정본대로 쓴다. h1과 파일명에 실제 번호를 박고, `## Date`는 오늘, `## Status`는 `Proposed`, 섹션명은 영문, 본문은 한국어.

## 작성 대상

ADR로 남길 결정의 종류:
- 구조 (예: 마이크로서비스 같은 패턴)
- 비기능 요구 (보안, 고가용성, 결함 내성)
- 종속성 (컴포넌트 결합)
- 인터페이스 (API, 공개 계약)
- 구성 기법 (라이브러리, 프레임워크, 도구, 프로세스)

ADR은 "어떻게 구현했나"가 아니라 "왜 그렇게 정했나"에 초점을 둔다. 이유를 적어야 나중에 결정을 뒤집으려는 사람이 맥락을 안다.

ADR로 남기지 않는 것도 갈라둔다. 코드가 스스로 설명하는 구현 세부는 코드 주석에 둔다. 스펙·플랜에 이미 적힌 결정은 중복이라 옮기지 않는다.

## 작성 프로세스

- 신설 시 `Proposed`로 연다.
- 리뷰를 거쳐 `Accepted`(승인), `Rejected`(기각), `Deprecated`(무효화) 중 하나로 간다. 기각·무효화 시 그 사유를 Context에 남겨 같은 논의 재발을 막는다.
- `Accepted`로 갈 때 `## Date`를 확정일로 갱신한다.
- 수락된 ADR은 불변이다. 결정을 번복하려면 새 ADR을 만들고 원 ADR을 `Superseded`로 돌린다(위 「이력 모델 두 겹」).

## Gotchas

- repo 밖에는 쓰지 않는다. cwd가 git repo가 아니면 진행하지 말고 물어본다. 홈 경로 같은 임의 위치로 폴백하지 말라.
- 번호를 뗄 때 스펙·플랜 디렉터리를 훑지 말라. ADR 번호 축은 `SPEC-`·`PLAN-` 축과 독립이라 `docs/adr/` 하나만 본다. 같은 repo에 `SPEC-0003`과 `ADR-0003`이 공존하는 것이 정상이다.
- `Changelog`는 수락 전 제안 이력 전용이다. 수락 후 결정 번복은 Changelog 추가가 아니라 새 ADR + 원 ADR `Superseded` 처리다.
- 섹션명은 영문 그대로 두고 본문만 한국어로 쓴다. `## Context`를 `## 맥락`으로 번역하지 않는다.
- h1의 짧은 제목(명사구)과 `## Title`(완결 문장)을 같은 문장으로 채우지 말라. 서로 다른 역할이다.

## references 읽기 트리거

상세는 references/에 두었다. 아래 상황에 해당 파일을 읽는다:
- ADR 리뷰·승인·대체 프로세스의 상세가 필요하면 [aws-adr-process.md](references/aws-adr-process.md).
- ADR 품질·이력 보존·저장 위치 모범사례를 점검하려면 [aws-adr-best-practices.md](references/aws-adr-best-practices.md).
- 경계 판단(언제 ADR을 쓰나, 무엇을 담나, Superseded 처리)이 애매하면 [aws-adr-faq.md](references/aws-adr-faq.md).
- 섹션 세부의 외부 배경을 확인하려면 [aws-adr-template.md](references/aws-adr-template.md). 이 문서의 형식은 위 「형식 정본」과 어긋나는 지점이 있으므로 형식 기준으로 삼지 않는다.
