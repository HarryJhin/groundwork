# ADR-0012: English headings and deletion of the dead archives

## Title

리포의 모든 마크다운 제목을 영문 sentence case로 통일하고 본문은 한국어로 남긴다.
flow가 생성하는 설계 문서의 절 이름도 함께 영문화한다.
`docs/specs/`와 `docs/plans/`의 아카이브 파일 둘을 삭제한다.

## Status

Accepted

수락된 ADR의 **제목**을 고치는 첫 결정이다.
아래 「Decision」의 마지막 항목이 그 예외를 규정한다.

## Date

2026-08-16

## Context

### 용어

- **제목**: 마크다운 헤딩(`#`부터 `######`까지). 이 문서에서 헤딩과 같은 뜻으로 쓴다.
- **sentence case**: 첫 글자와 고유명사만 대문자로 쓰는 표기. `Reviewer roster`가 sentence case이고 `Reviewer Roster`는 아니다.
- **flow**: groundwork가 강제하는 스킬 사슬. 설계에서 종료까지 이어진다.
- **설계 문서**: flow가 남기는 커밋 산출물. `docs/designs/DESIGN-NNNN-<topic>.md`.
- **아카이브**: 더 만들지 않기로 한 산출물 종류의 남은 파일.

### 제목 언어가 두 갈래였다

이 리포의 마크다운 제목은 대부분 한국어였고 일부만 영문이었다.
영문인 쪽은 두 부류다.
ADR의 섹션명(`## Context`, `## Decision`)은 `groundwork:writing-adr`이 영문으로 못박았고, 이식해 온 스킬의 잔재(`## Red Flags`, `## Skill Priority`, `## The Rule`)는 원본 표기 그대로였다.

같은 문서 안에서 갈리기도 했다.
`skills/using-groundwork/SKILL.md`가 `## 이 문서의 범위`와 `## Skill Priority`를 나란히 두고 있었다.
규칙이 없어서 갈린 것이지 이유가 있어 갈린 것이 아니다.

사용자의 전역 지침은 영어 초안의 제목 규칙을 이미 갖고 있다.
작업형 제목은 원형 동사로 시작하고 `-ing`를 첫 단어로 쓰지 않으며, 개념형 제목은 `-ing`로 시작하지 않는 명사구로 쓴다.
그 규칙이 한국어 제목에는 적용될 자리가 없었다.

### 죽은 아카이브가 현재 규약으로 읽혔다

`docs/specs/SPEC-0001-spec-pipeline.md`와 `docs/plans/PLAN-0001-spec-pipeline.md`가 남아 있었다.

두 산출물 종류는 이미 폐기됐다.
`docs/adr/ADR-0008-collapsing-the-plan-stage.md`가 플랜 단계를 없앴고 `docs/adr/ADR-0009-execution-asset-ownership.md`와 `docs/adr/ADR-0010-renaming-spec-to-design-doc.md`가 스펙을 설계 문서로 개명했다.
남은 파일은 스킬이 다섯이고 `agents/` 디렉터리가 있던 시절의 구성을 서술한다.

`docs/README.md`가 "낡은 내용을 그대로 두는 이유"를 적어 그 오독을 막고 있었으나, 그 설명 자체가 읽는 사람에게 부담을 옮긴 것이다.
ADR이 결정의 이력을 이미 담고 있어 두 파일이 더 나르는 정보가 없다.

## Decision

### 모든 제목을 영문 sentence case로 쓴다

h1을 포함한 모든 마크다운 헤딩이 대상이다.
본문 서술은 한국어로 남긴다.

작업을 지시하는 제목은 원형 동사로 시작한다(`Apply the review gate`).
개념을 가리키는 제목은 명사구로 쓴다(`Reviewer roster`).
둘 다 `-ing`를 첫 단어로 쓰지 않는다.

코드 펜스 안의 셸 주석은 제목이 아니므로 한국어로 남긴다.
`#`으로 시작하지만 마크다운 헤딩이 아니다.

### 상호 참조도 함께 옮긴다

이 리포는 본문에서 다른 절을 `「제목」`으로 가리킨다.
제목을 바꾸면서 그 참조를 같이 바꾸지 않으면 독자가 찾을 헤딩이 문서에 없다.
`「」` 안의 문자열은 대상 헤딩과 글자 그대로 일치해야 한다.

`「」`가 헤딩이 아니라 표의 열 이름이나 굵은 라벨을 가리키는 경우가 있다.
그것들은 제목이 아니므로 한국어로 남긴다.

### 산출물의 절 이름도 영문화한다

flow가 생성하는 설계 문서의 절 이름을 영문으로 정한다.

| 이전 | 이후 |
|---|---|
| `# 설계: <주제>` | `# Design: <topic>` |
| `## 용어` | `## Terminology` |
| `## 범위` | `## Scope` |
| `## 제외 범위` | `## Non-goals` |
| `## 설계` | `## Design` |
| `## 전역 제약` | `## Global constraints` |
| `## 수용 기준` | `## Acceptance criteria` |
| `## 호환성·마이그레이션` | `## Compatibility and migration` |

이 이름을 참조하는 곳이 함께 바뀐다.
`hooks/pre-artifact-write-junior-gate`의 안내문, `skills/design-review/`의 리뷰어 프롬프트, `groundwork:writing-for-junior`의 문서 유형별 필수 절 표, 두 실행 스킬이다.

생성되는 설계 문서는 영문 제목과 한국어 본문을 갖는다.
ADR이 이미 그 형태로 돌고 있어 새로 생기는 혼합이 아니다.

### 프롬프트 템플릿 안의 제목도 영문화한다

리뷰어·구현자 프롬프트는 본문을 ```` ```text ```` 펜스로 감싸 서브에이전트에 주입한다.
그 펜스 안의 제목은 마크다운 헤딩으로 렌더링되지 않지만 서브에이전트가 읽는 구조이고 출력 형식을 지정한다.
그래서 대상에 넣는다.

### 아카이브 파일 둘을 삭제한다

`docs/specs/SPEC-0001-spec-pipeline.md`와 `docs/plans/PLAN-0001-spec-pipeline.md`를 지우고 빈 디렉터리도 없앤다.
`docs/README.md`가 삭제 사실과 git 히스토리에서 꺼내는 방법을 적는다.

두 파일을 가리키던 참조를 옮긴다.
`skills/finding-unknowns/example-design.md`가 규율 하드 게이트 제거 이력을 인용하던 곳은 `docs/adr/ADR-0004-review-split-and-fileless-loop.md`를 가리키게 한다.
`docs/README.md`가 설계 문서 형식의 실물 예시로 `SPEC-0001`을 지목하던 곳은 `skills/finding-unknowns/example-design.md`를 가리키게 한다.

### 수락된 ADR의 제목 불변성을 표기 범위에서 푼다

`groundwork:writing-adr`은 수락된 ADR을 불변으로 둔다.
그 불변은 **결정과 근거**에 걸린다.
제목 문자열의 표기는 거기 들지 않는다.

이 결정이 ADR-0001부터 ADR-0011까지의 h1을 영문으로 옮긴다.
각 문서의 `Context`·`Decision`·`Consequences`는 한 글자도 건드리지 않는다.

## Consequences

Positive:
- 제목 표기가 문서마다 갈리지 않는다.
  이식해 온 스킬의 영문 잔재와 새로 쓴 한국어 제목이 한 문서 안에 섞이던 상태가 해소된다.
- 사용자 전역 지침의 제목 규칙(작업형은 원형 동사, 개념형은 명사구, `-ing` 금지)이 적용될 자리가 생긴다.
- 설계 문서가 ADR과 같은 형태(영문 제목, 한국어 본문)를 갖는다.
- 죽은 아카이브가 현재 규약으로 오독될 여지가 사라진다.
  `docs/README.md`가 그 오독을 막으려고 두던 설명도 함께 준다.

Negative:
- **한국어 본문에 영문 제목이 섞인다.**
  한국어로 일하는 사용자가 목차를 훑을 때 언어를 한 번 갈아탄다.
  ADR이 이미 그렇게 돌고 있었으나 이제 스킬 전체가 그렇게 된다.
- **참조 정합을 기계로 강제하지 않는다.**
  `「제목」`이 실재 헤딩을 가리키는지 검사하는 것은 이번에 임시 스크립트로 했고 리포에 남기지 않았다.
  다음 개정에서 참조가 깨져도 드러나지 않는다.
- **`「」`의 용법이 두 가지로 갈린 채 남는다.**
  헤딩 참조는 영문이고 표 열 이름·굵은 라벨 참조는 한국어다.
  읽는 사람이 그 둘을 표기로 구분할 수 없다.
- **아카이브 삭제는 되돌리는 데 git 조작이 든다.**
  파일 자체는 히스토리에 있으나 경로로 열리지 않는다.
  `docs/README.md`가 꺼내는 커맨드를 적었으나 그것을 읽어야 한다는 조건이 붙는다.
- **번역이 원문의 뉘앙스를 일부 잃는다.**
  `종료`를 `Handoff`로, `적용 판단`을 `Applicability`로 옮기면서 원 제목이 담던 어감이 바뀐 곳이 있다.
  본문이 그 뜻을 다시 설명하므로 판독에는 지장이 없으나 제목만 읽고 넘어가는 독자에게는 다르게 읽힌다.
- **이 개정도 groundwork flow를 거치지 않았다.**
  리포 루트의 `CLAUDE.local.md`가 이 리포를 flow에서 면제한다.

## Compliance

아래 경로는 모두 리포 루트 기준이다.

- `skills/`, `docs/`, `README.md`, `CONTRIBUTING.md`, `AGENTS.md`의 마크다운 헤딩에 한글이 없다.
  코드 펜스 안의 셸 주석은 제외한다.
- `docs/specs/`와 `docs/plans/`가 존재하지 않는다.
- 리포 어디에도 `SPEC-0001`·`PLAN-0001`·`docs/specs`·`docs/plans`를 실재 파일로 가리키는 참조가 없다.
  수락된 ADR의 본문이 이력으로 서술하는 것은 제외한다.
- `README.md`의 목차 앵커가 실재 헤딩으로 해소된다.
- `skills/finding-unknowns/SKILL.md`의 문서 구성 요소 표가 영문 절 이름을 헤딩 문자열로 지목한다.
- `hooks/pre-artifact-write-junior-gate`가 영문 절 이름으로 안내한다.
- `CONTRIBUTING.md`의 작업 규칙과 `groundwork:writing-skills`가 제목 언어 규칙을 담는다.
- `groundwork:writing-adr`이 h1을 포함한 모든 제목을 영문으로 규정한다.

## Notes

- Author: jjh
- Version: 0.1
- Changelog:
  - 0.1: 최초 작성
