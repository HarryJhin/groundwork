# Community health file practice at major companies

Google, Android, Apple, Meta, AWS, Microsoft가 공개 리포에서 실제로 무엇을 두는지 관찰한 레퍼런스. 스캐폴딩·정책 결정 시 참고한다.

## Rules and limits of this document (read first)

- **사실 주장에는 검증 경로가 붙는다.**
  각 항목 끝의 `gh api ...` 경로나 URL이 그 주장을 직접 확인하는 방법이다.
  검증 경로가 없는 사실 주장은 이 문서에 남기지 않는다.
- **한계 1, 관찰이지 검증이 아니다.**
  여기 적힌 것은 "대기업이 하는 관행"이지 "커뮤니티 건강에 효과가 있다고 독립 연구로 입증된 것"이 아니다.
  모든 출처가 벤더 자사(GitHub·각 기업)다.
  독립 제3자 효과성 연구(OpenSSF Scorecard, CHAOSS 등)는 이 조사 범위 밖이다.
  아래 "판단"은 관찰에서 끌어낸 해석이고 그 근거 사실만 검증 경로로 뒷받침된다.
- **한계 2, 규모 편향.** 이들은 법무팀·보안팀·전용 인프라를 갖춘 초대형 조직이다.
  자체 브랜드 CoC, CLA 봇, 전용 취약점 포털은 그 규모라서 가능하다.
  소규모 프로젝트에 그대로 복제하면 과설계다.
  "무엇을 베낄지"가 아니라 "어떤 원리를 규모에 맞게 적용할지"로 읽는다.

## Observation summary by organization

값이 곧 검증 대상이다.
파일 존재는 각 조직 `.github` contents 조회, 문구는 해당 파일 디코드로 확인했다(축별 분석에 경로 명시).

| 조직 | 정본 `.github` 상속 파일 | CoC 소스 | CLA | SECURITY 보고 경로 |
|---|---|---|---|---|
| Google | CoC·CONTRIBUTING·SECURITY | 자체 "Community Guidelines" (Covenant 파생 아님) | 요구 (cla.developers.google.com) | 중앙 인테이크 g.co/vulnz |
| Android/AOSP | 해당 없음 (Gerrit 기반) | 별도 | 요구 (Google 공통 CLA) | AOSP 별도 채널 |
| Apple | CoC·SECURITY 2종 | Contributor Covenant | 없음 | GitHub private reporting + security.apple.com |
| Meta | CoC·CONTRIBUTING·SECURITY 3종 | Contributor Covenant 1.4 | 요구 (code.facebook.com/cla) | 버그바운티 facebook.com/whitehat |
| AWS | CoC·CONTRIBUTING·SECURITY·PR템플릿 4종 | 자체 "Amazon OSS CoC" (Covenant 2.1) | 미요구 | HackerOne + aws-security@amazon.com |
| Microsoft | CoC·SECURITY 2종 (+CLA·policies·profile 디렉터리) | 자체 "MS OSS CoC" (Covenant 2.0) | 리포에 CLA 디렉터리 존재 | MSRC 포털 msrc.microsoft.com/create-report |

## Analysis by axis

조사한 조직들의 실무를 다섯 축으로 갈라 본다.

### Use organization `.github` inheritance as the source of truth

- 조직 6곳 중 5곳이 `<org>/.github` 정본 리포를 운영한다.
  Android만 GitHub 모델 밖이다 (`gh api repos/{google,apple,facebook,aws,microsoft}/.github/contents` 각각 성공, Android는 아래 별도 섹션).
- Microsoft `.github`는 README에서 "Default Community Health Files for the Microsoft organization"이라고 목적을 자기 선언하고 `profile/`·`policies/`·`CLA/` 디렉터리까지 조직 인프라로 확장했다 (`gh api repos/microsoft/.github/contents/README.md`, `.../contents`).
- **판단**: 조직 단위로 관리하면 정본을 한 곳에서 고치고 산하 리포는 예외일 때만 override 한다.
  override는 파일 단위이고 이슈 템플릿은 폴더 단위라 하위 리포 `.github/ISSUE_TEMPLATE/`에 파일이 하나라도 있으면 정본 폴더 전체가 무시된다(GitHub 상속 규칙, github-standard.md 참조).

### The de facto common denominator for a CoC is Contributor Covenant

- Apple·AWS·Meta·Microsoft는 Contributor Covenant 파생이다.
  Apple은 표준 문안 (`gh api repos/apple/.github/contents/CODE_OF_CONDUCT.md`), Meta는 1.4 (`gh api repos/facebook/react/contents/CODE_OF_CONDUCT.md`), AWS는 2.1 (`gh api repos/aws/.github/contents/CODE_OF_CONDUCT.md` + https://aws.github.io/code-of-conduct), Microsoft는 2.0이다.
  Microsoft는 리포 CoC 파일이 짧은 스텁이라 Covenant 언급이 없고 정책 사이트 attribution에 "adapted from the Contributor Covenant, version 2.0"으로 명시된다 (https://opensource.microsoft.com/codeofconduct/).
- Google만 예외로 기본 CoC가 자체 "Community Guidelines"이고 Contributor Covenant는 옵션으로만 제공한다 (`gh api repos/google/.github/contents/CODE_OF_CONDUCT.md`).
- 버전이 조직마다 갈린다.
  Meta는 1.4이고 AWS는 2.1을 쓴다.
  2.1은 실재하는 상위 버전이다 (https://www.contributor-covenant.org/version/2/1/).
  어느 버전이 "최신"인지는 확인하지 않았다.
- **판단**: CoC는 Contributor Covenant 채택이 사실상 표준이고 자체 브랜딩은 대규모 조직의 오버레이일 뿐 소규모엔 불필요하다.
  채택 시 **집행 연락처(이메일)를 채우는 것**이 핵심이다.
  실제 각 사가 연락처를 명시한다(Meta `opensource-conduct@fb.com` `gh api repos/facebook/react/contents/CODE_OF_CONDUCT.md`, MS `opencode@microsoft.com` https://opensource.microsoft.com/codeofconduct/, AWS `opensource-codeofconduct@amazon.com` https://aws.github.io/code-of-conduct).
  집행 의지 없는 CoC는 장식이다.

### A CLA is a trade-off, not a norm

- 갈린다.
  Google·Meta는 CLA를 요구한다 (`gh api repos/google/.github/contents/CONTRIBUTING.md`가 cla.developers.google.com 유도, `gh api repos/facebook/.github/contents/CONTRIBUTING.md`가 code.facebook.com/cla 유도).
- Apple/Swift와 AWS는 CLA 없이 대규모 프로젝트를 운영한다.
  Apple/Swift는 소스 파일 헤더로 라이선스를 명시하고 기여자 귀속은 Git이 처리한다 (`gh api repos/apple/swift/contents/CONTRIBUTING.md`에 CLA·서명 문구 부재, grep 전수 스캔).
  AWS는 CONTRIBUTING에 "기여의 라이선스를 확인하겠다"는 문구만 두고 서명 절차는 없다 (`gh api repos/aws/.github/contents/CONTRIBUTING.md`, `gh api repos/aws/aws-cli/contents/CONTRIBUTING.md` 전수 스캔으로 CLA 부재 확인).
- **판단**: CLA는 커뮤니티 건강 지표가 아니라 기업 법무 요구다.
  기여 진입장벽 비용이 있고 Apple과 AWS 두 사례가 CLA 없이도 대형 오픈소스가 성립함을 보여준다.
  경량 대안으로 DCO(Developer Certificate of Origin, `git commit -s`)가 있다.
  CLA를 기본값으로 권하지 않는다.
  법적 필요가 분명할 때만 비용을 알고 채택한다.

### SECURITY rests on "no public disclosure plus a private channel", and the channel scales with size

- 공통 원리는 공개 이슈 금지 + 사적 경로다.
  구체 채널만 규모에 따라 다르다.
    - 이메일 직결: AWS `aws-security@amazon.com` (`gh api repos/aws/.github/contents/SECURITY.md`, HackerOne https://hackerone.com/aws_vdp도 병기)
    - 전용 포털: Microsoft MSRC (`gh api repos/microsoft/.github/contents/SECURITY.md`), Google g.co/vulnz 중앙 인테이크 (`gh api repos/google/.github/contents/SECURITY.md`)
    - 버그바운티: Meta facebook.com/whitehat (`gh api repos/facebook/.github/contents/SECURITY.md`)
    - GitHub 기본 기능: Apple은 private vulnerability reporting (`gh api repos/apple/.github/contents/SECURITY.md`)
- Microsoft SECURITY.md는 버전 마커(예: `<!-- BEGIN MICROSOFT SECURITY.MD V0.0.9 BLOCK -->`)로 감싸 전 리포에 표준 블록을 자동 배포하고 응답 SLA와 CVD 원칙을 명문화한다 (`gh api repos/microsoft/.github/contents/SECURITY.md`).
- **판단**: SECURITY.md에 ① 사적 보고 경로(소규모는 GitHub private vulnerability reporting으로 충분), ② 지원 버전 표, ③ 공개 이슈 금지를 담는다.
  전용 포털·바운티는 대규모의 선택지다.

### CONTRIBUTING commonly mixes an organization template with per-repo overrides

- AWS는 `.github`에 범용 CONTRIBUTING.md를 두고 성숙한 리포는 전용판으로 override 한다 (`gh api repos/aws/.github/contents/CONTRIBUTING.md` vs `gh api repos/aws/aws-sdk-java-v2/contents/CONTRIBUTING.md`).
- Swift는 리포 CONTRIBUTING이 swift.org의 커뮤니티 문서로 위임하는 중앙화 방식이다 (`gh api repos/apple/swift/contents/CONTRIBUTING.md` + https://www.swift.org/contributing/).
- **판단**: 공통 절차는 조직 정본에 두고 빌드·테스트가 리포마다 다른 성숙한 프로젝트만 자체 CONTRIBUTING으로 확장한다.

## Android and AOSP: a case where the health file model does not apply

- AOSP는 GitHub이 아니라 Gerrit(android-review.googlesource.com) 기반이다.
  기여는 `repo`/`git` + Gerrit 리뷰 흐름이고(`repo start` → `git commit -s` → `repo upload`) GitHub PR·`.github` 정본 모델이 적용되지 않는다 (https://source.android.com/docs/setup/contribute/submit-patches).
- 승인 권한은 Google 직원만 가지고(Code-Review+2), CLA는 여기서도 필수이며 Google 공통 CLA와 같은 URL을 쓴다 (https://source.android.com/docs/setup/contribute).
- **함의**: "GitHub 커뮤니티 헬스 파일"은 GitHub 호스팅 전제의 관행이다.
  Gerrit·GitLab 등에서는 등가물(각 플랫폼의 기여 가이드·CoC 배치)로 옮겨 생각한다.

## Synthesis: judgments drawn from the observations (principles that hold at any scale)

아래는 위 검증된 관찰에서 도출한 해석이다.
독립 효과성 검증이 아니다.

1. 조직 단위면 정본 `.github`에 공통 문서를 모은다.
2. CoC는 Contributor Covenant + 집행 연락처.
3. SECURITY는 공개 금지 + 사적 경로 + 지원 버전. 소규모는 GitHub private reporting으로 충분.
4. CLA는 법적 필요가 있을 때만, 진입장벽 비용을 알고 채택한다.
   기본값이 아니다.
5. CONTRIBUTING은 공통은 정본, 리포 특수사항만 오버라이드.
