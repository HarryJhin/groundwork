# 기여

질문과 버그 제보는 [이슈](https://github.com/HarryJhin/groundwork/issues)로 받는다. PR도 받는다.

## 스킬 변경에는 근거를 요구한다

스킬은 산문이 아니라 에이전트 행동을 형성하는 코드다. 표현이 어색해 보이는 자리가 대체로 에이전트 행동을 잡으려고 일부러 그렇게 쓴 자리다. 강한 어조, 반복, 「Red Flags」 표 같은 장치가 그렇다.

그래서 스킬 본문을 고치는 PR에는 다음을 요구한다.

- 무엇이 어떻게 잘못 작동했는지
- 고친 뒤 무엇이 달라졌는지
- 그것을 보여주는 세션 기록이나 재현 절차

읽기 좋게 다듬는 변경만으로는 받기 어렵다.

## 작업 규칙

- 스킬을 새로 쓰거나 고칠 때는 `writing-skills`를 따른다. 프론트매터는 `name`과 `description`만 쓰고, `description`은 언제 쓰는지(트리거·증상·맥락)만 담는다. 절차를 요약하면 에이전트가 본문을 읽지 않고 요약만 따라가는 지름길이 생긴다
- 결정이 중요한 변경은 `docs/adr/`에 ADR로 남긴다. Consequences의 Negative는 기재 의무다
- 문서는 맥락 없는 독자를 기준으로 쓴다. 기준은 `writing-for-junior`에 있다
- 매니페스트를 고쳤으면 `claude plugin validate . --strict`를 돌린다

`plugin.json`의 `version`은 명시돼 있다. 이 값을 올리지 않으면 기존 사용자에게 변경이 가지 않으므로, 배포할 변경에는 반드시 함께 올린다.

## 리포 구조

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

**리포 표준**

- `managing-community-health-files` GitHub 커뮤니티 헬스 파일의 감사·스캐폴딩과 조직 `.github` 상속 구성

**진입**

- `using-groundwork` 부트스트랩. SessionStart 훅이 이 본문을 매 세션 주입한다

### 리뷰어

리뷰어는 하네스별 정의 파일을 쓰지 않는다. 메인 에이전트가 범용 에이전트에 프롬프트 텍스트를 주입해 띄우므로 런타임을 가리지 않는다. 도구 격리는 프롬프트 지시로 대체한다.

프롬프트는 각 리뷰 스킬 디렉터리에 있다. 스펙용은 `skills/spec-review/<리뷰어이름>-prompt.md`, 플랜용은 `skills/plan-review/<리뷰어이름>-prompt.md`다. 양쪽에 다 쓰이는 리뷰어는 프롬프트를 복제하고 문구를 문서 유형별로 특화했다.

「적용」은 어느 문서 유형의 리뷰에서 그 리뷰어를 쓰는지 가리킨다. 「발동」의 필수는 항상 띄운다는 뜻이고, 재량은 리뷰 스킬이 정한 조건을 만족할 때만 띄운다는 뜻이다. 그 조건은 리뷰어마다 다르고 `skills/spec-review/SKILL.md`와 `skills/plan-review/SKILL.md`의 「재량」 절에 있다.

| 리뷰어 | 적용 | 발동 | 보는 것 |
|---|---|---|---|
| `junior-read` | 공통 | 필수 | 맥락 없는 독자의 판독 가능성 |
| `completeness` | 공통 | 필수 | 누락·엣지케이스·뒤로 미룬 결정 |
| `coherence` | 공통 | 필수 | 모호한 표현·이중 해석과 내부 모순·절 사이 충돌 |
| `boundary` | 스펙 | 필수 | 범위 이탈·독립 서브시스템 혼재와 불필요한 기능·과설계 |
| `yagni` | 플랜 | 필수 | 불필요한 기능·과설계·조기 추상화 |
| `decomposition` | 플랜 | 필수 | 태스크 경계·의존 순서·태스크 하나만 읽고 착수할 수 있는 자기완결성 |
| `spec-alignment` | 플랜 | 필수 | 플랜과 대응 스펙의 정합 |
| `experience` | 공통 | 재량 | 사용자 대면 요소(UX·카피·에러 메시지) |
| `facts` | 공통 | 재량 | 외부 근거에 기대는 주장(수치·인용·API 시그니처) |
| `crossref` | 공통 | 재량 | 연관 산출물과의 정합 |
| `intent` | 공통 | 재량 | 인터뷰 답변·승인 대화와 문서 결정의 정합 |

`junior-read`만 예외로 프롬프트가 `skills/writing-for-junior/junior-read-prompt.md` 한 곳에 있다. 판정 기준과 작성 규범이 같은 지식의 양면이라 `writing-for-junior`가 함께 소유한다.

코드를 검증하는 리뷰어는 하나이고 프롬프트가 `skills/requesting-code-review/code-reviewer-prompt.md`에 있다.

공통 리뷰어의 프롬프트가 `spec-review`와 `plan-review`에 두 벌로 존재한다. 한쪽을 고치면 다른 쪽을 함께 고쳐야 한다.

### 훅

Claude Code 전용이다. `hooks/hooks.json`이 등록한다.

- `hooks/session-start-groundwork` `skills/using-groundwork/SKILL.md` 전문을 읽어 `<EXTREMELY_IMPORTANT>` 블록으로 감싼 뒤 세션 컨텍스트에 주입한다. 파일 부재나 읽기 실패는 무해 종료라 세션을 막지 않는다
- `hooks/pre-artifact-write-junior-gate` 스펙·플랜·ADR·스킬을 새로 만드는 쓰기를 한 번 막고 `writing-for-junior`의 작성 규범을 반환한다. 차단은 한 세션에서 문서 종류마다 한 번이다(스펙·플랜·ADR·스킬 각 1회, 세션당 최대 4회). 같은 종류의 다음 문서는 차단하지 않고 규범을 계속 적용하라는 한 줄만 낸다. 이미 있는 파일 편집은 처음부터 통과시킨다. 파일 단위로 차단하던 이전 동작은 문서를 여러 개 쓰는 세션에서 같은 안내문을 파일 수만큼 반복했고 그때마다 완성된 쓰기 내용이 폐기됐다

### 스크립트

`skills/subagent-driven-development/scripts/` 아래에 있다. 존재 이유는 컨텍스트 경제다. 컨트롤러가 태스크 텍스트와 diff를 자기 컨텍스트로 통과시키면 그것이 남은 세션 내내 상주한다. 스크립트가 산출물을 파일로 넘겨 그 비용을 없앤다.

- `sdd-workspace` 플랜별 작업 디렉터리를 `.groundwork/sdd/` 아래에 확보한다
- `task-brief` 플랜에서 태스크 하나를 뽑아 브리프 파일로 낸다. 헤딩 형식 `### Task N: <이름>`에 결합돼 있다
- `review-package` 커밋 목록과 diff를 리뷰용 파일 하나로 묶는다

### 매니페스트

같은 플러그인을 하네스별로 노출한다.

- `.claude-plugin/plugin.json` Claude Code 플러그인 매니페스트
- `.claude-plugin/marketplace.json` 이 리포를 마켓플레이스로 만드는 카탈로그
- `.codex-plugin/plugin.json` Codex용. `skills/`만 가리킨다
- `.agents/plugins/marketplace.json` 로컬 소스 카탈로그

플러그인 설명은 `plugin.json`, `marketplace.json` 엔트리, `.codex-plugin/plugin.json`, README 두 번째 줄, GitHub 리포 description 다섯 곳에 같은 문장으로 있다. 고칠 때 함께 고친다.

### 문서

`docs/`는 완료된 작업의 기록이고 현재 상태를 서술하지 않는다. 읽는 법은 [docs/README.md](docs/README.md)에 있다.

## 로컬에서 개발하기

리포를 클론해 로컬 경로로 등록한다.

```bash
claude plugin marketplace add ./groundwork
claude plugin install groundwork@groundwork
```

`SKILL.md` 수정은 현재 세션에 즉시 반영된다. 훅과 매니페스트 수정은 `/reload-plugins`나 재시작이 필요하다.

## groundwork 자신을 고칠 때

이 리포에서는 flow를 쓰지 않는다. 새 기능이나 멀티파일 변경이라도 직접 처리한다. 부트스트랩이 매 세션 flow 진입을 강제하지만 그 부트스트랩 자신이 사용자 지시를 groundwork보다 위에 둔다. 이 문단이 그 사용자 지시다.
