# Contributing

질문과 버그 제보는 [이슈](https://github.com/HarryJhin/groundwork/issues)로 받는다.  
PR도 받는다.

## Skill changes require evidence

스킬은 산문이 아니라 에이전트 행동을 형성하는 코드다.  
최소 지침으로 시작하고 실제 실패를 관측한 뒤 보완한다.
모델이 이미 아는 일반 지식과 관측된 효용이 없는 반복·고정 절차는 기본값으로 두지 않는다.

그래서 스킬 본문을 고치는 PR에는 다음을 요구한다.

- 무엇이 어떻게 잘못 작동했는지
- 고친 뒤 무엇이 달라졌는지
- 그것을 보여주는 세션 기록이나 재현 절차

읽기 좋게 다듬는 변경만으로는 받기 어렵다.

## Working rules

- 상시 주입과 실제 로드량을 함께 확인한다. 지침을 참조 파일로 옮긴 뒤 매번 읽게 하는 것은 절감이 아니다
- 스킬을 새로 쓰거나 고칠 때는 `writing-skills`를 따른다.  
  프론트매터는 `name`과 `description`만 쓰고 `description`은 언제 쓰는지(트리거·증상·맥락)만 담는다.  
  절차를 요약하면 에이전트가 본문을 읽지 않고 요약만 따라가는 지름길이 생긴다
- 결정을 별도 문서로 모으지 않는다.  
  결정은 그것을 쓰는 설계 문서나 스킬 본문 안에 두고 그 문서를 제자리에서 고친다.  
  `docs/adr/`는 이 관행을 폐기하기 전의 동결된 이력이고 새 파일을 만들지 않는다
- 문서는 맥락 없는 독자를 기준으로 쓴다.  
  기준은 `writing-for-junior`에 있다
- **제목은 영문, 본문은 한국어로 쓴다.**  
  마크다운 헤딩은 h1부터 전부 영문 sentence case다.  
  작업을 지시하는 제목은 원형 동사로 시작하고(`Apply the review gate`) 개념을 가리키는 제목은 명사구로 쓴다(`Decision authority`).  
  둘 다 `-ing`를 첫 단어로 쓰지 않는다.  
  절 참조는 영문 제목을 링크 텍스트로 쓰고 Markdown 앵커로 연결한다
- 매니페스트를 고쳤으면 `claude plugin validate . --strict`를 돌린다

`plugin.json`의 `version`은 명시돼 있다.  
이 값을 올리지 않으면 기존 사용자에게 변경이 가지 않으므로 배포할 변경에는 반드시 함께 올린다.

## Repo structure

여섯 갈래로 나뉜다.  
스킬, 훅, 스크립트, 배포 매니페스트, 문서, 라이선스 표기다.

### Skills

`skills/` 아래에 있다.  
디렉터리 이름이 곧 스킬 이름이고 각 디렉터리의 `SKILL.md`가 본문이다.

**설계·리뷰**

- `finding-unknowns` 도메인 정책 확인과 필요한 설계 제안. 질문의 발견 경위·선택별 동작·영향을 설명한다. 조사·스파이크·프로토타입은 위험에 맞게 선택하며 사용자와의 대화는 메인이 맡는다
- `design-review` 설계 저자가 같은 세션에서 한 번 수행하는 self-review다

**실행**

- `executing-design` 설계 문서를 태스크로 쪼개 현재 세션에서 실행하고 태스크마다 리뷰 게이트를 건다. 설계 실행의 기본 경로
- `subagent-driven-development` 태스크마다 서브에이전트를 띄운다. 태스크가 많고 독립이고 기계적일 때만 쓰는 조건부 경로
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

**리포 표준**

- `managing-repo-standard-docs` README·CONTRIBUTING·SECURITY·CHANGELOG 등 리포 표준 문서의 감사와 표준 준수 작성

**진입**

- `using-groundwork` 부트스트랩. SessionStart 훅이 이 본문을 매 세션 주입한다

### Reviews

설계 문서는 별도 리뷰어를 띄우지 않는다.  
설계 저자가 확정된 사용자 정책·리포 실물과 문서를 한 번 대조하고 `통과`나 `조건부 통과`를 판정한다.
리뷰 범위 선택, 리뷰어 프롬프트, 재리뷰 라운드, 확인 라운드는 없다.

코드를 검증하는 리뷰어는 하나이고 프롬프트가 `skills/requesting-code-review/code-reviewer-prompt.md`에 있다.

### Hooks

Claude Code 전용이며 `hooks/hooks.json`이 SessionStart 훅 하나를 등록한다.
`hooks/session-start-groundwork`가 `skills/using-groundwork/SKILL.md` 본문을 `<GROUNDWORK>` 블록으로 감싸 `hookSpecificOutput.additionalContext`로 주입한다.
파일 부재나 읽기 실패는 무해 종료라 세션을 막지 않는다.
표준 문서 부재 알림과 문서 쓰기 차단 훅은 없다. 문서 규범과 표준 자료는 해당 작업에서 필요할 때 읽는다.

### Scripts

`skills/executing-design/scripts/` 아래에 있다.  
실행 자산은 기본 경로인 `executing-design`이 소유하고 조건부 경로인 `subagent-driven-development`가 건너와서 쓴다.  
컨트롤러가 태스크 텍스트와 diff를 자기 컨텍스트로 통과시키면 그것이 남은 세션 내내 상주하므로, 스크립트가 산출물을 파일로 넘긴다.

- `design-scratch` 설계 문서별 실행 스크래치 디렉터리를 `.groundwork/run/` 아래에 확보한다
- `review-package` 커밋 목록과 diff를 리뷰용 파일 하나로 묶는다

두 스크립트 모두 첫 인자로 설계 문서 파일 경로를 받고 stdout으로 경로 한 줄만 낸다.  
관측값은 stderr로 나간다.  
호출자가 stdout을 그대로 다음 단계에 넣을 수 있어야 파싱이 개입하지 않는다.

**실행 스크래치와 워크트리는 다른 것이고 이름을 갈라 쓴다.**  
워크트리는 `using-git-worktrees`가 만드는 git worktree이고 커밋된 코드가 산다.  
실행 스크래치는 그 워크트리 안의 커밋하지 않는 디렉터리이고 진행 기록·브리프·리뷰 패키지가 산다.  
둘을 같은 말로 부르면 종료 단계의 삭제가 어느 쪽을 겨누는지 갈리지 않는다.  
스크립트 이름에 `workspace`를 쓰지 않는 이유가 이것이다.

**둘 다 지우는 것은 `finish`뿐이다.**  
실행 스킬은 만들기만 하고 지우지 않는다.  
실행 스킬이 스크래치를 지우면 `finish`의 [Report the outstanding findings](skills/finish/SKILL.md#report-the-outstanding-findings)가 읽을 진행 기록이 없어진다.

### Manifests

같은 플러그인을 하네스별로 노출한다.

- `.claude-plugin/plugin.json` Claude Code 플러그인 매니페스트
- `.claude-plugin/marketplace.json` 이 리포를 마켓플레이스로 만드는 카탈로그
- `.codex-plugin/plugin.json` Codex용. `skills/`만 가리킨다
- `.agents/plugins/marketplace.json` 로컬 소스 카탈로그

플러그인 설명은 `plugin.json`, `marketplace.json` 엔트리, `.codex-plugin/plugin.json`, README 두 번째 줄, GitHub 리포 description 다섯 곳에 같은 문장으로 있다.  
고칠 때 함께 고친다.

### Documentation

`docs/`는 완료된 작업의 기록이고 현재 상태를 서술하지 않는다.  
읽는 법은 [docs/README.md](docs/README.md)에 있다.

## Develop locally

리포를 클론해 로컬 경로로 등록한다.

```bash
claude plugin marketplace add ./groundwork
claude plugin install groundwork@groundwork
```

`SKILL.md` 수정은 현재 세션에 즉시 반영된다.  
훅과 매니페스트 수정은 `/reload-plugins`나 재시작이 필요하다.

## Revise groundwork itself

이 리포에서는 flow를 쓰지 않는다.  
새 기능이나 멀티파일 변경이라도 직접 처리한다.  
사용자 지시는 groundwork의 기본 경로보다 우선한다.
이 문단이 그 사용자 지시다.
