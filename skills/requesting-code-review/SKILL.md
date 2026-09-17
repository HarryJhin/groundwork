---
name: requesting-code-review
description: Use when 주요 기능 구현 후, 머지 전, 막혔을 때 새로운 시각이 필요할 때.
---

# requesting-code-review

## Select the review gate

입력은 완료된 변경과 요구사항이다. 조율자가 리뷰어를 격리해 검토하고 발견·판정·처리 결과를 반환한다. 설계 문서 실행 중에는 `groundwork:executing-design`의 태스크·재리뷰·최종 리뷰 게이트를 따른다. 설계 문서 점검은 `groundwork:design-review` 소관이다.
실행 게이트 밖에서는 주요 기능 완료 후와 main 머지 전에 리뷰한다. 막혔을 때나 복잡한 버그 수정·리팩터링에서는 필요에 따라 요청한다.

## Send the review scope

리뷰 시작점은 작업 시작 커밋이며 모르면 기본 브랜치와의 분기점을 쓴다. `HEAD~1`을 기본값으로 쓰지 않는다.
아래 블록은 대상 리포 루트에서 실행하고 기본 브랜치 이름을 실제 값으로 치환한다.

```bash
BASE_SHA=$(git merge-base main HEAD)
HEAD_SHA=$(git rev-parse HEAD)
DIFF_FILE=$(mktemp -t review-diff)
git diff "$BASE_SHA" "$HEAD_SHA" > "$DIFF_FILE"
echo "$DIFF_FILE"
```

[code-reviewer-prompt.md](code-reviewer-prompt.md)에 변경 요약·요구 또는 설계 경로·시작과 끝 커밋·diff 파일 경로를 채워 리뷰어에게 준다. 링크는 이 스킬 디렉터리 기준이다.
세션 전체와 diff 본문을 디스패치 메시지에 복사하지 않는다. 모델과 컨텍스트 전달 방식은 실행 환경의 도구 안내를 따른다.

Critical은 즉시, Important는 진행 전에 해결하고 Minor는 보류 근거를 기록한다. 발견의 기술적 검증과 반박은 `groundwork:receiving-code-review`를 따른다.
