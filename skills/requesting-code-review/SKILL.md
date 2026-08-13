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
스펙 문서 리뷰는 `groundwork:spec-review`, 플랜 문서 리뷰는 `groundwork:plan-review` 소관이다.

## 리뷰 시점

**필수**:
- `groundwork:subagent-driven-development`로 플랜을 실행할 때 각 태스크 후
- 주요 기능 완료 후
- main 머지 전

**선택이지만 유용**:
- 막혔을 때(새로운 시각)
- 리팩터링 전(베이스라인 점검)
- 복잡한 버그 수정 후

## 요청 방법

**1. git SHA를 얻는다**

```bash
BASE_SHA=$(git rev-parse HEAD~1)  # 또는 origin/main
HEAD_SHA=$(git rev-parse HEAD)
DIFF_FILE=$(mktemp -t review-diff)
git diff "$BASE_SHA" "$HEAD_SHA" > "$DIFF_FILE"
echo "$DIFF_FILE"
```

값 3개를 같은 셸에서 잡는다.
아래 자리표시자에 그 값을 그대로 넣는다.

**2. 코드 리뷰어를 디스패치한다**

`general-purpose` 서브에이전트에 [code-reviewer-prompt.md](code-reviewer-prompt.md) 전문을 주입하고 자리표시자를 채운다.

- `[DESCRIPTION]`: 무엇을 만들었는지 짧은 요약
- `[PLAN_OR_REQUIREMENTS]`: 무엇을 해야 하는지(플랜 경로·태스크 텍스트·요구)
- `[BASE_SHA]`: 시작 커밋
- `[HEAD_SHA]`: 종료 커밋
- `[DIFF_FILE]`: 위에서 만든 diff 파일 경로. diff를 파일로 넘기면 조율자 컨텍스트에 diff가 들어오지 않는다

**리뷰어의 모델을 명시해 띄운다.**
티어는 diff의 크기·복잡도·위험에 맞추고 배정 기준은 `${CLAUDE_PLUGIN_ROOT}/skills/subagent-driven-development/choosing-model-tier.md`의 「코드 리뷰 태스크」에 있다(`${CLAUDE_PLUGIN_ROOT}`는 groundwork 플러그인이 설치된 디렉터리이고 실행 시점 작업 디렉터리가 아니다).
모델을 빠뜨리면 세션 모델을 상속한다.

**3. 피드백에 대응한다**

- Critical은 즉시 고친다
- Important는 진행 전에 고친다
- Minor는 기록해 두고 나중에 처리한다
- 리뷰어가 틀렸으면 근거를 들어 반박한다

받은 피드백을 처리하는 규율은 `groundwork:receiving-code-review`가 정본이다.

## 흔한 합리화

| 변명 | 실제 |
|---|---|
| "리뷰어를 띄우느니 내가 diff를 보겠다" | 너는 조율자다. diff를 인라인으로 읽으면 작업을 계속 끌고 갈 컨텍스트 창을 소모한다. 리뷰어를 디스패치하면 diff와 평가가 그쪽 컨텍스트에 머물고 발견만 돌아온다. |
| "리뷰어가 이해하려면 세션 히스토리가 필요하다" | 정밀하게 구성한 컨텍스트를 준다. 세션 히스토리는 주지 않는다. 그래야 리뷰어가 네 사고 과정이 아니라 결과물에 집중한다. |

## Red Flags

**하지 않는다**:
- "간단하니까" 리뷰를 건너뛴다
- Critical 이슈를 무시한다
- Important를 안 고친 채 진행한다
- 타당한 기술적 피드백과 말싸움한다

**리뷰어가 틀렸으면**: 기술적 근거로 반박한다.
작동을 증명하는 코드·테스트를 보인다.
설명을 요청한다.
