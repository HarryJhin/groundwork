# README standard and structure

README의 GitHub 인식 규칙과 내용 구조 레퍼런스.  
README를 새로 만들거나 기존 README가 무엇을 빠뜨렸는지 판정할 때 이 문서를 근거로 삼는다.

README는 community profile 채점 항목에 들어가지만 조직 `.github` 상속 대상은 아니다.  
LICENSE와 같이 리포마다 자체 보유한다.

## Rules and limits of this document

- 「GitHub-enforced README behavior」와 「Profile README is a separate feature」는 GitHub 공식 문서 사실이고 각 절 머리의 출처 URL이 검증 경로다.
- 「Observed section composition」은 제3자 실측 연구다.  
  이 스킬의 다른 레퍼런스와 달리 벤더 자사 출처가 아니다.
- 「Recommended structure」는 그 실측에서 끌어낸 해석이다.  
  독립 효과성 검증이 아니다.

## GitHub-enforced README behavior

출처: [^about-readmes]  
마크다운 문법: [^basic-writing-and-formatting-syntax]

- 인식 위치는 `.github/`·루트·`docs/` 셋이다.  
  여러 곳에 있으면 `.github` → 루트 → `docs` 순으로 첫 매칭을 쓴다.  
  헬스 파일과 같은 우선순위다.
- 렌더 뷰에서 500 KiB를 넘는 내용은 잘린다 ("any content beyond 500 KiB will be truncated").
- 제목에서 목차가 자동 생성되고 제목마다 앵커가 붙는다.
- 앵커는 대문자를 소문자로 바꾸고 공백을 하이픈으로 바꾸고 나머지 공백·구두점을 없애서 만든다.  
  제목을 고치거나 이름이 같은 제목들의 순서를 바꾸면 앵커가 달라지므로 그 앵커를 가리키는 링크를 함께 고친다.
- 상대 링크는 현재 브랜치 기준으로 자동 변환된다.  
  `/`로 시작하면 리포 루트 기준이다.  
  clone 한 사용자에게도 동작하므로 절대 링크 대신 상대 링크를 쓴다.
- 링크 텍스트가 두 줄에 걸치면 링크로 동작하지 않는다.
- 조직 `.github` 상속 지원 목록에 README가 없다.  
  리포마다 자체 보유한다.

## Profile README is a separate feature

출처: [^managing-your-profile-readme]  
조직 프로필: [^customizing-your-organizations-profile]

프로필 README는 프로필 페이지에 표시되는 문서이지 산하 리포로 상속되는 README가 아니다.  
헬스 파일 정본과 같은 `.github` 리포를 쓰기 때문에 상속으로 오해하기 쉽다.

| 대상             | 위치                                         |
|------------------|----------------------------------------------|
| 개인 프로필      | username과 같은 이름의 public 리포 루트      |
| 조직 공개 프로필 | public `.github` 리포의 `profile/README.md`  |
| 조직 멤버 뷰     | `.github-private` 리포의 `profile/README.md` |

## Observed section composition

출처: Prana 외, "Categorizing the Content of GitHub README Files", Empirical Software Engineering 24 (2019).  
[^s10664-018-9660-3] (프리프린트 [^s-1802-06997])

무작위 표집한 리포 393개의 README 섹션 4,226개를 수동 분류한 결과다.  
아래는 각 범주가 등장한 파일의 비율이다.

| 범주         | 답하는 물음                | 해당 파일 비율 |
|--------------|----------------------------|----------------|
| What         | 이게 무엇인가              | 97.0%          |
| How          | 어떻게 쓰는가              | 88.5%          |
| References   | 관련 문서·링크는 무엇인가  | 60.8%          |
| Who          | 누가 만들고 유지하는가     | 52.9%          |
| Contribution | 어떻게 기여하는가          | 27.8%          |
| Why          | 왜 이걸 쓰는가             | 25.7%          |
| When         | 지금 어떤 상태인가         | 21.4%          |
| Other        | 위 어디에도 안 들어감      | 6.9%           |

연구의 결론은 What과 How는 거의 모두 쓰는 반면 목적 (Why) 과 상태 (When) 는 네 곳 중 세 곳이 빠뜨린다는 것이다.

## Recommended structure

위 실측을 규칙으로 바꾸면 이렇다.  
Contribution·Who·References는 CONTRIBUTING·CODEOWNERS·LICENSE가 이미 담당하므로 README는 링크만 둔다.  
Why와 When은 어느 헬스 파일도 담당하지 않아 README에서만 답할 수 있다.  
그래서 README 작성의 실제 과제는 What과 How를 늘리는 것이 아니라 Why와 When을 채우는 것이다.

권장 배치 순서는 다음과 같다.

1. H1 제목과 한 문단 요약 (What)
1. 왜 이 선택인가, 기존 대안과 무엇이 다른가 (Why)
1. 상태와 지원 범위 (When)
1. 설치부터 첫 성공까지 (How)
1. 헬스 파일 링크 (Contribution·Who·References)

### Fill in the purpose and status

Before:

```markdown
# groundwork

코딩 에이전트용 플러그인.

## 설치
```

What만 있고 그것도 분류로만 답한다.  
읽는 사람은 이걸 왜 쓰는지, 지금 써도 되는지 알 수 없다.

After:

```markdown
# groundwork

코딩 에이전트가 코드를 쓰기 전에 설계 문서를 만들고 리뷰를 통과하게 강제하는 플러그인.

에이전트는 애매한 요청을 임의로 해석해 구현하고, 테스트가 통과하면 방향이 맞다고 판단한다.
groundwork는 그 두 실패를 설계 승인 게이트 하나로 막는다.

**상태**: 0.7.0. 스킬 인터페이스는 아직 바뀔 수 있다. Claude Code에서만 검증했다.

## 설치
```

## Checklist

- [ ] 첫 문단만 읽고 이 프로젝트가 무엇인지 말할 수 있는가
- [ ] 기존 대안 대신 이것을 고를 이유가 문서 안에 있는가
- [ ] 지금 쓸 수 있는 상태인지 (실험·안정·보관) 가 적혀 있는가
- [ ] 설치부터 첫 성공까지의 명령을 복사해 그대로 실행할 수 있는가
- [ ] CONTRIBUTING·LICENSE·SECURITY로 가는 링크가 있는가
- [ ] 리포 안을 가리키는 링크가 상대 경로인가
- [ ] 렌더 크기가 500 KiB 미만인가

[^about-readmes]: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes
[^basic-writing-and-formatting-syntax]: https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax
[^customizing-your-organizations-profile]: https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/customizing-your-organizations-profile
[^managing-your-profile-readme]: https://docs.github.com/en/account-and-profile/how-tos/profile-customization/managing-your-profile-readme
[^s-1802-06997]: https://arxiv.org/abs/1802.06997
[^s10664-018-9660-3]: https://doi.org/10.1007/s10664-018-9660-3
