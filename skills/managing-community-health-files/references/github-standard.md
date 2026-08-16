# Official GitHub community health file standard

GitHub 공식 문서 기준의 배치 규칙, 상속 모델, 파일별 문법 레퍼런스. 스캐폴딩하거나 파일 위치를 판정할 때 이 문서를 근거로 삼는다.
각 섹션 헤더 아래의 "출처" URL이 그 섹션을 검증하는 docs 페이지다.

표시 없는 항목은 GitHub이 강제하는 동작 규칙(배치·문법·상속)이고 `[권장]`으로 표시된 것만 GitHub의 권고다.

## Inheritance model (default community health file)

출처: https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file

- `.github`라는 이름의 **public** 리포에 헬스 파일을 두면, 같은 계정(조직 또는 개인) 소유의 다른 리포가 그 타입 파일을 자체 보유하지 않을 때 GitHub이 default를 사용·표시한다.
- private `.github` 리포는 상속에 쓰이지 않는다.
  반드시 public이어야 한다.
- `.github` 리포의 default 파일은 개별 리포의 파일 브라우저·Git 히스토리에 나타나지 않고 clone·package·download에도 포함되지 않는다.
- 리포가 자체 `.github/ISSUE_TEMPLATE` 폴더에 파일을 하나라도 두면, default `.github/ISSUE_TEMPLATE` 폴더 내용은 **전혀** 쓰이지 않는다(폴더 단위 override).
- 이슈 템플릿이 label을 지정하면, 그 label은 `.github` 리포와 템플릿을 쓰는 모든 리포에 존재해야 한다.
- **LICENSE는 default로 만들 수 없다.**
  clone·package·download에 포함되도록 개별 리포에 직접 둔다.

### Supported default files

CODE_OF_CONDUCT.md, CONTRIBUTING.md, Discussion category forms(`DISCUSSION_TEMPLATE/`), FUNDING.yml, GOVERNANCE.md, 이슈·PR 템플릿과 config.yml, SECURITY.md, SUPPORT.md.

## Placement and lookup precedence

출처: 위 creating-a-default 페이지(배치 규칙 종합). 파일별 상세는 아래 각 섹션의 출처.

각 파일은 3개 위치에서 인식된다.
여러 곳에 있으면 아래 우선순위로 첫 매칭을 쓴다.

| 파일 | 인식 위치 | 우선순위 | 비고 |
|---|---|---|---|
| CODE_OF_CONDUCT.md | 루트 / `docs/` / `.github/` | `.github` → 루트 → `docs` | 파일명 대소문자 규정 없음 |
| CONTRIBUTING.md | 루트 / `docs/` / `.github/` | `.github` → 루트 → `docs` | 파일명 대소문자 무관, 확장자 유연 |
| SECURITY.md | 루트 / `docs/` / `.github/` | `.github` → 루트 → `docs` | |
| SUPPORT.md | 루트 / `docs/` / `.github/` | 동일 | 전부 대문자 |
| GOVERNANCE.md | 루트 / `docs/` / `.github/` | 동일 | 전용 문서 페이지 없음 |
| FUNDING.yml | `.github/`의 **default 브랜치** | 고정 | 아래 문법 참조 |
| PULL_REQUEST_TEMPLATE.md | 루트 / `docs/` / `.github/` | default 브랜치 | 확장자 `.md`/`.txt`, 대소문자 무관 |
| ISSUE_TEMPLATE/ | `.github/ISSUE_TEMPLATE/`만 | 고정 | default 브랜치, 다른 브랜치 불가 |
| CODEOWNERS | `.github/` / 루트 / `docs/` | `.github` → 루트 → `docs` | 3MB 미만이어야 로드 |

파일명 대소문자는 파일마다 규정이 다르다.
GitHub이 명시하는 것은 3가지뿐이다.
CONTRIBUTING과 PR 템플릿과 이슈 템플릿의 파일명은 "not case sensitive"이고 SUPPORT는 "with all caps"이며 CODEOWNERS 안에 적는 **경로**는 대소문자를 구분한다.
CODE_OF_CONDUCT를 비롯한 나머지는 공식 문서가 어느 쪽도 말하지 않으므로 표준 대문자로 쓰고 대소문자 무관을 가정하지 않는다.

## Key points by file

파일마다 GitHub이 인정하는 조건과 위치가 다르다.

### CODE_OF_CONDUCT

출처: https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/adding-a-code-of-conduct-to-your-project

- community profile 체크리스트에서 "Code of conduct"가 완료로 표시되는 것은 **GitHub 제공 템플릿을 쓴 경우에만**이다.
  수동 작성한 CoC도 동작은 하나 체크마크는 안 붙는다.
- 감지된 CoC는 community profile API에서 이름으로 노출된다(예: `Contributor Covenant`, key `contributor_covenant`).
- `[권장]` 채택 전 여러 CoC를 조사해 커뮤니티에 맞는 것을 고르고 실제 집행 의지·능력을 갖췄는지 신중히 판단한다.
  남이 만든 것을 쓸 때는 attribution 지침을 따른다.

### CONTRIBUTING

출처: https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/setting-guidelines-for-repository-contributors

- `CONTRIBUTING.md`가 있으면 이슈·PR 생성 화면에 링크가 뜨고 `contribute` 페이지와 리포 개요의 "Contributing" 링크에 노출된다.
- `[권장]` 이슈·PR 생성 절차, 외부 문서·메일링리스트·CoC 링크, 커뮤니티 기대치를 담는다.

### SECURITY

출처: https://docs.github.com/en/code-security/how-tos/report-and-fix-vulnerabilities/configure-vulnerability-reporting/add-security-policy

- 리포 "Security and quality" 탭 → Reporting → Security policy → Start setup으로 생성한다.
- `[권장]` 지원 버전(supported versions) 정보와 취약점 보고 방법을 기술한다.

### SUPPORT

출처: https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/adding-support-resources-to-your-project

- 이슈 생성 시 SUPPORT 파일 링크가 표시된다.
- `[권장]` README 등에서 SUPPORT로 링크해 발견성을 높인다.

### FUNDING.yml syntax

출처: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/displaying-a-sponsor-button-in-your-repository

`.github/FUNDING.yml`(default 브랜치)에 둔다.
플랫폼당 항목 1개, custom URL은 최대 4개.

```yaml
github: USERNAME            # 또는 [U1, U2, U3, U4] (조직 1개 + 개발자 최대 4)
patreon: USERNAME
open_collective: USERNAME
ko_fi: USERNAME
tidelift: PLATFORM/PACKAGE  # PLATFORM = npm/pypi/rubygems/maven/packagist/nuget
community_bridge: PROJECT-NAME   # LFX Mentorship
liberapay: USERNAME
issuehunt: USERNAME
polar: USERNAME
buy_me_a_coffee: USERNAME
thanks_dev: u/gh/USERNAME
custom: ["https://example.com/donate", "LINK2"]   # URL에 ':' 있으면 따옴표 필수
```

위가 현재 문서에 실린 플랫폼 전부다.
목록은 GitHub이 늘리므로 낯선 플랫폼을 요청받으면 출처 페이지를 다시 확인한다.

- 배열 내 custom URL에 `:`가 있으면 따옴표로 감싼다.
- sponsor 버튼 활성화는 admin 권한이 필요하다(Settings → Features → Sponsorships).

## Issue and pull request templates

출처: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/about-issue-and-pull-request-templates config.yml: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository PR 템플릿: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/creating-a-pull-request-template-for-your-repository

### Placement and detection rules

- 이슈 템플릿은 default 브랜치의 `.github/ISSUE_TEMPLATE`에만 둔다.
  마크다운은 `.md`, 이슈 폼은 `.yml`.
- community profile 체크마크 조건: `.github/ISSUE_TEMPLATE`에 위치 + 마크다운은 frontmatter에 유효한 `name:`·`about:`, 이슈 폼은 유효한 `name:`·`description:` 키.
- 템플릿 이름은 3자를 초과해야 이슈 생성 화면에 보인다.
- 파일은 알파벳순 정렬되고 타입별로 그룹핑된다(YAML이 Markdown보다 먼저).
  파일명 숫자 프리픽스(`1-bug.yml`, 10개 이상은 `01-`)로 순서를 제어한다.
- 다중 PR 템플릿은 지원 폴더 안 `PULL_REQUEST_TEMPLATE/` 하위 디렉터리에 두고 `?template=` 쿼리 파라미터로 선택한다.

### config.yml (template chooser)

`.github/ISSUE_TEMPLATE/config.yml`:

```yaml
blank_issues_enabled: false   # false면 blank issue를 maintainer에게만 노출
contact_links:
  - name: 커뮤니티 포럼
    url: https://example.com/forum
    about: 질문은 여기서
```

### Issue form YAML syntax

출처: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms body 요소 스키마: https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema

최상위 키는 `name`(필수, unique), `description`(필수), `body`(필수, 배열)로 시작한다.
선택 키: `assignees`, `labels`, `title`, `type`, `projects`.

`body` 요소 공통 키: `type`(필수), `id`(markdown 제외, 폼 내 unique), `attributes`, `validations`.

`type` 유효값과 요점:

| type | 핵심 attributes | validations |
|---|---|---|
| `markdown` | `value`(렌더만, 제출 안 됨). `#` 헤더는 따옴표로 감쌈 | 없음 |
| `input` | `label`, `description`, `placeholder`, `value` | `required` |
| `textarea` | 위 + `render`(언어 지정 시 코드블록) | `required` |
| `dropdown` | `label`, `multiple`, `options`(비어있을 수 없고 중복 불가), `default`(인덱스) | `required` |
| `checkboxes` | `label`, `options`(각 `label`+선택적 `required`) | `required` |
| `upload` | `label`, `description` | `required`, `accept`(확장자 콤마구분) |

- `validations.required`는 **public 리포에서만** 동작한다.
- `labels`는 리포에 없는 label을 자동 생성하지 않는다.
- 이슈 폼은 public preview 상태다(문법 변경 가능).

## CODEOWNERS syntax

출처: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners

- `.github/` / 루트 / `docs/` 중 한 곳의 `CODEOWNERS`. 여러 곳이면 이 순서로 첫 매칭.
- review가 요청되려면 PR의 **base 브랜치**에 CODEOWNERS가 있어야 한다.
- code owner는 리포에 명시적 **write 권한**이 필요하다.
  팀 형식은 `@org/team-name`.
- **마지막으로 매칭되는 패턴이 최우선**이다(순서가 중요).
  한 패턴에 여러 owner를 지정하려면 모두 **같은 줄**에 둔다.
  다른 줄이면 마지막 것만 매칭된다.
- 경로는 대소문자를 구분한다.
  유효하지 않은 라인은 스킵되고 REST API로 확인된다 (`gh api repos/{owner}/{repo}/codeowners/errors`).
- gitignore 패턴을 대부분 따르나 CODEOWNERS에서 **안 되는 것**: `#`을 `\`로 이스케이프, `!` negation, `[ ]` 문자 범위.
- 파일 3MB 이상이면 로드되지 않아 owner 정보가 표시되지 않는다.

```text
*                    @org/global-owners      # 전체 기본
*.js                 @org/frontend           # 확장자
/build/logs/         @org/ops                # 디렉터리+하위
docs/*               @org/docs               # 한 단계만 (더 깊은 중첩 제외)
/.github/            @org/maintainers        # CODEOWNERS 자체도 보호
```

- `[권장]` 리포 완전 보호를 위해 CODEOWNERS 파일 자체의 owner도 정의한다.
  가장 안전한 방법은 `.github/` 디렉터리에 CODEOWNERS를 두고 `/.github/ @owner`로 그 디렉터리를 커버하는 것이다.

## community profile

출처: https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/about-community-profiles-for-public-repositories (REST API는 https://docs.github.com/en/rest/metrics/community)

- `GET /repos/{owner}/{repo}/community/profile`이 메트릭을 반환한다(포크 리포는 불가).
- `health_percentage`는 "권장 커뮤니티 헬스 파일 중 몇 개가 있는지의 비율"이다.
  **GitHub은 그 항목 목록도 산식도 공개하지 않는다.**
  REST 문서는 비율이라고만 쓰고 community profile 페이지도 "such as README, CODE_OF_CONDUCT, LICENSE, or CONTRIBUTING"으로 예시만 든다.
- 응답의 `files` 객체(code_of_conduct, code_of_conduct_file, contributing, issue_template, pull_request_template, license, readme)는 **채점 대상 목록이 아니다.**
  감지된 파일의 링크를 주는 필드일 뿐이다.
  이 둘을 같은 것으로 읽으면 안 된다.

### Observed formula (undocumented, reproducible)

아래는 공식 사실이 아니라 리포 18개를 조회해 역산한 관측이다.
GitHub이 예고 없이 바꿀 수 있다.

- 개인(User) 소유 리포의 점수는 전부 100/7의 배수(14·28·42·57·71·85·100)로 떨어진다.
  항목 7개는 리포 설명(description)·README·LICENSE·CoC·CONTRIBUTING·이슈 템플릿·PR 템플릿이다.
- 조직(Organization) 소유 리포의 점수는 전부 12.5의 배수(25·37·50·75·87·100)로 떨어진다.
  위 7개에 SECURITY.md가 더해진 8항목이다.
- 따라서 **파일이 아닌 리포 설명이 점수에 들어가고 SECURITY.md는 조직 리포에서만 채점된다.**
  "SECURITY·SUPPORT·GOVERNANCE·FUNDING은 지표에 없다"는 서술은 조직 리포에서 틀린다.

근거가 되는 대조군은 이렇다.

| 리포 | 소유 | 채점되는 것 | 점수 | 해석 |
|---|---|---|---|---|
| mxstbr/mxstbr.com | User | README (설명 없음) | 14 | 1/7 |
| torvalds/linux | User | 설명·README·LICENSE | 42 | 3/7 |
| junegunn/fzf | User | 설명·README·LICENSE·이슈템플릿·PR템플릿 | 71 | 5/7. SECURITY.md가 있는데 안 세어진다 |
| ORNL/HeCBench | Org | README·LICENSE (설명 없음) | 25 | 2/8 |
| 0dotxyz/marginfi-v2 | Org | README·LICENSE·SECURITY (설명 없음) | 37 | 3/8. SECURITY가 3번째 항목이다 |
| facebook/react | Org | 8항목 | 100 | `files.issue_template`이 null인데도 100이다 |

재현 방법은 다음과 같다.

```bash
gh api repos/{owner}/{repo}/community/profile --jq '.health_percentage'
gh api repos/{owner}/{repo} --jq '{owner_type: .owner.type, description}'
```

**실무 결론**: 이 수치로 완전성을 판단하지 않는다.
100%여도 SUPPORT·GOVERNANCE·FUNDING은 없을 수 있고 개인 리포는 SECURITY.md가 없어도 100%가 된다.
완전성은 파일별 존재로 판단한다.

---

위 출처는 전부 `docs.github.com/en/` 하위 페이지이고 2026-08-05에 Crawl4AI로 크롤해 확인했다.
같은 날 `gh api`로 산식 관측을 수행했다.
이슈 폼처럼 preview 상태인 기능은 문법이 바뀔 수 있으니 스캐폴딩 전 해당 페이지를 재확인한다.
