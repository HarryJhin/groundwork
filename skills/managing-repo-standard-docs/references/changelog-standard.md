# CHANGELOG standard and structure

CHANGELOG.md의 커뮤니티 표준과 작성 구조 레퍼런스.  
CHANGELOG를 새로 만들거나 기존 CHANGELOG가 표준을 벗어났는지 판정할 때 이 문서를 근거로 삼는다.

이 스킬이 다루는 다른 문서와 달리 CHANGELOG는 GitHub이 인식하는 문서가 아니다.  
공식 문서에 위치 규칙도 체크마크 조건도 없고 community profile 채점에도 안 들어간다.  
근거는 커뮤니티 표준 둘이고 준수는 프로젝트가 문서에 선언해야 성립한다.

## Sources

- Keep a Changelog 1.1.0: [^s-1-1-0]
- Semantic Versioning 2.0.0: [^semver-org]

아래 인용부호 안 문구는 위 두 표준의 원문이다.

## Guiding principles

Keep a Changelog가 세운 원칙은 일곱이다.

1. "Changelogs are for humans, not machines."
1. 모든 버전에 항목이 있어야 한다.
1. 같은 종류의 변경은 묶는다.
1. 버전과 구역은 링크 가능해야 한다.
1. 최신 버전이 맨 위에 온다.
1. 버전마다 릴리스 날짜를 표시한다.
1. Semantic Versioning 준수 여부를 문서에 밝힌다.

1번이 나머지를 지배한다.  
읽는 사람은 이 릴리스로 옮겨도 되는지를 판단하려고 CHANGELOG를 연다.  
그 판단에 쓰이지 않는 항목은 넣지 않는다.

## Change types

여섯 가지만 쓴다.  
새 종류를 만들지 않는다.

| 종류         | 언제 쓰나                                    |
|--------------|----------------------------------------------|
| `Added`      | 새 기능                                      |
| `Changed`    | 기존 기능의 동작 변경                        |
| `Deprecated` | 곧 제거될 기능                               |
| `Removed`    | 이번에 제거한 기능                           |
| `Fixed`      | 버그 수정                                    |
| `Security`   | 취약점 관련 변경                             |

## Structural rules

- 파일명은 `CHANGELOG.md`다.
- 맨 위에 `Unreleased` 구역을 두고 다음 릴리스에 들어갈 변경을 쌓는다.  
  릴리스할 때 이 구역을 버전 번호로 바꾸고 새 `Unreleased`를 만든다.
- 날짜는 ISO 8601 (`YYYY-MM-DD`) 로 쓴다.
- 최신 버전이 위, 오래된 버전이 아래다.
- 회수한 릴리스는 `[YANKED]`로 표시한다.

## Version numbers

Semantic Versioning 2.0.0의 증가 규칙이다.

| 자리    | 올리는 경우                                              |
|---------|----------------------------------------------------------|
| MAJOR   | "incompatible API changes"                               |
| MINOR   | "add functionality in a backward compatible manner"      |
| PATCH   | "backward compatible bug fixes"                          |

"Major version zero (0.y.z) is for initial development. Anything MAY change at any time."  
0.x 구간에서는 호환성 약속이 없으므로 MINOR를 깨는 변경에 써도 표준 위반이 아니다.  
다만 그 사실을 README의 상태 절에 밝혀야 사용자가 판단할 수 있다.

## Template

```markdown
# Changelog

이 문서의 형식은 [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)를 따르고
버전은 [Semantic Versioning](https://semver.org/)을 따른다.

## [Unreleased]

### Added

- 아직 릴리스되지 않은 새 기능

## [1.2.0] - 2026-08-17

### Added

- 사용자가 무엇을 새로 할 수 있게 됐는지

### Fixed

- 어떤 상황에서 무엇이 잘못 동작했고 이제 어떻게 되는지

[Unreleased]: https://github.com/OWNER/REPO/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/OWNER/REPO/compare/v1.1.0...v1.2.0
```

## What makes a bad changelog

Keep a Changelog가 지목하는 실패 넷이다.

- **커밋 로그를 그대로 붙인다.** 노이즈가 많고 사용자 관점의 맥락이 없다.
- **폐기 예정을 안 알린다.** 업그레이드하는 쪽이 무엇이 깨질지 미리 알 수 없다.
- **날짜 형식이 흔들린다.** 지역마다 다르게 읽혀 뜻이 갈린다.
- **어떤 변경은 적고 어떤 변경은 안 적는다.** 기록을 신뢰할 수 없게 된다.

### Write for the reader, not from the diff

Before:

```markdown
### Changed

- Refactor `resolveConfig()` to use `Map` instead of object literal (#412)
- Bump lodash to 4.17.21
```

무엇이 바뀌었는지는 있지만 나에게 무슨 일이 생기는지가 없다.  
첫 줄은 내부 구현이라 사용자가 할 일이 없고, 둘째 줄은 그 업그레이드가 무엇을 고쳤는지 없다.

After:

```markdown
### Changed

- 설정 키 중복을 이제 오류로 막는다. 전에는 마지막 값이 조용히 이겼다 (#412).

### Security

- lodash를 4.17.21로 올려 prototype pollution (CVE-2021-23337) 을 없앴다.
```

## Checklist

- [ ] 파일 첫머리에 Keep a Changelog와 SemVer를 따른다고 밝혔는가
- [ ] `Unreleased` 구역이 맨 위에 있는가
- [ ] 최신 버전이 위에 오는가
- [ ] 버전마다 `YYYY-MM-DD` 날짜가 있는가
- [ ] 여섯 종류 밖의 제목을 만들지 않았는가
- [ ] 각 항목이 커밋 제목이 아니라 사용자에게 생기는 변화를 말하는가
- [ ] 호환성을 깨는 변경이 MAJOR 증가나 0.x 표기와 맞는가

[^s-1-1-0]: https://keepachangelog.com/en/1.1.0/
[^semver-org]: https://semver.org/
