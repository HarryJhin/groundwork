---
name: managing-community-health-files
description: Use when 커뮤니티 헬스 파일(CODE_OF_CONDUCT, CONTRIBUTING, SECURITY.md, SUPPORT, GOVERNANCE, FUNDING.yml, CODEOWNERS, ISSUE_TEMPLATE, PULL_REQUEST_TEMPLATE, DISCUSSION_TEMPLATE)이 빠졌는지 점검하거나 표준에 맞게 새로 만들 때, 조직 `.github` 상속을 구성하거나 정본 문서를 고칠 때, community profile·health_percentage 수치를 해석할 때. 단일 파일 한 줄 수정은 대상이 아니다.
---

# 커뮤니티 헬스 파일 관리

GitHub 표준 커뮤니티 헬스 파일을 감사하고 표준에 맞게 채우고 조직 `.github` 상속 모델을 구성한다.

**경로 기준**: 이 문서가 적은 `references/`·`scripts/`는 이 스킬 디렉터리 `${CLAUDE_PLUGIN_ROOT}/skills/managing-community-health-files/` 기준이고, `${CLAUDE_PLUGIN_ROOT}`는 groundwork 플러그인이 설치된 디렉터리이지 실행 시점 작업 디렉터리가 아니다.
헬스 파일이 놓이는 경로는 대상 repo 루트 기준이다.

**사실의 근거**: 아래 GitHub 표준은 공식 문서에 근거하고 문단별 출처 URL은 [github-standard.md](references/github-standard.md)에 있다.
GitHub이 문서로 규정하지 않아 관측으로 채운 항목은 관측이라고 밝혀 적는다.
둘을 섞지 않는다.

## GitHub 표준 사실

출처: GitHub Docs "Creating a default community health file". FUNDING.yml·이슈 폼 YAML· CODEOWNERS의 상세 문법이나 배치 우선순위 표가 필요하면 [github-standard.md](references/github-standard.md)를 읽는다.

### 조직 `.github` 리포에서 상속되는 파일

`.github`라는 이름의 **public** 리포에 두면, 같은 계정 소유의 다른 리포가 자기 파일이 없을 때 상속한다.

- CODE_OF_CONDUCT.md
- CONTRIBUTING.md
- Discussion category forms (`DISCUSSION_TEMPLATE/`)
- FUNDING.yml
- GOVERNANCE.md
- Issue·PR 템플릿과 config.yml (`ISSUE_TEMPLATE/`, `PULL_REQUEST_TEMPLATE.md`)
- SECURITY.md
- SUPPORT.md

### 인식 디렉터리 우선순위

각 파일은 이 순서로 탐색한다.
현재 리포에 없으면 `.github` 리포를 같은 순서로 본다.

1. `.github/` 폴더
2. 리포 루트
3. `docs/` 폴더

예외 둘이다.
이슈 템플릿과 config는 반드시 `.github/ISSUE_TEMPLATE/` 폴더에 둔다.
FUNDING.yml은 `.github/`의 default 브랜치에만 둔다.
루트나 `docs/`에 있으면 GitHub이 무시한다.

### LICENSE는 상속 대상이 아니다

라이선스는 clone·package·download에 포함돼야 하므로 각 리포에 직접 둔다.
조직 `.github`에서 상속되지 않는다.

### CODEOWNERS

CODEOWNERS는 위 상속 목록에는 없지만 `.github`/루트/`docs`에서 인식되는 거버넌스 파일이다.
상속되지 않으므로 각 리포가 자체 보유한다.
마지막으로 매칭되는 패턴이 최우선이고 한 패턴의 여러 owner는 반드시 같은 줄에 둔다.
문법 상세는 github-standard.md에 있다.

## 작업별 절차

요청이 어느 작업인지 먼저 판정하고 해당 절차만 실행한다.

### 1. 감사·진단

리포에 무엇이 있고 무엇이 빠졌는지 리포트한다.
**읽기 전용**이다.

```bash
bash ${CLAUDE_PLUGIN_ROOT}/skills/managing-community-health-files/scripts/audit-health.sh [repo_dir]
```

스크립트는 (a) 지원 파일별 존재·위치, (b) 부재 목록, (c) 형제 조직 `.github` 리포 감지, (d) 원격이 있으면 `gh api repos/{owner}/{repo}/community/profile`의 `health_percentage`를 출력한다.
그 수치를 완전성 근거로 쓰지 않는다.
이유는 [Gotchas](#gotchas)에 있다.

### 2. 스캐폴딩 (부재 파일 생성)

**전제 확인**: 형제에 조직 `.github` 리포가 있으면 이 리포에 상속 문서를 만들지 않는다.
하위 리포의 자체 파일은 정본을 이기고 이슈 템플릿은 폴더 단위로 이겨서 정본 폴더 전체를 무효로 만든다.
상속 모델을 쓰는 리포라면 [작업 3](#3-조직-github-정본-셋업)으로 전환한다.

단일 리포(상속 없음)에서만 생성한다.
파일 내용은 아래 표준을 따르되 프로젝트 고유 정보 (연락처, 지원 버전, 행동강령 담당자)는 사용자에게 확인해 채운다.
추측으로 채우지 않는다.

CoC 소스 선택, CLA 채택 여부, SECURITY 보고 경로 설계처럼 판단이 필요하면 주요 기업의 실제 관행과 그 트레이드오프를 정리한 [industry-practices.md](references/industry-practices.md)를 읽는다.
특히 CLA는 기본값이 아니라 법적 필요가 있을 때만 채택하는 트레이드오프다.

| 파일 | 표준/기준 | 배치 |
|---|---|---|
| CODE_OF_CONDUCT.md | Contributor Covenant 2.1 (연락처 채움) | `.github/` 또는 루트 |
| CONTRIBUTING.md | 프로젝트 빌드·테스트·PR 흐름 기술 | `.github/` 또는 루트 |
| SECURITY.md | 취약점 보고 경로 + 지원 버전 표 | `.github/` 또는 루트 |
| SUPPORT.md | 도움 받을 채널 | `.github/` 또는 루트 |
| ISSUE_TEMPLATE/ | YAML issue forms 또는 md 템플릿 | `.github/ISSUE_TEMPLATE/` |
| PULL_REQUEST_TEMPLATE.md | 체크리스트 | `.github/` |
| FUNDING.yml | 플랫폼당 항목 1개, custom URL 최대 4개 | `.github/` (default 브랜치) |
| CODEOWNERS | 경로별 소유자. 신설 최상위 디렉터리 커버 | `.github/` 또는 루트 |
| LICENSE | SPDX 식별자 확인 후 전문 | 루트(상속 불가) |

이슈 템플릿을 만들면 [Gotchas](#gotchas)의 체크마크 조건과 이름 길이 제한을 함께 지킨다.

### 3. 조직 `.github` 정본 셋업

상속 모델을 구성하거나 정본 문서를 편집한다.

- 정본 리포 이름은 `.github`, 가시성은 **public**이어야 한다(private면 상속 안 됨).
- 공통 문서를 이 리포의 루트 또는 `.github/` 또는 `docs/`에 둔다.
  이슈 템플릿은 `.github/ISSUE_TEMPLATE/`.
- 하위 리포가 자기 파일을 두면 그 파일이 정본을 이긴다.
  이슈 템플릿은 **폴더 단위 오버라이드** 라서, 하위 리포 `.github/ISSUE_TEMPLATE/`에 파일이 하나라도 있으면 정본 폴더 전체가 무시된다.
- 이슈 템플릿이 label을 지정하면 그 label은 `.github` 리포와 템플릿을 쓰는 모든 리포에 존재해야 한다.
  없는 label은 자동 생성되지 않는다.

## Gotchas

- **`health_percentage`로 완전성을 판단하지 않는다.**
  GitHub은 채점 항목을 문서로 공개하지 않는다.
  리포 18개 관측 결과, 파일이 아닌 리포 설명(description)이 항목에 들어가고 분모가 소유자에 따라 갈린다.
  개인 소유는 7항목(설명·README·LICENSE·CoC·CONTRIBUTING·이슈 템플릿· PR 템플릿), 조직 소유는 여기에 SECURITY.md가 더해진 8항목이다.
  이 관측에 반례는 없었으나 GitHub이 언제든 바꿀 수 있는 비공개 산식이다.
  완전성은 감사 스크립트의 파일별 존재로 판단한다.
- **API 응답의 `files` 객체는 채점 대상 목록이 아니다.**
  폴더형 이슈 템플릿은 채점에 반영되지만 `files.issue_template`에는 null로 나온다(예: facebook/react는 이 필드가 null인데 100%다).
  반대로 `.github/ISSUE_TEMPLATE/`에 파일이 있어도 md는 `name:`·`about:`, 폼은 `name:`· `description:` 키가 유효하지 않으면 체크마크가 붙지 않는다.
- **CoC는 GitHub 제공 템플릿으로 만들어야 체크마크가 붙는다.**
  손으로 쓴 CoC도 동작은 하지만 community profile에서는 완료로 표시되지 않는다.
- **이슈 템플릿 이름은 3자를 넘어야 한다.**
  3자 이하면 이슈 생성 화면에 아예 안 뜬다.
- **파일명 대소문자 규칙이 파일마다 다르다.**
  SUPPORT는 전부 대문자여야 한다.
  CONTRIBUTING· PR 템플릿·이슈 템플릿 파일명은 대소문자를 가리지 않는다.
  CODEOWNERS 안의 **경로**는 대소문자를 구분한다.
  CODE_OF_CONDUCT는 GitHub이 규정을 밝히지 않으므로 표준 대문자로 쓴다.
- **LICENSE에 상속을 기대하지 않는다.**
  조직 `.github`에 둬도 하위 리포에 적용되지 않는다.
- **감사와 문서 편집은 자율로 진행한다.**
  리포 생성, 가시성 변경(private→public), 기존 정본 대량 수정은 비가역이거나 외부에 노출되므로 실행 전 확인한다.
