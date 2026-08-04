# junior-read 전수 판정 리포트: groundwork 스킬 19종

판정일 2026-07-25. 대상은 `skills/` 아래 SKILL.md 19개 전부다. 판정 도구는 `groundwork:writing-for-junior`가 소유한 두 렌즈, 공통 렌즈 `junior-read-prompt.md`와 스킬 델타 `delta-skill.md`다.

## 결과

19개 전부 FAIL이다. PASS는 없다.

발견은 184건이고 그중 severity high가 32건이다. high는 렌즈 기준으로 "없어서 스킬의 첫 행동이 막히는" 결함을 뜻한다.

| 스킬 | high | med | 계 |
|---|---:|---:|---:|
| finding-unknowns | 3 | 14 | 17 |
| subagent-driven-development | 3 | 13 | 16 |
| writing-skills | 1 | 15 | 16 |
| finish | 4 | 9 | 13 |
| test-driven-development | 3 | 10 | 13 |
| using-git-worktrees | 2 | 9 | 11 |
| using-groundwork | 0 | 11 | 11 |
| writing-for-junior | 1 | 10 | 11 |
| plan-review | 1 | 8 | 9 |
| receiving-code-review | 3 | 6 | 9 |
| spec-review | 2 | 7 | 9 |
| dispatching-parallel-agents | 3 | 5 | 8 |
| executing-plan | 1 | 7 | 8 |
| verification-before-completion | 1 | 7 | 8 |
| writing-plans | 2 | 6 | 8 |
| systematic-debugging | 0 | 5 | 5 |
| writing-adr | 0 | 5 | 5 |
| writing-clearly-and-concisely | 2 | 2 | 4 |
| requesting-code-review | 0 | 3 | 3 |
| **합계** | **32** | **152** | **184** |

문서 길이와 결함 수는 비례하지 않는다. 55행짜리 `writing-clearly-and-concisely`가 high 2건이고, 692행짜리 `writing-skills`가 high 1건이다. 결함은 분량이 아니라 계약 명시 여부에서 나온다.

## 판정 방법

스킬 하나마다 격리된 리뷰어 하나를 붙였다. 리뷰어에게는 문서 경로와 두 렌즈 파일의 경로만 주고 세션 배경, 작업 맥락, 다른 스킬의 내용을 주지 않았다. 렌즈가 요구하는 조건이 그것이다. 판정 질문은 "내가 이 용어를 아는가"가 아니라 "문서가 이 용어를 정의하는가"다.

리뷰어는 문서 본문만 읽었다. 같은 디렉터리의 참조 파일은 「참조 해소」 항목 4(위치가 적힌 참조물이 실재하는가)를 확인할 때만 열었다.

### 이 판정의 한계

세 리뷰어(`executing-plan`, `using-git-worktrees`, `writing-adr`)가 격리 위반을 스스로 신고했다. 디스패처가 배경을 동봉하지 않았는데도 세션 컨텍스트를 통해 프로젝트 지침(`CLAUDE.md`, `CLAUDE.local.md`)이 상속돼 groundwork 배경과 superpowers 이식 현황이 보였다는 것이다. 셋 다 판정에서 배제했다고 밝혔다.

나머지 16개는 신고하지 않았으나 같은 상속을 받았을 가능성이 있다. 오염은 결함을 더 찾는 방향이 아니라 놓치는 방향으로 작용한다. 도메인 용어를 이미 아는 리뷰어는 그것이 문서에 정의됐는지 묻지 않는다. 따라서 실제 결함은 이 리포트가 적은 184건보다 많다고 보는 편이 안전하다.

여러 리뷰어가 Glob 도구를 쓸 수 없어 읽기 전용 셸 명령으로 참조물 실재를 확인했다고 신고했다. 판정 결과에는 영향이 없다.

## 교차 패턴

같은 결함이 여러 문서에 반복된다. 개별 스킬의 실수가 아니라 규약의 공백이다.

### 1. 입력 계약 부재 (12개 문서, high 9건)

가장 크고 가장 심한 패턴이다. 스킬이 무엇을 받는지, 호출자가 넘기는지 스스로 찾는지, 찾는다면 어떤 규칙인지, 받지 못하면 무엇을 하는지가 비어 있다.

걸린 문서: `executing-plan`, `finish`, `plan-review`, `receiving-code-review`, `spec-review`, `subagent-driven-development`, `using-git-worktrees`, `verification-before-completion`, `writing-plans`(이상 high), `writing-adr`, `writing-for-junior`, `writing-skills`(med).

구체적으로 이렇다. `executing-plan`의 1단계는 "플랜 파일을 읽는다"인데 어느 파일인지 특정할 경로가 문서 전체에 없다. `subagent-driven-development`의 첫 커맨드는 `scripts/sdd-workspace PLAN_FILE`인데 `PLAN_FILE` 값의 출처가 없다. `spec-review`와 `plan-review`는 리뷰 대상 문서 경로를 어디서 얻는지 적지 않아 첫 디스패치가 막힌다. `finish`의 7단계는 스펙과 플랜 양쪽에 `status: closed`를 기입하라고 하면서 어느 파일이 그 스펙이고 플랜인지 말하지 않는다.

`writing-for-junior` 자신이 「문서 유형별 필수 절」 표에서 스킬의 필수 절로 "입력(무엇을 받는가, 없으면 어떻게 하는가)"을 규정한다. 그 표를 소유한 문서를 포함해 12개가 그것을 지키지 않았다.

### 2. 주체 미정의 (10개 문서)

문서를 실행하는 것이 누구인지 선언이 없는데 본문은 저자, 메인, 컨트롤러, 리뷰어, 구현자, 에이전트 같은 역할 이름을 정의 없이 쓴다. 실행자가 자기 역할을 특정하지 못하면 어느 지시를 자기 몫으로 볼지 정할 수 없다.

`spec-review`는 `저자`, `메인`, `리뷰어` 셋을 쓰면서 그중 무엇이 실행자인지 말하지 않는다. 리뷰어를 서브에이전트로 띄운다고 명시했으므로 "역할 이름은 서브에이전트를 가리킨다"는 독법이 이미 문서 안에 서 있고, 그래서 실행자는 `저자`가 자기 자신인지 따로 띄울 또 하나의 서브에이전트인지 판정할 수 없다. `verification-before-completion`은 더 나쁘다. 실행자를 한 번도 명명하지 않으면서 "에이전트의 성공 보고를 믿는다"를 Red Flag로 적어, 자신을 에이전트로 여기는 실행자가 그 규칙을 자기 보고에 적용해 스킬을 무력화할 수 있다.

### 3. 경로 기준 없음 (8개 문서)

델타의 독자 조건이 명시하듯 스킬은 플러그인 디렉터리에 설치되고 실행 시점 작업 디렉터리는 사용자 프로젝트다. 그런데 문서들은 상대 경로를 기준 없이 적는다.

`writing-clearly-and-concisely`는 유일한 행동이 "`elements-of-style.md`를 읽는다"인데 기준 디렉터리가 없어 그 한 행동이 막힌다. `writing-skills`는 본문에서 "플러그인 안의 파일을 가리킬 때는 `${CLAUDE_PLUGIN_ROOT}` 기준으로 적는다"고 규정해놓고, 정작 자기 코드 블록에 `./render-graphs.js ../some-skill`을 적었다. `subagent-driven-development`는 `scripts/...` 호출이 여섯 자리인데 기준을 한 자리에만 붙였다.

### 4. 규범 문서가 자기 규범을 어긴다

교차 패턴 중 가장 눈에 띈다.

`writing-for-junior`는 「제작 사정 누출」을 결함으로 정의하고 "형식 선택의 변호"를 그 대표 꼴로 표에 넣었다. 그 문서의 서두에 "작성과 판정을 한 문서에 두는 이유가 있다"로 시작하는 형식 변호가 있고, 32행에도 "아래 규범을 절차와 형태로 적은 이유가 이것이다"가 있다. 리뷰어는 둘 다 발견으로 냈다.

`finding-unknowns`의 「서술 규범」은 "개수·건수를 세어 적지 말고 개수에 기대지 않는 서술로 쓴다"를 규범으로 세운다. 같은 문서 본문이 "산출물은 네 종이다", "위 네 행은", "다음 세 행은", "마지막 행은"으로 지시한다.

`writing-skills`는 경로 규칙을 정하고 자기 블록에서 어긴다(위 3항).

개수 서술은 11개 문서에 걸쳐 나왔다. 항목을 하나 더하거나 빼면 함께 고쳐야 하는 문장이다. `finish`에서는 이미 낡았다. 핵심 원칙 줄이 단계를 여섯으로 재서술하는데 3단계 「base 브랜치 확인」이 빠져 있어, 그 줄을 로드맵으로 읽는 독자는 base 확인이 절차에 없는 것으로 본다.

### 5. 공유 조어와 미정의 용어

여러 문서가 같은 조어를 정의 없이 나눠 쓴다. 한 문서만 고쳐서는 닫히지 않는다.

- `하네스`: `using-groundwork`, `using-git-worktrees`가 미정의로 지적됐다. 표준 자료에서 harness는 test harness다. `writing-skills`는 같은 개념을 `런타임`이라는 다른 단어로 부르는데, 그 단어의 표준 뜻은 실행 환경이라 용어 오용으로 걸렸다. 같은 문서 안에서 "실행 시점 작업 디렉터리"라며 표준 뜻을 따로 쓰고 있어 충돌이 드러난다.
- `테스트 표면`: `executing-plan`, `writing-plans`. 통용 명칭이 없고 정의도 없다. 어떤 태스크가 여기 해당하는지 판정할 수 없다.
- `green 경계`: `plan-review`, `subagent-driven-development`. 후자에서는 "태스크가 강결합일 때의 유일한 행동 지시"라 여기서 실행이 멈춘다.
- `AC 레저`: `writing-plans`, `finding-unknowns`. `AC`가 어디서도 풀리지 않고 "레저"는 한국어에서 leisure 표기로 굳어 ledger 뜻이 잡히지 않는다. 둘 다 금지 규칙이라, 무엇을 금지당했는지 모르면 지킬 수도 어길 수도 없다.
- `표면`: `spec-review` 한 문서 안에서 세 뜻으로 돈다. 문서에 드러난 내용, 사용자와 맞닿는 접점, 인접 산출물이다.
- `축차`: `plan-review`, `spec-review`. 희소 어휘.

### 6. 셸 블록이 적힌 그대로 실행되지 않는다 (5개 문서 10건)

- `using-git-worktrees`: `path="$LOCATION/$BRANCH_NAME"`의 두 변수가 문서 어디에서도 대입되지 않는다. 블록만 떼어 실행하면 `git worktree add / -b ""`가 된다.
- `finish`: `GIT_DIR`, `GIT_COMMON`, `WORKTREE_PATH`를 2단계에서 대입하고 6단계에서 참조하는데 그 사이에 사용자 응답 대기가 낀다. 같은 셸이 유지된다는 전제가 없어, 블록마다 새 셸이면 `git worktree remove ""`가 실행된다.
- `receiving-code-review`: `gh api .../replies`를 답글 다는 명령으로 적었으나 필드 없는 `gh api`는 GET이라 답글이 달리지 않는다.
- `test-driven-development`: RED 확인 블록이 전부 `npm test`인데 사용자 프로젝트가 Node라는 전제가 없다. RED 확인은 "필수다, 건너뛰지 않는다"로 못박힌 단계라 Python이나 Go 프로젝트에서는 사이클 자체가 성립하지 않는다.

### 7. 제작 사정 누출 (5개 문서 8건)

`using-groundwork`의 「이 부트스트랩의 지위」 절 전체가 걸렸다. 플러그인 주입 메커니즘과 SessionStart 훅이라는 저자 환경을 전제하고, "이 본문이 컨텍스트에 없으면"의 회복 절차는 본문을 읽는 독자가 결코 놓일 수 없는 상태를 다룬다. 같은 문서의 PreToolUse 훅 문장도 특정 하네스 설정을 전제한다.

나머지는 `finding-unknowns`(플러그인 배포 사정), `finish`(다른 문서와의 정본 우선순위), `writing-for-junior`(형식 변호 2건), `writing-skills`(저자의 실측 경험, fork와 PR 운영 방식)다.

## 실측이 필요한 참조 3건

리뷰어가 리포에서 실체를 찾지 못한 참조다. 사용자 판단이 필요하다.

1. **`artifact-design`**: `finding-unknowns`의 게이트 절과 `writing-plans`의 「게재·승인」이 이 스킬을 로드하라고 지시한다. 두 리뷰어가 독립으로 `skills/` 아래에 없음을 확인했다. 다른 스킬 참조는 전부 `groundwork:` 접두를 쓰는데 이것만 접두가 없어 같은 플러그인 안인지 밖인지 갈린다. 하네스가 제공하는 스킬이라면 그 사실을 문서가 밝혀야 한다.
2. **`getting-started 스킬`**: `writing-skills`가 목표 단어 수 기준을 이 이름에 걸었다. 리포에 그런 스킬이 없다. 이 프로젝트의 진입 스킬은 `using-groundwork`다.
3. **`finish`의 "재리뷰"**: 7단계가 "종료 후 문서를 수정하면 재리뷰 대상이다"라고 하는데, 그 문서는 리뷰를 한 번도 언급하지 않는다. "재"의 기준이 되는 선행 리뷰가 문서 안에 없다.

## 처리

발견 184건을 문서별로 흩어 고치면 같은 결함이 다시 들어온다. 규약 층위에서 닫았다.

1. **실행 계약 4종을 채웠다.** 입력, 경로 기준, 주체, 출력이다. `writing-skills`에 이미 판정 축은 있었으나 스킬 19개가 지키지 않았다. 리뷰어가 결함으로 낸 자리마다 절을 신설했다.
2. **조어를 개명했다.** 어휘집을 만들지 않았다. 렌즈가 "재정의는 해소가 아니라 완화"이고 "통용 명칭이 있으면 조어를 만들지 않는다"고 규정하므로, 정의를 모으는 것은 처방과 반대 방향이다. superpowers 원문 대조 결과 문제 어휘는 두 갈래였다. `ledger`·`harness`·`runtime`·`acceptance criteria ledger`는 원문이 영어권 통용어인데 번역이 실패한 것이고, `테스트 표면`·`green 경계`·`표면`·`축차`는 groundwork가 새로 만든 조어다. 양쪽 다 통용 표현으로 바꿨다.
3. **경로 기준을 모든 해당 스킬에 못박았다.** `spec-review`·`plan-review`의 `${CLAUDE_PLUGIN_ROOT}` 규약을 표준으로 삼았고, 플러그인 안 파일과 프로젝트 산출물의 기준이 갈리는 문서는 둘 다 밝혔다.
4. **개수 서술을 제거했다.** 규칙으로 정한 개수("멈추는 이유는 셋뿐이다")는 항목이 늘어도 낡지 않으므로 남겼다.
5. **실측 3건을 닫았다.** `artifact-design`은 에이전트 실행 환경이 제공하는 스킬이라 그 정체를 한 줄로 붙였다. `getting-started`는 superpowers 원본에서도 실체가 없는 참조여서 "모든 세션에 주입되는 진입 스킬"이라는 성질 서술로 바꿨다. `finish`의 "재리뷰"는 `spec-review`·`plan-review`를 지목하도록 고쳤다.
6. **셸 블록을 고쳤다.** 네 건은 superpowers 원본에서 물려받은 결함이다. 변수 미대입(`$LOCATION`·`$BRANCH_NAME`), `gh api`의 기본 메서드가 GET인 문제, `npm test` 러너 고정, `check-ignore`의 `||` 판정이다. groundwork 고유 결함은 `finish`의 머지 명령이 문서 뒤쪽 `--ff-only` 규칙과 어긋난 것 하나였다.

## 판정이 잡지 않은 것

이 렌즈는 "문서만으로 성립하는가"만 본다. 설계의 좋고 나쁨, 규칙의 타당성, 내용의 수용 가능성은 판정 범위 밖이다. 판정 기준 없는 조건어("적절히", "주요")도 clarity와 completeness 렌즈 소관이라 여기서 빠졌다.

따라서 이 리포트의 FAIL 19건은 "스킬 19개가 틀렸다"는 뜻이 아니라 "맥락 없는 독자가 문서만으로 실행할 수 없다"는 뜻이다.
