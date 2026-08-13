# groundwork

코딩 에이전트용 개발방법론 플러그인. 설계에서 종료까지 이어지는 단계 사슬을 스킬로 덮고, 세션마다 에이전트가 그 사슬에 진입하도록 강제한다.

## 목차

- [배경](#배경)
- [요구 사항](#요구-사항)
- [설치](#설치)
- [사용법](#사용법)
- [산출물](#산출물)
- [철학](#철학)
- [무엇을 실행하나](#무엇을-실행하나)
- [한계](#한계)
- [기여](#기여)
- [라이선스](#라이선스)

## 배경

디스크에만 있는 스킬은 죽은 코드다.
에이전트가 부르지 않으면 실행되지 않는다.
좋은 방법론을 문서로 적어 둬도 에이전트는 그것을 읽지 않고 곧장 코드를 쓴다.

groundwork는 이 문제를 세션 시작 훅으로 푼다.
매 세션 진입 규율을 컨텍스트에 주입하고, 그 규율이 나머지 스킬을 언제 부를지 정한다.
사용자가 무엇을 켜거나 외울 필요가 없다.

방법론의 뼈대는 Jesse Vincent의 [superpowers](https://github.com/obra/superpowers)(MIT)에서 왔다.
실행층 규율을 이식하고 설계 앞단을 다시 지었다.
파일 단위 저작권 고지는 [NOTICE](NOTICE)에 있다.

## 요구 사항

| 항목 | 값 |
|---|---|
| 하네스 | Claude Code (정식), Codex (스킬만, 미검증) |
| 플랫폼 | macOS, Linux. Windows는 WSL |
| 외부 의존성 | 없음. bash만 쓴다 |
| 문서 언어 | 한국어 |

스킬 본문이 한국어다.
에이전트에게 주는 지시가 한국어라는 뜻이므로, 한국어로 일하는 환경을 전제한다.

여기서 하네스는 스킬과 서브에이전트를 실행하는 에이전트 런타임을 뜻한다.
표준 용어 test harness와 무관하다.

## 설치

### Claude Code

이 리포가 곧 마켓플레이스다.
마켓플레이스를 등록한 뒤 플러그인을 설치한다.
세션 안에서 하는 방법과 셸에서 하는 방법이 있다.

**세션 안에서.** `/plugin install`은 설치 스코프를 고르는 패널을 연다.

```
/plugin marketplace add HarryJhin/groundwork
/plugin install groundwork@groundwork
```

**셸에서.** `claude plugin` 커맨드는 패널을 열지 않아서 스크립트와 CI에 쓴다.

```bash
claude plugin marketplace add HarryJhin/groundwork
claude plugin install groundwork@groundwork
```

설치 뒤 세션을 재시작해야 SessionStart 훅이 돈다.
이미 열린 세션에서는 `/reload-plugins`로 반영한다.

설치가 됐는지는 새 세션의 컨텍스트에 `using-groundwork` 부트스트랩 본문이 실렸는지로 확인한다.
본문이 안 보이면 주입이 실패한 것이고, 그 세션에서는 flow가 발동하지 않는다.

#### 설치 스코프

`--scope`로 어디에 설치할지 정한다.
생략하면 `user`다.

| 스코프 | 범위 | 기록되는 곳 |
|---|---|---|
| `user` | 내 모든 프로젝트 | 사용자 설정 |
| `project` | 이 리포의 모든 협업자 | `.claude/settings.json` |
| `local` | 이 리포에서 나만 | `.claude/settings.local.json` |

```bash
claude plugin install groundwork@groundwork --scope project
```

팀 전체에 쓰려면 `project` 스코프로 설치한다.
협업자가 리포 폴더를 신뢰할 때 설치 안내를 받는다.

#### 제거

```bash
claude plugin uninstall groundwork@groundwork
claude plugin marketplace remove groundwork
```

마켓플레이스를 지우면 거기서 설치한 플러그인도 함께 지워진다.
잠시 끄기만 하려면 `claude plugin disable groundwork@groundwork`를 쓴다.

### Codex

`.codex-plugin/plugin.json`이 `skills/`를 가리키는 매니페스트를 제공한다.
훅은 Claude Code 전용이라 Codex 배포는 `hooks:{}`다.
그 결과 Codex에서 부트스트랩은 자동 주입되지 않고 스킬 목록에만 노출된다.
실제 설치와 동작은 아직 검증하지 않았다([한계](#한계) 참고).

## 사용법

특별히 할 일은 없다.
설치하고 평소처럼 요청하면 된다.

무언가를 만들자고 하면 에이전트가 곧바로 코드를 쓰지 않고 모르는 것부터 찾아낸다.
스펙이 나오면 리뷰어를 병렬로 띄워 검증하고, 사용자 승인을 받은 뒤에야 플랜을 쓴다.
플랜도 같은 절차로 리뷰와 승인을 거친다.
플랜 승인이 마지막 사용자 게이트이고 그 뒤 구현·검증·종료는 자율이다.

flow가 도는지 확인하려면 새 세션에서 이렇게 말해 본다.

```
할 일 목록 앱을 만들자
```

에이전트가 구현을 시작하지 않고 `groundwork:finding-unknowns`를 호출하면 정상이다.
곧장 파일을 쓰기 시작하면 부트스트랩 주입이 실패한 것이다.

### 단계

| 단계 | 하는 일 |
|---|---|
| finding-unknowns | 모르는 것을 해소하고 스펙을 쓴다 |
| spec-review | 스펙을 리뷰어로 검증 |
| writing-plans | 태스크 단위 플랜 작성 |
| plan-review | 플랜을 리뷰어로 검증 |
| executing-plan | 태스크마다 서브에이전트를 띄워 실행 |
| test-driven-development | RED-GREEN-REFACTOR 강제 |
| requesting-code-review | 완료 작업을 리뷰어로 검증 |
| finish | 머지·PR 결정과 산출물 종료 표기 |

리뷰어는 문서나 코드를 한 가지 관점에서 검증하는 서브에이전트다.
스펙과 플랜에는 여덟이 필수로 붙고 조건에 따라 넷이 더 붙는다.
리뷰 과정은 파일을 남기지 않는다.
발견은 반환 텍스트가 전부이고 처리 결과는 문서 개정으로 드러난다.

### 언제 발동하나

진입 대상은 새 기능, 멀티파일 변경, 낯선 도메인 작업이다.
한 문장 diff로 설명되는 국소 수정은 flow 없이 바로 처리한다.

flow를 쓰고 싶지 않은 리포가 있다면 그 리포의 `CLAUDE.md`에 적는다.
부트스트랩이 사용자 지시를 groundwork보다 위에 두므로 그 지시가 이긴다.

## 산출물

flow는 작업 리포에 파일을 남긴다.

| 타입 | 위치 | 명명 | 커밋 |
|---|---|---|---|
| 스펙 | `docs/specs/` | `SPEC-NNNN-<topic>.md` | ○ |
| 플랜 | `docs/plans/` | `PLAN-NNNN-<topic>.md` | ○ |
| ADR | `docs/adr/` | `ADR-NNNN-<slug>.md` | ○ |
| 프로토타입 | `docs/artifacts/` | `ARTIFACT-NNNN-proto.<ext>` | × |

번호는 네 자리다.
스펙과 플랜이 같은 번호를 공유해 짝을 이룬다.
ADR은 Architecture Decision Record, 아키텍처 결정 기록이다.

스펙·플랜에는 `created`와 `status` 프론트매터를 단다.
작업이 끝나면 `status: closed`가 기입된다.

## 철학

flow의 각 단계가 무엇을 강제하는지는 이 다섯에서 나온다.

- 테스트 우선. 구현보다 테스트를 먼저 쓴다
- 체계 우선. ad-hoc 추측을 절차로 대체한다
- 주장보다 증거. 완료를 선언하기 전에 커맨드를 돌려 출력을 본다
- 문서는 맥락 없는 독자를 기준으로 쓴다.
  저자에게만 읽히는 문서는 미완성이다
- YAGNI. 요청되지 않은 기능·추상화·유연성을 만들지 않는다

## 무엇을 실행하나

플러그인은 훅으로 사용자 권한의 코드를 돌린다.
설치 전에 무엇이 도는지 판단할 수 있도록 범위를 밝힌다.

- **네트워크 접근 없음.** 훅과 스크립트 어디에도 외부 호출이 없다
- **쓰기 범위 둘.** 훅은 `$TMPDIR` 아래에 빈 마커 파일을 만든다.
  실행 스크립트는 작업 트리의 `.groundwork/` 아래에 스크래치 디렉터리를 만들고, 그것이 `git status`로 새지 않도록 자기 자신을 무시하는 `.gitignore`를 함께 둔다
- **삭제 없음.** 훅도 스크립트도 파일을 지우지 않는다
- **외부 의존성 없음.** bash 외에 설치할 것이 없다

스킬 본문은 에이전트에게 주는 지시라서 그 자체로는 아무것도 실행하지 않는다.
실행 주체는 언제나 에이전트이고, 도구 사용 승인은 하네스의 권한 설정을 따른다.

## 한계

- Codex에서 서브에이전트 디스패치와 보조 스크립트 실행이 미검증이다.
  스킬 노출까지만 확인했다
- Windows 네이티브 환경은 지원하지 않는다.
  훅이 bash 스크립트다
- 리뷰 이력이 파일로 남지 않아 세션이 끊기면 이전 라운드 발견이 사라진다
- 모든 스킬에 자기완결 판독 기준을 전수 적용해 발견을 고쳤으나 재판정을 돌리지 않았다

## 기여

질문과 버그 제보는 [이슈](https://github.com/HarryJhin/groundwork/issues)로 받는다.
PR도 받는다.

스킬은 산문이 아니라 에이전트 행동을 형성하는 코드다.
그래서 스킬 본문을 고치는 PR에는 근거를 요구한다.
자세한 내용과 리포 구조는 [CONTRIBUTING.md](CONTRIBUTING.md)에 있다.

## 라이선스

MIT © 2026 Harry Jhin. 전문은 [LICENSE](LICENSE)에 있다.

이식한 superpowers 콘텐츠의 저작권 고지는 [NOTICE](NOTICE)에 있다.
원본과 동일한 파일 여섯과 개작한 스킬 아홉을 파일 단위로 밝혔다(MIT © 2025 Jesse Vincent).
