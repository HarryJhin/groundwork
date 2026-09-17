---
name: receiving-code-review
description: Use when 리뷰 피드백 수령, 리뷰 지적 반영 직전, 피드백이 불명확하거나 기술적으로 의심스러울 때.
---

# receiving-code-review

## Resolve the feedback

입력은 받은 리뷰 피드백이다. 구현자가 사용자 지시는 이해 후 반영하고, 봇·서브에이전트·PR 리뷰 등 외부 피드백은 코드·테스트·기존 계약과 대조해 수용하거나 근거로 반박한다. 출처가 불명확하면 외부 피드백으로 다룬다.
불명확한 항목이 있으면 먼저 해소한다. 실제 사용처와 필요한 계약을 확인하고, 쓰이지 않는 기능을 리뷰를 만족시키려고 추가하지 않는다.
사용자의 앞선 결정과 충돌하는 제안은 임의 반영하지 않는다. 정책 재검토에 새 근거가 있으면 `groundwork:finding-unknowns`로 영향과 선택을 설명한다.

차단 문제부터 수정하고 변경에 맞는 검증을 실행한다. 형식적 동의·감사·긴 사과 대신 변경 내용과 기술 근거로 답한다.
출력은 반영한 변경·검증 결과와 항목별 수용·반박 근거다. 해소되지 않은 판단은 근거와 함께 사용자에게 보고한다. 수정 후 재리뷰는 호출한 실행 스킬의 게이트를 따른다.

## Reply in the review thread

GitHub 인라인 코멘트에 답하는 작업이 요청됐으면 해당 스레드에 답한다. 아래 블록은 대상 리포 루트에서 실행하고 `OWNER`, `REPO`, `PR`은 대상 소유자·이름·PR 번호, `COMMENT_ID`는 조회한 코멘트 ID로 치환한다.

```bash
gh api "repos/OWNER/REPO/pulls/PR/comments" --jq '.[] | "\(.id)\t\(.path):\(.line)\t\(.body[0:60])"'
gh api --method POST "repos/OWNER/REPO/pulls/PR/comments/COMMENT_ID/replies" -f body='<답글 본문>'
```
