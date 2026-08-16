# ADR-0010: Rename the artifact from spec to design document

## Title

`finding-unknowns`가 남기는 산출물의 이름을 `스펙`에서 `설계 문서`로 바꾼다.
경로를 `docs/specs/SPEC-NNNN`에서 `docs/designs/DESIGN-NNNN`으로, 스킬 이름을 `spec-review`·`executing-spec`에서 `design-review`·`executing-design`으로 옮긴다.

## Status

Accepted

`docs/adr/ADR-0008-collapsing-the-plan-stage.md`와 `docs/adr/ADR-0009-execution-asset-ownership.md`의 후속이다.
두 문서의 결정을 뒤집지 않고 산출물의 이름만 바꾼다.
ADR-0008이 이 산출물에 「Global constraints」과 「Acceptance criteria」을 더해 계약으로 만들었고, 그 결과 문서의 내용이 이름과 더 멀어졌다.

## Date

2026-08-16

## Context

용어를 먼저 정한다.

- **명세(specification)**: 시스템이 무엇을 해야 하는지를 진술하는 문서. 구현 방법은 담지 않는 것이 이 말의 통상적 뜻이다.
- **설계 문서(design doc)**: 문제와 목표를 적고 그것을 어떻게 풀지, 어떤 대안을 왜 버렸는지를 담는 문서.
- **ISO/IEC/IEEE 29148**: 요구공학 표준. 요구사항 명세의 구성과 품질 기준을 정한다. 이 리포의 `coherence` 리뷰어 프롬프트가 모호어 분류를 이 표준의 §5.2.7에서 가져온다.

이 산출물을 `스펙`이라 부르는 것에 세 문제가 있었다.

**첫째, 리포가 같은 산출물을 세 가지로 규정하고 있었다.**

- `skills/finding-unknowns/SKILL.md`: "스펙은 기획 문서다."
- `skills/finding-unknowns/SKILL.md`, `skills/executing-spec/SKILL.md`, `skills/subagent-driven-development/SKILL.md`: "스펙은 계약이다."
- `skills/spec-review/completeness-prompt.md`: "스펙은 결론만 담는 기획 문서"

기획 문서와 계약은 같은 것이 아니다.
한 산출물에 규정이 셋이면 이름이 뜻을 나르지 못하고 있다는 뜻이다.

**둘째, 문서의 구성이 명세가 아니라 설계 문서다.**
절 구성은 도입부, 용어, 범위, 제외 범위, 설계, 전역 제약, 수용 기준, 호환성·마이그레이션이다.
이 가운데 「Design」의 정의가 "무엇을 어떻게 만드는가"이고, 고른 것 옆에 버린 대안과 버린 이유를 함께 적게 한다.
`어떻게`와 `버린 대안`은 명세가 담지 않는 것이고 설계 문서의 구성 요소다.
도입부·범위·제외 범위·설계·대안·호환성이라는 배열 자체가 널리 쓰이는 설계 문서 템플릿과 거의 그대로 겹친다.

**셋째, 리포가 인용하는 표준의 중심 용어와 어긋난다.**
`coherence` 프롬프트가 모호어를 가를 때 ISO/IEC/IEEE 29148을 근거로 든다.
그 표준에서 specification은 요구를 진술하는 문서이고 설계를 담지 않는다.
어휘 하나는 그 표준에서 빌려 쓰면서 그 표준의 중심 용어는 다른 뜻으로 쓰고 있었다.

이 어긋남이 실제 비용을 냈다.
`boundary` 리뷰어의 초과 축이 "과설계·조기 추상화"를 결함으로 본다.
명세라면 설계 세부가 초과이고 설계 문서라면 설계 세부가 본론인데, 리뷰어가 문서 이름에서 어느 기준을 적용할지 얻지 못한다.
`completeness` 프롬프트에 "태스크 분해가 섞여 든 기준은 발견이다"를 따로 적어야 했던 것도 같은 이유다.
설계 문서라는 이름이었으면 "설계는 구조를 정하고 순서를 정하지 않는다"가 이름에서 나온다.

## Decision

**산출물의 이름을 `설계 문서`로 한다.**

**자기 규정을 하나로 모은다.**
`기획 문서`는 버린다.
기획은 요구 쪽을 가리키는 말이라 「Design」 절과 정면으로 어긋난다.
남기는 규정은 둘이고 층위가 다르다.
내용으로는 결정과 그 근거를 담는 설계 문서이고, 실행 단계에는 계약으로 작동한다.

**이름과 경로를 옮긴다.**

| 대상 | 이전 | 이후 |
|---|---|---|
| 산출물 경로 | `docs/specs/SPEC-NNNN-<topic>.md` | `docs/designs/DESIGN-NNNN-<topic>.md` |
| 문서 제목 | `# 스펙: <주제>` | `# 설계: <주제>` |
| 리뷰 스킬 | `spec-review` | `design-review` |
| 실행 스킬 | `executing-spec` | `executing-design` |
| 워크스페이스 스크립트 | `spec-workspace` | `design-workspace` |
| 스킬 문서의 인자 이름 | `SPEC_FILE` | `DESIGN_FILE` |
| 리뷰어 표시 토큰 | `spec-mandated` | `design-mandated` |

**`finding-unknowns`는 개명하지 않는다.**
그 이름은 산출물이 아니라 과정을 가리킨다.
모르는 것을 찾아내는 활동은 그대로이므로 이름을 바꿀 근거가 없다.

**`docs/specs/`는 아카이브로 남긴다.**
`SPEC-0001-spec-pipeline.md`가 `status: closed`이고 닫힌 산출물은 불변이라는 규범이 `docs/README.md`에 있다.
`docs/plans/`를 남긴 것과 같은 처리다.

**플러그인 키워드의 `spec-driven-development`는 유지한다.**
키워드는 마켓플레이스 검색어이고 내부 어휘가 아니다.
`spec-driven development`가 이 방법론 부류를 가리키는 생태계 용어라 검색 경로로 남긴다.
같은 이유로 `executing-design`의 `description`에 `스펙대로 구현`을 트리거 어휘로 남긴다.

## Consequences

Positive:
- 한 산출물에 규정이 하나가 되어 리뷰어가 어느 기준을 적용할지 이름에서 얻는다.
- 「Design」 절과 버린 대안이 문서 이름과 어긋나지 않는다.
- ISO/IEC/IEEE 29148을 인용하면서 그 중심 용어를 다른 뜻으로 쓰던 상태가 해소된다.
- `finding-unknowns`를 건드리지 않아 개명 범위가 줄었다.

Negative:
- **세 번째 연쇄 개명이다.**
  ADR-0008이 플랜을 없애고 ADR-0009가 자산 소유를 옮긴 직후다.
  한 세션에서 같은 종류의 대규모 치환이 반복되면 각 단계의 검증이 얕아진다.
- **기계 치환이 한국어 조사를 깨뜨렸다.**
  `승인된 스펙을`이 `승인된 설계 문서을`이 되는 식이다.
  이번에는 찾아 고쳤으나 같은 방식의 치환은 매번 이 결함을 낸다.
- **닫힌 산출물이 옛 이름으로 남는다.**
  `SPEC-0001`과 `docs/specs/`가 그대로다.
  읽는 사람이 두 이름을 같은 것으로 이어 붙여야 하고 그 연결은 `docs/README.md`에만 적혀 있다.
- **생태계 용어와 내부 어휘가 갈린다.**
  키워드는 `spec-driven-development`인데 문서는 설계 문서라 부른다.
  검색으로 들어온 사람이 한 번 갈아타야 한다.
- **ADR-0008과 ADR-0009의 Compliance 항목이 낡는다.**
  두 문서가 `docs/specs/`·`skills/spec-review`·`skills/executing-spec` 경로를 전제로 적은 검증 항목이 이 결정 뒤에는 다른 경로를 봐야 한다.
  ADR은 수락 후 불변이므로 고치지 않고 이 문서가 그 사실을 적는다.
- **이 개정도 groundwork flow를 거치지 않았다.**
  `CLAUDE.local.md`가 이 리포를 flow에서 면제한다.

## Compliance

- `skills/`에 `design-review`와 `executing-design`이 있고 `spec-review`·`executing-spec`이 없다.
- `skills/executing-design/scripts/`에 `design-workspace`와 `review-package`가 있고 둘 다 `bash -n`을 통과한다.
- `skills/`와 리포 문서에서 `SPEC_FILE`·`spec-workspace`·`spec-mandated`·`SPEC-NNNN` 문자열이 나오지 않는다.
- 산출물 규약이 `docs/designs/DESIGN-NNNN-<topic>.md`를 지목한다.
- `hooks/pre-artifact-write-junior-gate`가 `docs/designs/DESIGN-*.md` 신규 쓰기에 게이트를 걸고 `docs/specs/` 경로는 통과시킨다.
- 본문에 `스펙`이 남는 곳은 검색 트리거 어휘 하나뿐이다.
- `docs/specs/`는 남되 새 파일이 생기지 않는다.
- 모든 마크다운 상대 링크가 실재 파일로 해소된다.

## Notes

- Author: jjh
- Version: 0.1
- Changelog:
  - 0.1: 최초 작성
