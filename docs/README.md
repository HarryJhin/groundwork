# docs

이 디렉터리는 **완료된 작업의 기록**이다.
groundwork의 현재 상태를 서술하지 않는다.

현재 상태를 알려면 루트 [README.md](../README.md)와 `skills/`를 본다.
그쪽이 정본이다.

## Why stale content stays

groundwork는 자기 방법론을 자기 개발에 적용한다.
그 방법론이 산출물의 수명을 이렇게 정한다.

- **ADR은 수락 후 불변이다.**
  결정을 번복할 때 원 ADR을 고치지 않고 새 ADR을 만들어 원 ADR을 `Superseded`로 돌린다.
  그래서 ADR-0001은 폐기된 결정을 담은 채 남아 있고 `Superseded by: ADR-0004`가 그 사실을 가리킨다.
  규범은 `skills/writing-adr/SKILL.md`에 있다.
- **설계 문서는 `status: closed`로 닫힌다.**
  실행이 끝난 시점의 결정을 그대로 보존한다.
  사후에 현재 구성에 맞춰 고치면 무엇을 정했고 무엇이 바뀌었는지가 사라진다.

불변은 **내용**에 걸리고 표기에는 걸리지 않는다.
ADR-0012가 리포 전체의 제목을 영문으로 통일하면서 수락된 ADR의 제목도 함께 바꿨다.
결정과 근거는 그대로이고 제목 문자열만 옮겼다.

## Contents by directory

| 디렉터리 | 내용 | 수명 |
|---|---|---|
| `designs/` | 설계 문서. 무엇을 왜 만들고 무엇이 되면 끝인가 | 닫힌 뒤 불변 |
| `adr/` | 아키텍처 결정 기록 | 수락 뒤 불변 |
| `artifacts/` | 프로토타입 | throwaway. 커밋하지 않는다 |

`artifacts/`만 `.gitignore` 대상이라 이 리포에는 보이지 않는다.
방향을 실물로 병치해 반응을 받는 용도이고 결정이 설계 문서에 반영되면 역할이 끝난다.

`designs/`는 아직 비어 있다.
이 리포는 자기 flow를 자기 개정에 쓰지 않기 때문이다(루트 `CONTRIBUTING.md`의 「Revising groundwork itself」).
설계 문서는 groundwork를 설치한 다른 리포에서 생긴다.

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

## Reading order

groundwork가 왜 지금 모습인지 알고 싶다면 ADR을 번호순으로 읽는 편이 빠르다.
각 ADR이 하나의 결정과 그 대가를 담는다.
`Consequences`의 `Negative`가 기재 의무라서 감수한 위험도 함께 남아 있다.

flow가 실제로 어떤 산출물을 만드는지 보려면 `skills/finding-unknowns/example-design.md`를 읽는다.
현재 규약을 그대로 따르는 설계 문서 전문 예시다.
