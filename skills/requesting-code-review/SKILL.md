---
name: requesting-code-review
description: 코드 리뷰어 서브에이전트를 디스패치해 완료된 작업을 요구·품질 기준으로 검증한다. Use when 태스크 완료 직후, 주요 기능 구현 후, 머지 전, 막혔을 때 새로운 시각이 필요할 때.
---

# requesting-code-review

코드 리뷰어 서브에이전트를 디스패치해 문제가 하류로 번지기 전에 잡는다.  
리뷰어는 정밀하게 구성한 컨텍스트만 받는다.  
세션 히스토리는 주지 않는다.

**주체**: 이 스킬을 실행하는 것은 방금 작업을 마친 조율자다.  
리뷰어는 조율자가 디스패치하는 별개 서브에이전트이고 아래에서 "조율자 컨텍스트"는 이 스킬을 실행하는 쪽의 컨텍스트를 가리킨다.

**핵심 원칙**: 일찍 리뷰하고 자주 리뷰한다.

이 스킬은 코드 리뷰를 다룬다.  
문서 리뷰는 `groundwork:design-review` 소관이다.

## Where this skill does not apply

**설계 문서를 실행하는 중이면 이 스킬의 절차를 쓰지 않는다.**  
`groundwork:executing-design`과 `groundwork:subagent-driven-development`가 자기 리뷰 게이트를 직접 정의하고 있고 그것이 그 자리의 정본이다.

| 자리                    | 정본                                                      | 프롬프트                            | diff                     |
|-------------------------|-----------------------------------------------------------|-------------------------------------|--------------------------|
| 태스크 하나를 마친 뒤   | 실행 스킬의 「Apply the review gate」·「Review the task」 | `task-reviewer-prompt.md`           | `scripts/review-package` |
| fix 라운드의 재리뷰     | 실행 스킬의 「Fix loop」                                  | `re-review-prompt.md`               | `scripts/review-package` |
| 브랜치 전체 (최종 리뷰) | 실행 스킬의 「Final review」                              | 이 스킬의 `code-reviewer-prompt.md` | `scripts/review-package` |

최종 리뷰만 이 스킬의 프롬프트를 쓰고 그때도 diff는 실행 스킬이 `review-package`로 만들어 넘긴다.  
아래 「How to request」의 셸 절차를 그 자리에 쓰지 않는다.

이유는 `BASE`다.  
아래 절차의 기본값 후보인 `HEAD~1`은 커밋이 여럿인 태스크에서 마지막 하나만 남기고 나머지를 조용히 버린다.  
TDD 루프가 태스크당 여러 커밋을 만드는 것이 기본이라 그 자리에서는 태스크 diff의 대부분이 리뷰되지 않는다.  
실행 스킬은 태스크 시작 시점에 `BASE`를 기록해 두고 그 값을 쓴다.

## When to review

이 스킬은 설계 문서 실행 **밖**의 리뷰를 다룬다.

**필수**:
- 주요 기능 완료 후
- main 머지 전

**선택이지만 유용**:
- 막혔을 때(새로운 시각)
- 리팩터링 전(베이스라인 점검)
- 복잡한 버그 수정 후

## How to request

**1. git SHA를 얻는다**

`BASE_SHA`는 **리뷰하려는 작업이 시작된 커밋**이다.  
그 값을 알고 있으면 그것을 쓰고, 모르면 브랜치가 갈라져 나온 지점(`git merge-base main HEAD`)을 쓴다.

```bash
BASE_SHA=$(git merge-base main HEAD)   # 기본 브랜치 이름이 다르면 그 이름을 쓴다
HEAD_SHA=$(git rev-parse HEAD)
DIFF_FILE=$(mktemp -t review-diff)
git diff "$BASE_SHA" "$HEAD_SHA" > "$DIFF_FILE"
echo "$DIFF_FILE"
```

**`HEAD~1`을 기본값으로 쓰지 않는다.**  
커밋이 여럿인 작업에서 마지막 하나만 남기고 나머지를 버리는데, 버려졌다는 신호가 리뷰어 쪽에 나타나지 않는다.  
리뷰가 통과해도 그것은 마지막 커밋만 통과한 것이다.

값 3개를 같은 셸에서 잡는다.  
아래 자리표시자에 그 값을 그대로 넣는다.

**2. 코드 리뷰어를 디스패치한다**

`general-purpose` 서브에이전트에 [code-reviewer-prompt.md](code-reviewer-prompt.md) 전문을 주입하고 자리표시자를 채운다.

- `[DESCRIPTION]`: 무엇을 만들었는지 짧은 요약
- `[DESIGN_OR_REQUIREMENTS]`: 무엇을 해야 하는지(설계 문서 경로·태스크 브리프 텍스트·요구)
- `[BASE_SHA]`: 시작 커밋
- `[HEAD_SHA]`: 종료 커밋
- `[DIFF_FILE]`: 위에서 만든 diff 파일 경로. diff를 파일로 넘기면 조율자 컨텍스트에 diff가 들어오지 않는다

**리뷰어의 모델을 명시해 띄운다.**  
티어는 diff의 크기·복잡도·위험에 맞추고 배정 기준은 `${CLAUDE_PLUGIN_ROOT}/skills/using-groundwork/choosing-model-tier.md`의 「Dispatch axis: code review tasks」에 있다(`${CLAUDE_PLUGIN_ROOT}`는 groundwork 플러그인이 설치된 디렉터리이고 실행 시점 작업 디렉터리가 아니다).  
모델을 빠뜨리면 세션 모델을 상속한다.

**3. 피드백에 대응한다**

- Critical은 즉시 고친다
- Important는 진행 전에 고친다
- Minor는 기록해 두고 나중에 처리한다
- 리뷰어가 틀렸으면 근거를 들어 반박한다

받은 피드백을 처리하는 규율은 `groundwork:receiving-code-review`가 정본이다.

## Common rationalizations

| 변명                                           | 실제                                                                                                                                                            |
|------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| "리뷰어를 띄우느니 내가 diff를 보겠다"         | 너는 조율자다. diff를 인라인으로 읽으면 작업을 계속 끌고 갈 컨텍스트 창을 소모한다. 리뷰어를 디스패치하면 diff와 평가가 그쪽 컨텍스트에 머물고 발견만 돌아온다. |
| "리뷰어가 이해하려면 세션 히스토리가 필요하다" | 정밀하게 구성한 컨텍스트를 준다. 세션 히스토리는 주지 않는다. 그래야 리뷰어가 네 사고 과정이 아니라 결과물에 집중한다.                                          |
| "태스크를 끝냈으니 이 스킬의 절차로 리뷰한다"  | 그 자리의 정본은 실행 스킬이다. 위 「Where this skill does not apply」를 본다. 프롬프트도 `BASE` 구하는 법도 다르다.                                            |
| "`HEAD~1`이면 방금 한 작업이다"                | 커밋이 여럿이면 마지막 하나만 남는다. 버려진 커밋은 리뷰어 쪽에 흔적을 남기지 않아 통과가 통과처럼 보인다.                                                      |

## Red flags

**하지 않는다**:
- "간단하니까" 리뷰를 건너뛴다
- Critical 이슈를 무시한다
- Important를 안 고친 채 진행한다
- 타당한 기술적 피드백과 말싸움한다

**리뷰어가 틀렸으면**: 기술적 근거로 반박한다.  
작동을 증명하는 코드·테스트를 보인다.  
설명을 요청한다.
