# ADR-0001: flow 단계와 스킬의 1:1 정렬

## Title

groundwork flow의 각 단계를 그 이름을 가진 스킬 하나에 대응시키고 여러 단계를 임시로 겸하던 `implementation-plan`을 분해한다.

## Status

Superseded

## Date

2026-07-25

## Context

SPEC-0001이 flow를 아홉 단계 사슬로 정의했다.
`bootstrap → finding-unknowns → spec-review → writing-plans → plan-review → executing-plan → test-driven-development → requesting-code-review → finish`다.
S1은 이 중 앞 세 단계만 지었고 나머지 여섯은 `implementation-plan` 스킬 하나가 임시로 덮었다.
부트스트랩의 flow 표가 그 상태를 "미구축. `groundwork:implementation-plan`이 대체"로 표기했다.

이 임시 상태에는 두 비용이 있다.
flow 사슬의 이름과 실물이 어긋나 부트스트랩을 읽은 에이전트가 `writing-plans`를 부를 수 없다.
그리고 `implementation-plan` 한 문서가 플랜 작성 규범과 실행 규율을 함께 담아 어느 쪽을 고쳐도 다른 쪽이 흔들린다.

`plan-review` 단계는 사정이 다르다.
기존 `spec-review`가 이미 스펙과 플랜을 함께 리뷰하도록 설계됐고 리뷰어 프롬프트가 문서 유형을 입력으로 받는다.
여기에 `plan-review` 스킬을 따로 세우면 코멘트 루프·사이드카 규약이 두 벌로 갈린다.
superpowers 원본은 `plan-document-reviewer-prompt.md` 한 장으로 얕게 처리하는데 groundwork의 코멘트 수렴 루프가 그보다 깊어 재사용이 더 이익이다.

## Decision

flow 단계마다 그 이름의 스킬을 두되 `plan-review`는 예외로 둔다.

- `writing-plans` 스킬을 신설해 플랜 작성·리뷰 호출·게재·승인을 맡긴다.
- `plan-review`는 별도 스킬 없이 `spec-review`를 문서 유형 `plan`으로 호출해 충족한다.
  부트스트랩 flow 표가 이 예외를 명시한다.
- `implementation-plan`은 실행·종료만 남긴다.
  이후 S3에서 `executing-plan`과 `finish`로 갈라지며 소멸한다.
- 단계 사이 핸드오프를 명시한다.
  `finding-unknowns` 승인 후 `writing-plans`로, `writing-plans` 승인 후 실행 스킬로 넘긴다.

## Consequences

Positive:
- 부트스트랩 flow 표의 단계 이름으로 스킬을 바로 부를 수 있다.
- 플랜 작성 규범과 실행 규율이 갈려 한쪽 개정이 다른 쪽을 흔들지 않는다.
- 코멘트 루프·사이드카 규약이 `spec-review` 한 곳에 남아 두 벌로 갈리지 않는다.

Negative:
- 스킬 파일 수가 는다.
  단계마다 문서가 생겨 전체를 파악하는 데 읽을 파일이 많아진다.
- `plan-review` 단계만 이름과 스킬이 1:1이 아니라 예외를 기억해야 한다.
  부트스트랩 표가 이 예외를 담는 대가로 표가 한 행 길어진다.
- 분해 과정에서 `implementation-plan`이 두 번 바뀐다.
  S2에서 축소하고 S3에서 소멸하므로 그 사이 이름과 내용이 어긋난 기간이 생긴다.

## Compliance

- 부트스트랩 flow 표의 각 행이 실재하는 스킬을 지목하거나 `plan-review`처럼 대체 경로를 명시한다.
- `writing-plans`는 플랜 작성·리뷰·승인만 담고 실행 절차를 담지 않는다.
- `implementation-plan`은 승인된 플랜을 입력으로 받고 플랜 작성 규범을 담지 않는다.

## Notes

- Author: jjh
- Version: 0.1
- Superseded by: ADR-0004
- Changelog:
  - 0.1: 최초 작성 (S2 착수 시점의 사용자 결정 기록)
