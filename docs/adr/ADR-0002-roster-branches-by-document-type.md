# ADR-0002: Reviewer roster branches by document type

## Title

리뷰어 로스터의 필수 집합을 문서 유형에 따라 갈라, 플랜 전용 리뷰어 `decomposition`·`spec-alignment`를 신설하고 `scope`를 스펙 전용으로 한정한다.

## Status

Proposed

## Date

2026-07-25

## Context

S1까지 로스터는 필수 여섯을 문서 유형과 무관하게 디스패치했다.
플랜 리뷰를 실제로 성립시키려 기존 프롬프트를 대조하니 두 문제가 드러났다.

첫째, `scope`의 판정 기준이 "단일 구현 플랜 하나에 담기는가"다.
이것은 스펙을 쪼갤지 정하는 축이다.
플랜은 이미 쪼갠 스펙 하나에서 나온 산출물이라 이 판정이 성립하지 않는다.

둘째, superpowers `plan-document-reviewer-prompt.md`의 네 범주 중 둘에 대응하는 리뷰어가 없다.
Task Decomposition(태스크 경계·의존·실행 가능성)과 Spec Alignment(플랜이 스펙을 이행하는가)다.
특히 후자는 구조적 공백이었다.
`consistency` 프롬프트가 판정 범위를 "같은 문서 안에서 두 진술이 동시에 참일 수 없는 지점"으로 한정해 페어 두 문서를 대조하는 리뷰어가 하나도 없었다.
스펙과 플랜이 1:1 페어를 이루는 규약에서 이 공백은 가장 비싼 결함을 놓친다.
플랜이 스펙 요구를 빠뜨리거나 값을 바꿔도 어느 리뷰어도 잡지 못한다.

리뷰어의 판정 범위를 좁게 고정하는 설계는 렌즈를 선명하게 하는 대신 경계 밖 축을 조용히 비운다.
이 대가를 로스터 층에서 갚는다.

## Decision

로스터의 필수 집합을 공통과 유형별로 가른다.

- 공통 필수 다섯: `junior-read`·`completeness`·`consistency`·`clarity`·`yagni`.
- 스펙 전용: `scope`.
- 플랜 전용: `decomposition`(태스크 경계·green 경계·의존 순서·Interfaces 정합·구현자 착수), `spec-alignment`(커버리지·범위 이탈·Global Constraints verbatim·값 일치·결정 대체).
- 재량 넷(`experience`·`facts`·`crossref`·`intent`)은 유형과 무관하게 표면 조건으로 판단한다.

`spec-alignment`에는 대응 스펙 경로를 필수 입력으로 동봉한다.
경로 없이 디스패치되면 리뷰를 수행하지 않고 FAIL을 반환한다.
이 리뷰어만 페어 두 문서를 대조하므로 대조 대상 부재는 축 자체의 붕괴다.

이 집합을 담는 곳은 유형별 리뷰 스킬의 본문이다.
`spec-review`가 스펙 집합을, `plan-review`가 플랜 집합을 각자 선언한다(ADR-0004).

## Consequences

Positive:
- 플랜이 스펙을 이행하는지 판정하는 축이 생긴다.
  페어 문서의 어긋남을 잡는 담당자가 명시된다.
- `scope`가 성립하지 않는 문서에 디스패치되지 않아 무의미한 FAIL과 왕복이 준다.
- 태스크 분해 결함(green 경계 위반·의존 역전·Interfaces 불일치)을 구현 착수 전에 잡는다.

Negative:
- 플랜 리뷰의 디스패치 수가 늘어 리뷰 1회 비용이 오른다.
  플랜 필수가 일곱이라 스펙 필수 여섯보다 많다.
- 유형마다 필수 집합이 달라 두 스킬이 각자 로스터를 들고 간다.
  공통 다섯을 고칠 때 양쪽을 함께 고쳐야 한다.
- lens 프롬프트가 열둘로 늘어 축 사이 판정 범위가 겹칠 여지가 커진다.
  `decomposition`의 placeholder 축과 `completeness`의 결정 이월 축이 인접한다.

## Compliance

- `spec-review`·`plan-review`가 각자 필수·재량을 본문에 선언한다.
- `plan-review`가 `spec-alignment` 디스패치에 대응 스펙 경로를 동봉한다.
- 플랜 전용 두 프롬프트가 자기 문서에 플랜 전용임을 명시해 스펙 리뷰에 오용되지 않게 한다.

## Notes

- Author: Claude Opus 5 (groundwork S2 세션)
- Version: 0.1
- Changelog:
  - 0.1: 최초 제안 (S2 구현 중 플랜 리뷰 공백 실측으로 발의)
  - 0.2: 로스터를 담는 곳을 `roster` 스킬에서 유형별 리뷰 스킬 본문으로 옮김 (ADR-0004의 스킬 분리 반영). 리뷰어 구성 결정 자체는 그대로다
