# groundwork

코딩 에이전트를 위한 개발방법론 플러그인이다. 설계에서 종료까지 이어지는 단계 사슬(이하 flow)과, 에이전트가 그 사슬을 반드시 거치게 만드는 세션 진입 규율로 이뤄진다.

문서와 스킬 본문은 전부 한국어다. 에이전트에게 주는 지시가 한국어라는 뜻이므로 한국어로 일하는 환경을 전제한다.

## 용어

문서 전체가 쓰는 말이다.

- **하네스(harness)**: 스킬과 서브에이전트를 실행하는 에이전트 런타임. groundwork의 대상은 Claude Code와 Codex다. 표준 용어 test harness와 무관하다.
- **flow**: 설계에서 종료까지 순서가 고정된 단계 사슬. 단계마다 그 단계를 실행하는 스킬이 있다. 단계 목록은 아래 「flow」에 있다.
- **메인 에이전트**: 사용자와 대화하는 세션의 에이전트. 서브에이전트를 띄우는 쪽이다.
- **리뷰어**: 문서나 코드를 한 가지 관점에서 검증하는 서브에이전트. 정의 파일 없이 프롬프트 파일 한 장으로 존재한다. 관점마다 리뷰어가 하나씩 있다.
- **산출물**: flow가 파일로 남기는 것. 스펙, 플랜, ADR(Architecture Decision Record, 아키텍처 결정 기록), 그리고 프로토타입이다.
- **프로토타입**: 산출물 중 커밋하지 않는 것. 말로 답이 안 나오는 UI·UX 방향을 실물로 병치해 반응을 받을 때만 만든다.

이 문서의 상대 경로는 모두 리포 루트 기준이다.

## 어떻게 작동하나

디스크에만 있는 스킬은 죽은 코드다. 에이전트가 부르지 않으면 실행되지 않는다. groundwork는 이 문제를 세션 시작 훅으로 푼다.

`hooks/session-start-groundwork`가 매 세션(startup·clear·compact) `skills/using-groundwork/SKILL.md` 전문을 읽어 `<EXTREMELY_IMPORTANT>` 블록으로 감싼 뒤 세션 컨텍스트에 주입한다. 그 본문이 나머지 스킬을 언제 부를지 정한다. 주입이 실패하면 flow가 발동하지 않으므로, 부트스트랩 본문이 컨텍스트에 보이는지가 곧 플러그인이 살아 있다는 신호다.

에이전트가 하는 일은 이렇다. 사용자가 무언가를 만들자고 하면 곧바로 코드를 쓰지 않고 모르는 것부터 턴다. 스펙이 나오면 리뷰어를 병렬로 띄워 검증하고, 사용자 승인을 받은 뒤에야 플랜을 쓴다. 플랜도 같은 절차로 리뷰와 승인을 거친다. 플랜 승인이 마지막 사용자 게이트이고 그 뒤 구현·검증·종료는 자율이다.

## 설치

### Claude Code

이 리포가 곧 마켓플레이스다. 등록한 뒤 플러그인을 설치한다.

```bash
/plugin marketplace add HarryJhin/groundwork
/plugin install groundwork@groundwork
```

설치 뒤 세션을 재시작해야 SessionStart 훅이 돈다.

훅이 bash 스크립트라 지원 플랫폼은 macOS와 Linux다. Windows는 WSL에서 쓴다.

리포를 직접 고치며 쓰려면 로컬 경로로 등록한다. 스킬을 고친 다음에는 `/reload-plugins`로 반영한다.

```bash
/plugin marketplace add ./groundwork
```

### Codex

`.codex-plugin/plugin.json`이 `skills/`를 가리키는 매니페스트를 제공한다. 훅은 Claude Code 전용이라 Codex 배포는 `hooks:{}`다. 그 결과 Codex에서 부트스트랩은 자동 주입되지 않고 스킬 목록에만 노출된다.

Codex에서 실제 설치와 동작은 아직 검증하지 않았다. 서브에이전트 디스패치와 보조 스크립트 실행이 그 런타임에서 어떻게 도는지가 미확인 영역이다. 근거와 감수한 위험은 `docs/adr/ADR-0003-porting-the-full-execution-layer.md`에 있다.

## flow

단계 이름은 대개 그 단계를 소유한 스킬 이름과 같다. bootstrap과 executing-plan만 예외다. bootstrap은 `using-groundwork`가 소유하고, executing-plan은 상황에 따라 두 스킬 중 하나가 소유한다.

| 단계 | 소유 스킬 | 하는 일 |
|---|---|---|
| bootstrap | `using-groundwork` | 진입 판별과 강제. 매 세션 자동 주입 |
| finding-unknowns | `finding-unknowns` | 모르는 것을 해소하고 스펙을 쓴다 |
| spec-review | `spec-review` | 스펙을 리뷰어로 검증 |
| writing-plans | `writing-plans` | 태스크 단위 플랜 작성 |
| plan-review | `plan-review` | 플랜을 리뷰어로 검증 |
| executing-plan | `subagent-driven-development`(기본) / `executing-plan` | 플랜 실행 |
| test-driven-development | `test-driven-development` | RED-GREEN-REFACTOR 강제 |
| requesting-code-review | `requesting-code-review` | 완료 작업을 리뷰어로 검증 |
| finish | `finish` | 머지·PR 결정과 산출물 종료 표기 |

진입 대상은 새 기능, 멀티파일 변경, 낯선 도메인 작업이다. 한 문장 diff로 설명되는 국소 수정은 flow 없이 바로 처리한다.

## 구성

### 스킬

`skills/` 아래에 있다. 디렉터리 이름이 곧 스킬 이름이고 각 디렉터리의 `SKILL.md`가 본문이다.

**설계·리뷰**
- `finding-unknowns` 설계 진입. 블라인드 스팟 탐색, 기존 구현·문서와의 대조, 위험 가정 검증(스파이크)을 서브에이전트로 병렬 조사한다. 에이전트가 사용자에게 되묻는 인터뷰와 프로토타이핑은 메인 에이전트가 전담한다
- `spec-review` 스펙 전용 리뷰
- `plan-review` 플랜 전용 리뷰
- `writing-plans` 태스크 분해와 플랜 작성

**실행**
- `subagent-driven-development` 태스크마다 fresh 서브에이전트와 리뷰 게이트. 플랜 실행의 기본 경로
- `executing-plan` 현재 세션에서 직접 실행하는 대체 경로
- `test-driven-development` 테스트 우선
- `systematic-debugging` 근본 원인 규명
- `verification-before-completion` 완료 주장 전 증거 확보
- `using-git-worktrees` 워크스페이스 격리
- `dispatching-parallel-agents` 독립 문제의 병렬 조사
- `finish` 통합 방법 결정과 종료

**코드 리뷰**
- `requesting-code-review` 리뷰어 디스패치
- `receiving-code-review` 받은 피드백의 기술적 평가

**문서 작성**
- `writing-for-junior` 맥락 없는 독자를 기준으로 쓰는 작성 규범과 그것을 검사하는 판정 기준
- `writing-skills` 스킬 작성 표준
- `writing-adr` ADR 작성
- `writing-clearly-and-concisely` 문장 층위 산문 규범

**진입**
- `using-groundwork` 부트스트랩

### 리뷰어

리뷰어는 하네스별 정의 파일을 쓰지 않는다. 메인 에이전트가 범용 에이전트에 프롬프트 텍스트를 주입해 띄우므로 런타임을 가리지 않는다. 도구 격리는 프롬프트 지시로 대체한다.

프롬프트는 각 리뷰 스킬 디렉터리에 있다. 스펙용은 `skills/spec-review/<리뷰어이름>-prompt.md`, 플랜용은 `skills/plan-review/<리뷰어이름>-prompt.md`다. 양쪽에 다 쓰이는 리뷰어는 프롬프트를 복제하고 문구를 문서 유형별로 특화했다.

아래 표는 문서를 검증하는 리뷰어만 담는다. 「적용」은 어느 문서 유형의 리뷰에서 그 리뷰어를 쓰는지 가리킨다. 「발동」의 필수는 항상 띄운다는 뜻이고, 재량은 리뷰 스킬이 정한 조건을 만족할 때만 띄운다는 뜻이다. 그 조건은 리뷰어마다 다르고 `skills/spec-review/SKILL.md`와 `skills/plan-review/SKILL.md`의 「재량」 절에 있다.

| 리뷰어 | 적용 | 발동 | 보는 것 |
|---|---|---|---|
| `junior-read` | 공통 | 필수 | 맥락 없는 독자의 판독 가능성 |
| `completeness` | 공통 | 필수 | 누락·엣지케이스·뒤로 미룬 결정 |
| `consistency` | 공통 | 필수 | 내부 모순·절 사이 충돌 |
| `clarity` | 공통 | 필수 | 모호한 표현·이중 해석 |
| `yagni` | 공통 | 필수 | 불필요한 기능·과설계·조기 추상화 |
| `scope` | 스펙 | 필수 | 범위 이탈·독립 서브시스템 혼재 |
| `decomposition` | 플랜 | 필수 | 태스크 경계·의존 순서·태스크 하나만 읽고 착수할 수 있는 자기완결성 |
| `spec-alignment` | 플랜 | 필수 | 플랜과 대응 스펙의 정합 |
| `experience` | 공통 | 재량 | 사용자 대면 요소(UX·카피·에러 메시지) |
| `facts` | 공통 | 재량 | 외부 근거에 기대는 주장(수치·인용·API 시그니처) |
| `crossref` | 공통 | 재량 | 연관 산출물과의 정합 |
| `intent` | 공통 | 재량 | 인터뷰 답변·승인 대화와 문서 결정의 정합 |

`junior-read`만 예외로 프롬프트가 `skills/writing-for-junior/junior-read-prompt.md` 한 곳에 있다. 판정 기준과 작성 규범이 같은 지식의 양면이라 `writing-for-junior`가 함께 소유한다.

코드를 검증하는 리뷰어는 하나이고 프롬프트가 `skills/requesting-code-review/code-reviewer-prompt.md`에 있다.

리뷰 과정은 파일을 만들지 않는다. 리뷰어 반환 텍스트가 발견의 전부이고 처리 결과는 문서 개정으로 드러난다.

### 훅

Claude Code 전용이다.

- `hooks/session-start-groundwork` 부트스트랩을 세션 컨텍스트에 주입한다. 파일 부재나 읽기 실패는 무해 종료라 세션을 막지 않는다
- `hooks/pre-artifact-write-junior-gate` 스펙·플랜·ADR·스킬을 새로 만드는 첫 쓰기를 한 번 막고 `writing-for-junior`의 작성 규범을 반환한다. 같은 파일의 다음 쓰기는 통과시킨다. 이미 있는 파일 편집은 처음부터 통과시킨다

### 스크립트

`skills/subagent-driven-development/scripts/` 아래에 있다. 존재 이유는 컨텍스트 경제다. 컨트롤러가 태스크 텍스트와 diff를 자기 컨텍스트로 통과시키면 그것이 남은 세션 내내 상주한다. 스크립트가 산출물을 파일로 넘겨 그 비용을 없앤다.

- `sdd-workspace` 플랜별 작업 디렉터리를 `.groundwork/sdd/` 아래에 확보한다
- `task-brief` 플랜에서 태스크 하나를 뽑아 브리프 파일로 낸다. 헤딩 형식 `### Task N: <이름>`에 결합돼 있다
- `review-package` 커밋 목록과 diff를 리뷰용 파일 하나로 묶는다

## 산출물 규약

| 타입 | 위치 | 명명 | 커밋 |
|---|---|---|---|
| 스펙 | `docs/specs/` | `SPEC-NNNN-<topic>.md` | ○ |
| 플랜 | `docs/plans/` | `PLAN-NNNN-<topic>.md` | ○ |
| ADR | `docs/adr/` | `ADR-NNNN-<slug>.md` | ○ |
| 프로토타입 | `.claude/artifacts/` | `ARTIFACT-NNNN-proto.<ext>` | × |

번호는 네 자리다. 스펙과 플랜이 같은 번호를 공유해 짝을 이룬다. 프로토타입도 대응 스펙의 번호를 쓴다.

스펙·플랜에는 `created`와 `status` 프론트매터를 단다. 작업이 끝나면 `finish`가 `status: closed`를 기입한다.

이 리포의 `docs/`는 groundwork 자신을 만들며 나온 산출물이다. flow가 실제로 무엇을 남기는지 보여주는 예시이면서, 동시에 **완료된 작업의 기록이라 현재 상태를 서술하지 않는다**. 읽는 법은 [docs/README.md](docs/README.md)에 있다.

## 철학

- 테스트 우선. 구현보다 테스트를 먼저 쓴다
- 체계 우선. ad-hoc 추측을 절차로 대체한다
- 주장보다 증거. 완료를 선언하기 전에 커맨드를 돌려 출력을 본다
- 문서는 맥락 없는 독자를 기준으로 쓴다. 저자에게만 읽히는 문서는 미완성이다
- YAGNI. 요청되지 않은 기능·추상화·유연성을 만들지 않는다

## superpowers와의 관계

Jesse Vincent의 [superpowers](https://github.com/obra/superpowers)(코딩 에이전트용 개발방법론 플러그인, MIT 라이선스)를 기반으로 만들었고, 목표는 공존이 아니라 완전 대체다.

이식한 것은 검증된 강점이다. SessionStart 훅 부트스트랩 주입, 스킬 자동 트리거와 강한 프롬프트 장치, 실행층 규율 전량이다. 실행층은 실제 세션 실패에서 역산해 다듬어진 것이라 다시 설계할 근거가 없어 번역만 했다.

다시 설계한 것은 앞단이다. superpowers의 `brainstorming`·`writing-plans` 자리에 `finding-unknowns`·`spec-review`·`writing-plans`·`plan-review`를 넣어 모르는 것의 해소와 문서 리뷰를 갖춘 설계 flow로 확장했다. 문서 리뷰 체계, 산출물 규약, ADR 규약, 맥락 없는 독자 기준의 작성 규범은 groundwork 고유다.

사본은 원본과 달라진다. superpowers가 실행층을 개선해도 자동으로 오지 않는다. 대조는 수동 작업이다.

이식 판단의 근거는 `docs/adr/ADR-0003-porting-the-full-execution-layer.md`에 있다.

## 이 리포에서 일하기

groundwork 자신을 고칠 때는 flow를 쓰지 않는다. 새 기능이나 멀티파일 변경이라도 직접 처리한다. 부트스트랩이 매 세션 flow 진입을 강제하지만 그 부트스트랩 자신이 사용자 지시를 groundwork보다 위에 둔다. 이 절이 그 사용자 지시다.

스킬을 새로 쓰거나 고칠 때는 `writing-skills`를 따른다. 프론트매터는 `name`과 `description`만 쓰고, `description`은 언제 쓰는지(트리거·증상·맥락)만 담는다. 절차를 요약하면 에이전트가 본문을 읽지 않고 요약만 따라가는 지름길이 생긴다.

결정이 중요한 변경은 `docs/adr/`에 ADR로 남긴다. Consequences의 Negative는 기재 의무다.

커밋과 브랜치는 별도 지시가 있을 때만 만든다.

## 남은 과제

- 모든 스킬에 `junior-read`를 전수 적용해 발견을 고쳤으나 재판정을 돌리지 않았다
- Codex에서 서브에이전트 디스패치와 보조 스크립트 실행이 미검증이다
- 양쪽에 다 쓰이는 리뷰어의 프롬프트가 `skills/spec-review/`와 `skills/plan-review/`에 두 벌로 존재한다. 한쪽을 고치면 다른 쪽을 함께 고쳐야 한다
- 리뷰 이력이 파일로 남지 않아 세션이 끊기면 이전 라운드 발견이 사라진다

## 라이선스

MIT. 전문은 [LICENSE](LICENSE)에 있다.

이식한 superpowers 콘텐츠의 저작권 고지는 [NOTICE](NOTICE)에 있다. 원본과 동일한 파일 여섯과 개작한 스킬 아홉을 파일 단위로 밝혔다(Copyright © 2025 Jesse Vincent, MIT).
