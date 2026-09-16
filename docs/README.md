# docs

이 디렉터리는 **완료된 작업의 기록**이다.  
groundwork의 현재 상태를 서술하지 않는다.

현재 상태를 알려면 루트 [README.md](../README.md)와 `skills/`를 본다.  
그쪽이 정본이다.

## Why stale content stays

groundwork를 사용하는 작업 리포에서 설계 산출물은 다음 수명을 갖는다.

- **설계 문서는 닫히지 않는다.**  
  구현이 설계를 벗어나면 실행 중에 그 문서를 고치고(`skills/executing-design/SKILL.md`의 「Revise the design document」), 나중에 설계가 바뀌어도 같은 문서를 고친다.  
  frontmatter의 `updated`가 마지막으로 손댄 날을 담는다.  
  종료 표기는 없다.  
  무엇이 언제 바뀌었는지는 git 히스토리가 담고 문서 본문은 지금 무엇이 규범인지만 담는다.

## The ADR convention is retired

`adr/`는 동결된 이력이다.  
새 파일을 만들지 않고 이 리포는 더 이상 결정을 별도 문서로 모으지 않는다.

ADR-0008과 ADR-0010이 각각 자기 `Consequences`에 같은 대가를 적었다.  
앞 결정을 고치지 않고 새 문서로 덮으므로 현재 구조를 알려면 여러 문서를 함께 읽어야 한다는 것이다.

지금 규범은 다음과 같다.  
결정은 그것을 쓰는 설계 문서 안에 있고 그 문서를 제자리에서 고친다.  
현재 규범의 정본은 `skills/`와 루트 [README.md](../README.md)다.

`adr/`는 이전 결정의 근거와 대가를 찾아볼 수 있도록 동결된 이력으로 남긴다. 현재 규약의 설명이나 자동 로드 자료로 쓰지 않는다.

## Contents by directory

| 디렉터리     | 내용                                           | 수명                          |
|--------------|------------------------------------------------|-------------------------------|
| `designs/`   | 설계 문서. 무엇을 왜 만들고 무엇이 되면 끝인가 | 계속 갱신된다                 |
| `adr/`       | 폐기된 결정 기록 관행의 이력                   | 동결. 새 파일을 만들지 않는다 |
| `artifacts/` | 프로토타입                                     | throwaway. 커밋하지 않는다    |

`artifacts/`만 `.gitignore` 대상이라 이 리포에는 보이지 않는다.  
방향을 실물로 병치해 반응을 받는 용도이고 결정이 설계 문서에 반영되면 역할이 끝난다.

이 리포는 자기 flow를 자기 개정에 쓰지 않으므로 (루트 `CONTRIBUTING.md`의 「Revise groundwork itself」) 설계 문서는 groundwork를 설치한 다른 리포에서 생긴다.

## Deleted archives

`docs/specs/`와 `docs/plans/`가 있었고 각각 파일 하나를 담고 있었다.  
`SPEC-0001-spec-pipeline.md`와 `PLAN-0001-spec-pipeline.md`다.

둘 다 ADR-0012가 지웠다.  
두 산출물 종류는 이미 폐기된 것이고(플랜은 ADR-0008이, 스펙이라는 이름은 ADR-0010이 닫았다) 남은 파일은 지금의 flow와 대응하지 않는 형식을 서술했다.  
읽는 사람이 현재 규약으로 오독할 위험이 보존 가치보다 컸다.

그 내용이 필요하면 git 히스토리에서 꺼낸다.

```bash
git log --diff-filter=D --name-only -- docs/specs docs/plans
git show <삭제 직전 커밋>:docs/specs/SPEC-0001-spec-pipeline.md
```


groundwork가 왜 지금 모습이 됐는지가 궁금하면 `adr/`를 번호순으로 읽는다.  
동결된 이력이라 현재 규범과 어긋나는 대목이 있고 어긋나면 스킬이 맞다.

flow가 실제로 어떤 산출물을 만드는지 보려면 `skills/finding-unknowns/example-design.md`를 읽는다.  
현재 규약을 그대로 따르는 설계 문서 전문 예시다.
