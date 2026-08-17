---
name: managing-repo-standard-docs
description: Use when README, CONTRIBUTING, CODE_OF_CONDUCT, SECURITY, SUPPORT, GOVERNANCE, CHANGELOG, 이슈·PR 템플릿을 새로 만들거나 표준에 맞는지 점검할 때, 리포에 어떤 표준 문서가 빠졌는지 감사할 때, community profile·health_percentage 수치를 해석할 때. 단일 파일 한 줄 수정은 대상이 아니다.
---

# Manage repository standard documents

리포가 갖춰야 할 표준 문서를 감사하고 각 문서를 그 문서의 표준과 검증된 관행에 맞게 쓴다.

**경로 기준**: 이 문서가 적은 `references/`·`scripts/`는 이 스킬 디렉터리 기준이다.  
문서가 놓이는 경로는 대상 repo 루트 기준이다.

**사실의 근거**: 문서마다 표준의 출처가 다르다.  
GitHub이 동작으로 규정한 것, 커뮤니티가 합의한 것, 관측으로 채운 것을 섞지 않는다.  
어느 쪽인지는 「The document set」이 가른다.

## The document set

| 문서                     | 표준의 출처                          | 근거 레퍼런스                             |
|--------------------------|--------------------------------------|-------------------------------------------|
| README.md                | GitHub 인식 + 제3자 실측 연구        | readme-standard.md                        |
| CONTRIBUTING.md          | GitHub 인식                          | github-standard.md, industry-practices.md |
| CODE_OF_CONDUCT.md       | GitHub 인식 + Contributor Covenant   | github-standard.md, industry-practices.md |
| SECURITY.md              | GitHub 인식                          | github-standard.md, industry-practices.md |
| SUPPORT.md               | GitHub 인식                          | github-standard.md                        |
| GOVERNANCE.md            | GitHub 인식. 전용 공식 문서는 없다   | github-standard.md                        |
| CHANGELOG.md             | 커뮤니티 표준. GitHub 인식 규칙 없다 | changelog-standard.md                     |
| ISSUE_TEMPLATE/          | GitHub 인식                          | github-standard.md                        |
| PULL_REQUEST_TEMPLATE.md | GitHub 인식                          | github-standard.md                        |

CHANGELOG만 출처가 다르다.  
GitHub은 CHANGELOG를 특별히 인식하지 않는다.  
근거는 Keep a Changelog 1.1.0과 Semantic Versioning 2.0.0이라는 커뮤니티 표준이고 준수는 프로젝트가 선언해야 성립한다.

LICENSE·CODEOWNERS·FUNDING.yml은 이 스킬 밖이다.  
문서가 아니라 각각 법률 문서, 접근 제어 설정, 결제 설정이라 판정 기준이 다르다.

## Placement

각 문서는 `.github/`·리포 루트·`docs/` 셋 중 어디에 둬도 인식된다.  
여러 곳에 있으면 `.github` → 루트 → `docs` 순으로 첫 매칭을 쓴다.

예외 둘이다.  
이슈 템플릿은 반드시 `.github/ISSUE_TEMPLATE/`의 default 브랜치에 둔다.  
CHANGELOG.md는 GitHub이 인식하지 않으므로 관행대로 리포 루트에 둔다.

파일명 대소문자 규정은 문서마다 다르다.  
[github-standard.md](references/github-standard.md)에 무엇이 규정돼 있고 무엇이 규정 없는지가 있다.

## Procedures by task

요청이 어느 작업인지 먼저 판정하고 해당 절차만 실행한다.

### Audit the repository

무엇이 있고 무엇이 빠졌는지 리포트한다.  
**읽기 전용**이다.

```bash
bash scripts/audit-docs.sh [repo_dir]
```

스크립트는 (a) 문서별 존재·위치, (b) 부재 목록, (c) 원격이 있으면 `gh api repos/{owner}/{repo}/community/profile`의 `health_percentage`를 출력한다.  
그 수치를 완전성 근거로 쓰지 않는다.  
이유는 「Gotchas」에 있다.

### Write or fix a document

「The document set」에서 그 문서의 근거 레퍼런스를 찾아 읽고 그 표준대로 쓴다.  
프로젝트 고유 정보 (연락처, 지원 버전, 행동강령 담당자, 빌드·테스트 명령) 는 사용자에게 확인해 채운다.  
추측으로 채우지 않는다.

CoC 소스 선택, CLA 채택 여부, SECURITY 보고 경로 설계처럼 판단이 필요하면 주요 기업의 실제 관행과 그 트레이드오프를 정리한 [industry-practices.md](references/industry-practices.md)를 읽는다.  
특히 CLA는 기본값이 아니라 법적 필요가 있을 때만 채택하는 트레이드오프다.

문서를 여러 개 만들면 서로 링크한다.  
README는 CONTRIBUTING·SECURITY·CHANGELOG로, CONTRIBUTING은 CoC로, 이슈 생성 경로는 SUPPORT로 간다.

## Automatic enforcement

훅 둘이 이 스킬로 들어오는 입구다.  
부재와 작성을 각각 덮는다.

| 훅                                          | 언제                            | 무엇을 하나                                            |
|---------------------------------------------|---------------------------------|--------------------------------------------------------|
| `hooks/session-start-standard-docs`         | 세션 시작                       | 빠진 문서를 한 줄로 알린다. 완비된 리포에서는 침묵한다 |
| `hooks/pre-standard-doc-write-gate`         | 이 문서들 중 하나를 새로 쓸 때  | 쓰기를 한 번 되돌리고 표준 요지와 읽을 레퍼런스를 준다 |

쓰기 게이트는 「Placement」의 인식 위치에 놓인 문서만 대상으로 한다.  
하위 디렉터리의 동명 파일 (패키지 README, 픽스처, vendor) 은 걸리지 않는다.

차단은 세션 안에서 문서 종류마다 한 번이다.  
이미 있는 문서를 고칠 때는 차단하지 않고 한 줄 안내만 나온다.

훅은 요지만 준다.  
판정 체크리스트와 근거는 레퍼런스에 있으므로 훅 안내를 받았으면 해당 레퍼런스를 읽고 쓴다.

세션 시작 알림은 부재를 보고할 뿐 작성을 지시하지 않는다.  
사용자가 요청하지 않았으면 그 알림만 보고 문서를 만들지 않는다.

## Gotchas

- **`health_percentage`로 완전성을 판단하지 않는다.**  
  GitHub은 채점 항목을 문서로 공개하지 않는다.  
  리포 18개 관측 결과, 파일이 아닌 리포 설명(description)이 항목에 들어가고 분모가 소유자에 따라 갈린다.  
  개인 소유는 7항목(설명·README·LICENSE·CoC·CONTRIBUTING·이슈 템플릿·PR 템플릿), 조직 소유는 여기에 SECURITY.md가 더해진 8항목이다.  
  SUPPORT·GOVERNANCE·CHANGELOG는 어느 쪽에도 안 들어간다.  
  이 관측에 반례는 없었으나 GitHub이 언제든 바꿀 수 있는 비공개 산식이다.  
  완전성은 감사 스크립트의 문서별 존재로 판단한다.
- **API 응답의 `files` 객체는 채점 대상 목록이 아니다.**  
  폴더형 이슈 템플릿은 채점에 반영되지만 `files.issue_template`에는 null로 나온다(예: facebook/react는 이 필드가 null인데 100%다).  
  반대로 `.github/ISSUE_TEMPLATE/`에 파일이 있어도 md는 `name:`·`about:`, 폼은 `name:`·`description:` 키가 유효하지 않으면 체크마크가 붙지 않는다.
- **CoC는 GitHub 제공 템플릿으로 만들어야 체크마크가 붙는다.**  
  손으로 쓴 CoC도 동작은 하지만 community profile에서는 완료로 표시되지 않는다.
- **이슈 템플릿 이름은 3자를 넘어야 한다.**  
  3자 이하면 이슈 생성 화면에 아예 안 뜬다.
- **파일명 대소문자 규칙이 문서마다 다르다.**  
  SUPPORT는 전부 대문자여야 한다.  
  CONTRIBUTING·PR 템플릿·이슈 템플릿 파일명은 대소문자를 가리지 않는다.  
  CODE_OF_CONDUCT는 GitHub이 규정을 밝히지 않으므로 표준 대문자로 쓴다.
- **CHANGELOG는 릴리스 노트와 다르다.**  
  GitHub Releases의 자동 생성 노트는 커밋·PR 제목 나열이라 Keep a Changelog가 금지하는 "커밋 로그 덤프"에 해당한다.  
  둘을 같은 것으로 다루지 않는다.
- **조직 `.github` 리포에서 문서를 상속받는 리포라면 부재 보고가 거짓이다.**  
  이 스킬은 상속을 감지하지 않는다.  
  상속 모델을 쓰는 리포에서는 감사 결과와 세션 알림이 실제로는 상속으로 채워진 문서를 부재로 센다.  
  그 상태에서 하위 리포에 사본을 만들면 정본을 덮는다.  
  특히 이슈 템플릿은 폴더 단위 override라 하위 리포 `.github/ISSUE_TEMPLATE/`에 파일을 하나만 둬도 정본 폴더 전체가 무효가 된다.  
  부재를 채우기 전에 조직 정본이 있는지 사용자에게 확인한다.
- **감사와 문서 편집은 자율로 진행한다.**  
  기존 문서의 대량 수정은 되돌리기 어렵거나 외부에 노출되므로 실행 전 확인한다.
