# groundwork

코딩 에이전트용 개발방법론 플러그인. 도메인 결정을 사용자와 확정하고 필요한 설계·구현·검증을 이어간다.

## The problem groundwork solves

에이전트는 리포의 현재 동작을 새 기능의 목표 정책으로 착각하기 쉽다. 기술적으로 구현 가능한 선택을 했어도 사용자가 원한 서비스와 다를 수 있다.
groundwork는 이 경계에 개입한다. 기능의 의미·업무 규칙·권한·실패와 재시도 결과에서 미정인 정책은 사용자에게 확인하고, 파일 구조·모듈·인프라 같은 기술 선택은 에이전트가 처리한다.
질문에는 발견 경위, 선택별 실제 동작과 영향을 설명한다. 기존 합의도 새 맥락이 드러나면 그 차이를 설명하고 재검토한다.

방법론의 실행 규율과 세션 부트스트랩 구조는 Jesse Vincent의 [superpowers](https://github.com/obra/superpowers)(MIT)에서 왔다. 파일 단위 고지는 [NOTICE](NOTICE)에 있다.

## Requirements

| 항목 | 값 |
|---|---|
| 실행 환경 | Claude Code (정식), Codex (스킬 노출, 실행 미검증 부분 있음) |
| 플랫폼 | macOS, Linux. Windows는 WSL |
| 보조 스크립트 | bash와 git. 추가 패키지 설치 없음 |
| 스킬 언어 | 한국어 |

## Installation

### Claude Code

이 리포를 마켓플레이스로 등록하고 설치한다.

```text
/plugin marketplace add HarryJhin/groundwork
/plugin install groundwork@groundwork
```

셸에서는 다음을 쓴다.

```bash
claude plugin marketplace add HarryJhin/groundwork
claude plugin install groundwork@groundwork
```

설치 뒤 재시작하거나 `/reload-plugins`로 훅과 매니페스트를 반영한다. 새 세션의 컨텍스트에 `using-groundwork` 본문이 있으면 부트스트랩 주입에 성공한 것이다.

#### Installation scope

| 스코프 | 범위 | 기록되는 곳 |
|---|---|---|
| `user` (기본) | 내 모든 프로젝트 | 사용자 설정 |
| `project` | 이 리포의 협업자 | `.claude/settings.json` |
| `local` | 이 리포에서 나만 | `.claude/settings.local.json` |

```bash
claude plugin install groundwork@groundwork --scope project
```

#### Removal

```bash
claude plugin uninstall groundwork@groundwork
claude plugin marketplace remove groundwork
```

잠시 끄려면 `claude plugin disable groundwork@groundwork`를 쓴다.

### Codex

`.codex-plugin/plugin.json`이 `skills/`를 노출한다. Claude Code 전용 SessionStart 훅은 제공하지 않으므로 부트스트랩은 자동 주입되지 않는다. 서브에이전트 디스패치와 실행 보조 스크립트의 Codex 동작은 미검증이다.

## How the flow runs

요청과 서비스 동작이 명확하면 바로 구현하고 검증한다. 변경 규모나 기술 선택지가 여럿이라는 이유로 인터뷰나 설계 승인을 강제하지 않는다.
미정인 도메인 정책이 있으면 필요한 사실을 확인하고 질문한다. 기존 코드가 무엇을 하는지와 새 기능이 무엇을 해야 하는지를 구분한다.
새 정책과 범위를 제안할 때는 짧은 설계를 제시해 승인을 받는다. 대화에서 합의하고 구현을 요청했다면 별도 문서 승인 단계는 두지 않는다.
되돌리기 비싼 기술 변경은 중요한 설계와 근거를 남기되 기술 선택의 승인을 따로 요구하지 않는다.

### Questions users can decide

공유 할일에 삭제 기능을 붙일 때 개인 할일의 삭제 방식을 그대로 재사용하면 다른 참여자의 작업도 사라질 수 있다.
에이전트는 이 경위를 설명하고, 모두에게 삭제하는 것과 내 목록에서만 숨기는 것의 동작·영향을 제시해 삭제의 의미를 묻는다. 저장 방식이나 모듈 배치를 사용자에게 고르게 하지 않는다.
독립적인 질문은 묶고 답에 의존하는 질문은 순서대로 묻는다. 답이 없으면 미정인 정책을 기본값으로 구현하지 않는다.

### Skills as needed

| 상황 | 스킬 |
|---|---|
| 도메인 정책 확인·설계 제안 | `finding-unknowns` |
| 설계 초안 점검 | `design-review` |
| 합의한 설계 문서 실행·태스크 리뷰 | `executing-design` |
| 독립적이고 기계적인 다수 태스크 | `subagent-driven-development` (비용 이득이 있을 때) |
| 테스트 작성·근본 원인 조사·완료 증거 확보 | `test-driven-development`·`systematic-debugging`·`verification-before-completion` |
| 코드 리뷰·피드백 평가 | `requesting-code-review`·`receiving-code-review` |
| 작업 격리·독립 조사·통합 | `using-git-worktrees`·`dispatching-parallel-agents`·`finish` |
| 문서·스킬·리포 표준 문서 작성 | `writing-for-junior`·`writing-skills`·`managing-repo-standard-docs` |

스킬과 상세 자료는 현재 작업에 필요할 때만 읽는다. 조사원 수, 인터뷰 횟수, 문서 절을 채우기 위한 고정 절차는 없다.
설계 실행은 메인이 구현하고 리뷰를 격리한다. 기술 문제는 에이전트가 해결하며, 새로운 도메인 결과나 범위 변경은 설명하고 확인한다. 통합은 기존 사용자 지시를 따르고, 정해지지 않았으면 `finish`가 선택을 받는다.

## Artifacts

프로젝트에 기존 규약이 있으면 따른다. 없으면 다음을 쓴다. 경로는 작업 리포 루트 기준이다.

| 타입 | 경로·명명 | 커밋 |
|---|---|---|
| 설계 문서 | `docs/designs/DESIGN-NNNN-<topic>.md` | ○ |
| 프로토타입 | `docs/artifacts/ARTIFACT-NNNN-proto.<ext>` | × |
| 실행 스크래치 | `.groundwork/run/<design-basename>/` | × |

설계 문서는 서비스 흐름·완료 기준과 중요한 결정을 담는다. 태스크 분해는 실행 시점의 진행 기록에 둔다.
설계는 `created`·`updated` 날짜를 가지며, 결정이 바뀌면 해당 문서를 제자리에서 고친다. 별도의 결정 문서를 쌓지 않는다.
스크래치는 재개와 잔여 문제 보고에 쓰고 `finish`가 통합 처리 뒤 정리한다. git worktree와 다른 디렉터리다.

## What code actually runs

- SessionStart 훅 하나가 짧은 `using-groundwork` 본문을 읽어 컨텍스트에 주입한다. 파일 읽기에 실패해도 세션을 막지 않는다.
- 표준 문서 부재를 자동으로 알리거나 문서 쓰기를 차단해 긴 규범을 주입하는 훅은 없다.
- 훅과 보조 스크립트에는 네트워크 호출이나 삭제가 없다. 보조 스크립트는 작업 리포의 `.groundwork/`에 스크래치와 ignore 파일을 만든다.
- 스킬은 에이전트에게 주는 지시다. 실제 도구 실행과 권한 관리는 에이전트 실행 환경이 담당한다.

## Limits

- 도메인 결정 보호는 모델이 지침을 따르는 데 의존한다. 모든 구현 도구에서 정책 합의 여부를 검사하는 실행 엔진은 아니다.
- 설계 점검은 저자의 self-review이므로 독립된 관측 위치를 제공하지 않는다.
- 명확한 요청은 별도 설계 승인 없이 실행한다. 사용자가 명시하지 않은 정책을 발견하는 능력과 질문의 품질이 중요하다.
- 행동 테스트는 제한된 시나리오에서 첫 응답과 다음 행동을 확인한다. 전체 개발 작업의 품질·시간 이득을 입증하지는 않는다. 재현 방법과 결과는 [행동 테스트](tests/skill-behavior/README.md)에 있다.
- Codex 실행과 Windows 네이티브 환경은 검증·지원 범위 밖이다.

## Contributing

질문·버그 제보·PR은 [GitHub](https://github.com/HarryJhin/groundwork/issues)로 받는다. 스킬 변경에는 행동 증거나 재현 절차가 필요하다. 작업 규칙과 리포 구조는 [CONTRIBUTING.md](CONTRIBUTING.md), 완료 작업의 이력은 [docs/README.md](docs/README.md)에 있다.

## License

MIT © 2026 Harry Jhin. [LICENSE](LICENSE)와 [NOTICE](NOTICE)를 참고한다.
