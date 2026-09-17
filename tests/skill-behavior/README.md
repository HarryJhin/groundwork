# Skill behavior probes

Groundwork 지침의 도메인 질문·기술 선택·정책 재검토와 코드 주석 정책 적용을 확인한다.

## Run the probes

Python 표준 라이브러리와 인증된 Claude Code CLI를 쓴다. 한 호출마다 새 대화로 첫 응답과 다음 행동을 생성하며 실제 구현 도구는 비활성화한다. `--response-mode artifact`는 코드 수정본·리뷰를 응답에 직접 생성한다. 케이스의 선택적 `instructions`는 스킬 본문보다 앞의 시스템 지침으로 넣는다. 기본값은 케이스당 5회, 동시 호출 3개다. 모델 호출 비용이 발생한다.

```bash
python3 tests/skill-behavior/evaluate.py --variant none --cases ambiguous
python3 tests/skill-behavior/evaluate.py --variant design --cases explicit,interview-revision
python3 tests/skill-behavior/evaluate.py --variant execution --cases review-conflict,review-domain,review-impact
python3 tests/skill-behavior/evaluate.py --variant subagent --cases review-impact
```

기존 지침과 같은 케이스를 비교하려면 `--revision`을 쓴다.

```bash
python3 tests/skill-behavior/evaluate.py --variant handoff --cases handoff-directed --revision 57b0938
python3 tests/skill-behavior/evaluate.py --variant handoff --cases handoff-directed
```

출력 경로를 지정하려면 `--out`을 쓴다. 그곳에 프롬프트·케이스·해시·CLI 버전, 응답 JSON과 stderr, 실행 상태·모델 사용량을 저장한다. `summary.json`의 성공은 호출 성공이며 행동 통과를 뜻하지 않는다. 각 응답을 [케이스의 기대 행동](cases.json)과 대조해 직접 판독한다.

## Observed behavior

2026-09-16에 Claude Code 2.1.273으로 실행했다. 응답 모델은 CLI가 보고한 `claude-opus-5[1m]`이고 보조 호출에 `claude-haiku-4-5-20251001`이 기록됐다. 반복마다 대화는 새로 시작했으며 모델 기본값과 캐시는 CLI 설정을 따랐다.

| 시나리오 | 판독 결과 |
|---|---|
| 지침 없는 공유 삭제 대조군 5개 | 5개 모두 경위·선택별 동작·영향을 설명했다. 1개는 답이 없으면 추천 정책을 기본값으로 구현하겠다고 했다. |
| 기존 지침의 명확한 요청 5개 | 4개는 바로 구현한다. 1개는 의미 재확인·조사 3종·별도 설계 승인을 예고했다. |
| 새 지침의 명확한 요청 5개 | 형식적 정책 확인과 별도 승인을 요구하지 않고 구현·검증으로 진행했다. |
| 인터뷰에서 공동 정리 목적이 새로 드러남 5개 | 기존 개인 숨김 승인을 재검토하고 경위·선택별 동작·대가를 설명한 뒤 답을 기다렸다. |
| 구현 편의만 있는 정책 변경 리뷰 5개 | 변경 제안을 기각했다. 사용자에게 형식적으로 다시 고르게 하지 않았다. |
| 리뷰에서 외부 협력자 영향 발견 5개 | 이전 인터뷰의 전제와 새 영향의 차이를 설명하고 정책 변경 여부를 물었다. |
| 같은 새 영향을 서브에이전트 경로로 처리 5개 | 컨트롤러도 정책 재검토를 요청했다. 답 전에 새 정책을 확정하지 않았다. |
| 동일 서비스 계약의 기술 충돌, 메인·서브에이전트 각 5개 | 기술 선택을 자율 해결하고 문서·검증·범위 한정 재리뷰를 계획했다. |
| 승인된 PR 마무리, 기존·새 지침 각 5개 | 양쪽 모두 통합을 다시 묻거나 동일 트리 검증을 반복하거나 외부 워크트리를 삭제하지 않았다. 행동 개선을 입증한 사례는 아니다. |

첫 설계 축약본에서는 충돌 우선순위 기준을 기술 선택으로 넘기거나 미제공 복구·구현 시간을 단정하는 응답이 있었다. 경계 보완 후 공유 삭제·오프라인 충돌 각 5개에서는 해당 단정이 없고 필요한 정책을 설명해 물었다.

대조군도 설명을 대부분 수행했다. 이 결과는 장문의 방법론이 있어야 질문할 수 있다는 주장을 뒷받침하지 않는다. 개입이 필요한 경계와 실제 실패만 지침에 남긴다.

실행 상태·프롬프트 해시와 대표 응답은 [관측 기록](observations.json)에 있다. 초기 비교는 같은 CLI 방식의 선행 러너를 사용해 현재 fixture와 문구가 일부 다르다. 정책 재검토와 마무리 비교는 이 리포의 러너로 실행했다. 마지막 중복 문장 삭제와 종료 정리의 소유권 보완은 정적 리뷰로 확인했다.

## No-op removal probes

2026-09-17에는 기초 설명·중복 지시를 제거한 스킬의 핵심 행동을 지침 없는 대조군, 수정 전(`2212d7a`), 수정 후로 비교했다. [시나리오](noop-cases.json)의 각 조건은 새 컨텍스트에서 1회씩 실행했고 원시 응답을 직접 판독했다. 15개 호출은 모두 성공했고 각 시나리오의 핵심 기대 행동도 수행했다. 단일 표본이므로 반복 안정성이나 전체 작업 품질을 입증하지 않는다.

| 스킬 파일 | 시나리오 | 확인한 행동 |
|---|---|---|
| `skills/test-driven-development/SKILL.md` | `test-first` | 실패 테스트 후 최소 수정과 검증 |
| `skills/systematic-debugging/SKILL.md` | `debug-pressure` | 타임아웃 증가 전에 원인 확인 |
| `skills/receiving-code-review/SKILL.md` | `review-feedback` | 입력 계약을 깨는 봇 제안 반박 |
| `skills/dispatching-parallel-agents/SKILL.md` | `parallel-boundary` | 같은 픽스처의 실패를 묶고 독립 영역만 분리 |
| `skills/writing-skills/SKILL.md` | `minimal-authoring` | 가상 금지 목록 대신 관측에 맞는 출력 계약 |

아래는 첫 행의 재현 커맨드다. 다른 행은 `--prompt-file`과 `--cases`를 해당 값으로 바꾼다. 대조군은 `--prompt-file` 없이 실행한다.

```bash
python3 tests/skill-behavior/evaluate.py --variant none --cases-file tests/skill-behavior/noop-cases.json --cases test-first --repeat 1
python3 tests/skill-behavior/evaluate.py --variant none --prompt-file skills/test-driven-development/SKILL.md --cases-file tests/skill-behavior/noop-cases.json --cases test-first --repeat 1 --revision 2212d7a
python3 tests/skill-behavior/evaluate.py --variant none --prompt-file skills/test-driven-development/SKILL.md --cases-file tests/skill-behavior/noop-cases.json --cases test-first --repeat 1
```

수정 전 병렬 조사 응답은 모델 티어 문서를 먼저 조회한다고 했다. 수정 후에는 그 조회 없이 같은 원인의 실패를 묶고 독립 영역을 분리했다. 대조군도 핵심 행동을 수행했으므로 이 표본은 장문의 기초 설명이 필요한 근거가 되지 않는다.
초기 수정 후 디버깅 응답은 제목에서 원인 확인 전에 해법을 제시했다. 기존의 원인 확인 후 수정 제안 게이트를 명시해 한 번 더 확인했고, 최종 응답은 가설 확인부터 계획했다.
독립 판독 검토에서 발견한 오래된 근거 앵커와 축 식별자를 고쳤고 재검토는 PASS였다.

변경된 스킬 본문 합계는 111,786 → 27,130 UTF-8 bytes로 약 76% 줄었다. 이는 같은 파일 집합의 크기이며 실제 세션 로드량이나 모델 토큰 수가 아니다. 반복 참조 자료와 모델 티어 문서를 포함한 변경 Markdown 합계는 339,587 → 57,096 bytes다.
프롬프트·시나리오 해시, 모델 사용량, 원시 응답과 판독, 파일별 크기는 [관측 기록](noop-observations.json)에 있다.

## Code comment probes

2026-09-17에 Claude Code 2.1.274로 [주석 시나리오](comment-cases.json)를 실행했다. 프로젝트 정책은 세션 시작 지침으로 넣고, 작업 요청에는 코드와 수정 범위만 제시했다. 실제 리포에서 관측한 타입·동작 해설, 모호한 기술 서술, 함수 추출 뒤 주석 불일치와 사용자가 지적한 TODO·FIXME 미사용을 검사 대상으로 삼았다.

| 조건 | 직접 판독한 결과 |
|---|---|
| 수정 전 구현 5개 | 모두 무관한 연결 설명을 남겼다. 1개는 코드 흐름 설명도 남겼다. 불일치를 인식하면서 범위 밖이나 다음 태스크로 미루는 응답이 있었다. |
| 수정 후 구현 5개 | 모두 두 설명을 제거했다. 새 함수에 해설 주석을 추가하지 않았고 기존 동작과 외부 과금 제약을 보존했다. |
| 기존 리뷰 지침 5개 | 모두 타입 해설·주석 불일치·무관한 설명·TODO 누락·FIXME 누락을 지적하고 외부 계약 주석을 보존했다. 추가 리뷰 문구는 유지하지 않았다. |

TODO·FIXME 구분은 수정 전후 모두 수행했다. 그 축의 개선을 입증한 결과는 아니다. 새 문구는 수정한 코드의 기존 주석까지 완료 전에 대조하고, 불일치를 이번 변경에서 정리하는 실패를 겨냥한다. 문서 규범이 코드 해설 추가나 기술 용어를 모호한 일상어로 바꾸는 근거가 되지 않도록 적용 범위도 명시했다. 독립 판독 검토는 PASS였다.

리포 루트에서 아래 세 커맨드로 비교를 재현한다. 각 커맨드의 결과는 별도 임시 디렉터리에 저장된다.

```bash
python3 tests/skill-behavior/evaluate.py --variant none --prompt-file skills/using-groundwork/SKILL.md --prompt-file skills/writing-for-junior/SKILL.md --revision 6a5282b --cases-file tests/skill-behavior/comment-cases.json --cases comment-implementation --response-mode artifact --repeat 5
python3 tests/skill-behavior/evaluate.py --variant none --prompt-file skills/using-groundwork/SKILL.md --prompt-file skills/writing-for-junior/SKILL.md --cases-file tests/skill-behavior/comment-cases.json --cases comment-implementation --response-mode artifact --repeat 5
python3 tests/skill-behavior/evaluate.py --variant none --prompt-file skills/requesting-code-review/code-reviewer-prompt.md --cases-file tests/skill-behavior/comment-cases.json --cases comment-review --response-mode artifact --repeat 5
```

[관측 기록](comment-observations.json)에 15개 원시 응답·전체 지침·시나리오·해시·모델 사용량·판독과 리포 증거를 남겼다. 실제 SessionStart 주입은 1,588 → 2,735 UTF-8 bytes다. 토큰 수가 아니며 참조 파일의 추가 상시 로드는 없다.
각 호출은 새 컨텍스트에서 수행했다. 실제 긴 대화의 지침 망각을 재현하거나 방지했다고 주장하지 않는다. 생성된 TypeScript의 실행·타입 검증도 이 비교 범위 밖이다.

## Context size

[크기 기록](size-metrics.json)은 `57b0938`과 `v0.13.0` (`a3fd10f`) 파일의 UTF-8 바이트·행을 비교한다.

| 로드 대상 | 기존 | 변경 |
|---|---:|---:|
| 실제 SessionStart 추가 컨텍스트 | 7,949 bytes | 1,588 bytes |
| 코어 5개 스킬 본문 합계 | 114,334 bytes | 22,369 bytes |

상시 주입은 약 80% 줄었다. 본문 합계는 같은 파일 집합의 크기이며 세션에서 모두 읽는다는 뜻이 아니다. 참조 파일을 매번 읽도록 바꿔 절감을 부풀리지 않았다.

마무리 비교의 주 모델 사용량은 호출당 로드된 입력 토큰 평균 16,595 → 4,229, 출력 토큰 평균 1,773.4 → 1,242.6이었다. 입력은 일반 입력·캐시 읽기·캐시 생성 토큰의 합이다. 사고 토큰과 CLI 환경이 포함돼 있어 순수 사용자 설명 길이나 전체 개발 비용으로 해석할 수 없다.

## Limits

이 검사는 도구 없는 첫 응답·행동 계획 또는 응답에 생성한 코드·리뷰를 확인한다. 실제 다중 턴 인터뷰·코딩·리뷰·통합의 품질이나 전체 시간·토큰 이득을 입증하지 않는다. 시작 시 컨텍스트의 10%를 쓴다는 관측도 동일 모델·세션 조건에서 재측정한 것은 아니다.
