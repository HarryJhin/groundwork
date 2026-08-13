---
created: 2026-07-25
status: closed
---

# 스펙: groundwork 스펙 파이프라인 재편 (S1)

## 용어

- **groundwork**: 이 repo. jjh의 설계·리뷰 flow를 담는 비공개 로컬 Claude Code 플러그인. 배포하지 않는다.
  현재 스킬 다섯(using-groundwork·finding-unknowns·critic-panel·implementation-plan·roster)과 리뷰어 에이전트 일곱(`agents/critic-*.md`)을 담는다.
- **superpowers**: obra(Jesse Vincent)의 MIT 라이선스 스킬 프레임워크. 로컬 경로 `~/Projects/superpowers`. groundwork가 구조·명칭의 기반으로 삼는 참조 원본이다.
- **하네스(harness)**: 스킬·서브에이전트를 실행하는 코딩 에이전트 런타임. 이 스펙의 지원 대상은 Claude Code와 Codex 둘이다.
- **선언형 서브에이전트**: 하네스별 정의 파일(Claude Code의 `agents/*.md`)로 `subagent_type`을 등록하는 방식. 정의 형식이 하네스마다 달라 이식성이 낮다.
- **템플릿형 서브에이전트**: 정의 파일 없이 범용 에이전트(`general-purpose`)에 프롬프트 텍스트를 주입하는 방식. 하네스 중립적이다.
- **lens**: 스펙·플랜을 검토하는 리뷰 축. 이 스펙이 재정의하는 목록은 「설계 · spec-review」에 있다.
- **flow**: 작업 진행 단계 사슬. groundwork 명칭으로 `bootstrap → finding-unknowns → spec-review → writing-plans → plan-review → executing-plan → test-driven-development → requesting-code-review → finish`. 이 중 `executing-plan`·`finish`는 superpowers 원본 스킬 `executing-plans`·`finishing-a-development-branch`의 groundwork 명칭이다.
- **안전 게이트**: 위험 작업을 차단하는 훅. `block-dangerous-git`·`block-sensitive-files`·`gateguard-destructive`. Claude Code 전용이다.
- **규율 게이트**: 에이전트 작업 규율을 강제하는 차단 훅. 크리틱 게이트 계열(구성·동작은 아래 「크리틱 게이트 동작」 참조), `artifact-number-gate`, `artifact-prose-gate`, `health-freshness-gate`.
- **크리틱 게이트 동작**(관여 훅 모두 `~/.claude/hooks/`): `mark-critic-pass.sh`가 리뷰어 서브에이전트의 `CRITIC_VERDICT` 토큰을 파싱해 `CRITIC_GATE_DIR`에 통과 상태를 기록하고, `mark-doc-write.sh`가 문서 저장을 `CRITIC_GATE_DIR`에 등록하며, `plan-file-gate.sh`가 그 상태를 스캔해 미통과 시 코드 편집을 차단한다.
  여기에 `critic-roster-reset.sh`가 로스터 누적을 리셋하고, `stale-spec-check.sh`가 `critic-gate` 상태 디렉터리를 GC한다.
  크리틱 게이트에 관여하는 훅은 이 다섯이다.

## 목표

groundwork를 superpowers 구조에 정렬하는 재편의 첫 조각이다.
S1은 flow 앞단(스펙 생산까지)과 그 기반을 재정의한다.

- **flow 앞단**: bootstrap(`using-groundwork`), `finding-unknowns`, `spec-review`.
- **기반**: 멀티하네스 배포(Claude Code + Codex), 템플릿형 서브에이전트, 산출물 규약, 규율 게이트 제거.

## 제외 범위 (non-goals)

- S2(`writing-plans` + `plan-review`), S3(`executing-plan` → `finish`)의 재편. 후속 스펙이 다룬다.
- superpowers flow 스킬(`writing-plans`·`executing-plans`·`test-driven-development`·`requesting-code-review`·`finishing-a-development-branch`)의 임베딩. S1은 `spec-review` 재료만 쓴다.
- Codex용 훅 제공. superpowers와 동일하게 Codex 배포에는 훅을 두지 않는다.
  부트스트랩 주입·안전 게이트는 Claude Code 전용 훅으로 남는다.
- `change-quiz` 스킬의 노트 참조 제거. 노트 폐지의 하류 정리는 후속으로 남긴다.
- Cursor·Kimi 등 다른 하네스 지원. 대상은 Claude Code·Codex 둘로 한정한다.
- `korean-writing` 플러그인 이관. 범용 한국어 글쓰기 도구라 groundwork 전용이 아니고, 사용자 지침(CLAUDE.md) 수준의 의존으로 남긴다.
- MIT 라이선스 고지 포함. groundwork는 비공개 기능이라 배포하지 않으므로, 임베딩한 superpowers 콘텐츠에 저작권·허가 고지를 넣지 않는다.
  이 비공개 전제가 깨져 외부 배포가 생기면 고지 의무가 되살아난다.

## unknowns 해소 상태

- **블라인드 스팟**: 해소됨. groundwork·superpowers·`~/.claude/hooks`를 실측해 크리틱 게이트 파급 표면과 superpowers 멀티하네스 구조를 확인했다.
- **역인터뷰**: 해소됨. 개명 깊이·게이트 제거 범위·서브에이전트 방식·산출물 규약·노트 폐지·lens 구성을 사용자 인터뷰로 확정했다.
- **레퍼런스**: 해소됨. superpowers가 구조 기반이다.
  임베딩 대상은 `~/Projects/superpowers/skills/`의 flow 스킬이고, 이를 한국어로 번역해 groundwork `skills/`에 둔다.
- **프로토타이핑**: 해당없음. 시각 산출물이 없다.
- **스파이크**: 해당없음. 위험 가정을 실측 도구로 이미 확인해 throwaway 검증이 불필요했다.

## 인터뷰 요약

사용자가 groundwork를 superpowers 기반으로 재편하려 한다.
확정한 방향은 다음과 같다.

1. flow를 superpowers 명칭 사슬로 재편하고 "크리틱" 표기를 "리뷰"로 바꾼다.
2. superpowers flow 스킬을 가리키지 않고 한국어로 번역해 임베딩한다(self-contained).
3. 서브에이전트는 템플릿형으로 간다.
   근거는 Claude Code·Codex 두 하네스 지원이고, 이는 superpowers가 템플릿형을 택한 이유와 같다.
4. Codex 지원은 superpowers와 동일한 수준이다.
   `skills/`만 공유하고 훅은 Claude Code 전용으로 남긴다.
5. 규율 하드 게이트를 제거한다.
   안전 게이트만 남긴다.
6. 노트 산출물을 폐지한다.
   구현 판단은 코드 주석이나 프로젝트 ADR로 간다.
7. 라이선스는 비공개 전제 아래 고지하지 않는다.
8. spec-review lens는 junior-read + superpowers 5축을 기본으로 하고, 기존 lens(experience·facts·crossref·intent)를 재량으로 둔다.
9. finding-unknowns의 조사 3종은 서브에이전트로 병렬 디스패치하고, 역인터뷰·프로토타이핑은 성격이 달라(사전 조사 대 사용자 상호작용) 메인이 전담한다.

## 검증된 가정

- superpowers는 MIT 라이선스다(Copyright © 2025 Jesse Vincent).
  근거: `~/Projects/superpowers/LICENSE` 실측.
- superpowers는 서브에이전트를 정의 파일로 선언하지 않는다.
  `agents/` 디렉터리가 없고, 서브에이전트는 skills 안 프롬프트 템플릿으로 존재한다.
  근거: `.claude-plugin`·`.codex-plugin`·`.cursor-plugin` 실측.
- Claude Code는 `skills/`를 자동 발견하므로 `.claude-plugin/plugin.json`에 skills 포인터가 필요 없다.
  `.codex-plugin`·`.cursor-plugin`·`.kimi-plugin`만 `"skills":"./skills/"`를 명시한다.
  근거: superpowers 4개 하네스 매니페스트 실측.
- superpowers Codex 배포는 훅을 두지 않는다.
  `.codex-plugin/plugin.json`이 `"hooks":{}`이고, SessionStart 배선은 top-level `hooks/hooks.json`(Claude Code 전용)에만 있다.
  근거: 실측.
- 크리틱 게이트에서 `CRITIC_VERDICT`를 파싱하는 훅은 `mark-critic-pass.sh` 하나다.
  `mark-doc-write.sh`는 `CRITIC_GATE_DIR`만 참조하고, `stale-spec-check.sh`는 두 토큰 어느 것도 참조하지 않은 채 `critic-gate` 상태 디렉터리를 GC한다.
  근거: 세 훅 실측.
- 안전 게이트 3종은 규율과 무관한 위험 차단이다.
  근거: `exit 2` 훅 역할 실측.

## 설계

### 배포 구조 (멀티하네스)

- `skills/` 하나를 Claude Code와 Codex가 공유한다.
- 하네스별 매니페스트를 둔다.
  `.claude-plugin/plugin.json`(기존, skills 자동 발견이라 포인터 없음)과 `.codex-plugin/plugin.json`(신규, `"skills":"./skills/"` 명시).
- 훅은 Claude Code 전용이다.
  Codex 배포는 훅을 두지 않는다(`hooks:{}`).
  그 결과 Codex에서 부트스트랩(`using-groundwork`)은 스킬 형태라 스킬 노출로 실린다.
  반면 안전 게이트는 스킬 형태가 없어 Codex에서 대체 수단 없이 부재한다.
  이는 superpowers와 같은 수준의 Codex 지원이고, Codex 코드 작업에 안전 게이트 커버리지가 없다는 한계를 수반한다.
- `agents/` 디렉터리를 폐지한다.
  기존 `agents/critic-*.md` 일곱은 템플릿 프롬프트로 이전한다.

### 서브에이전트 = 템플릿형

- 프롬프트 템플릿을 스킬 디렉터리 안 `*-prompt.md`로 둔다.
  메인이 `general-purpose` 에이전트에 이 텍스트를 주입해 디스패치한다.
- 도구 격리를 프롬프트 지시로 대체한다(예: "Read·Glob·Grep만 사용").
  선언형의 `tools:` 프론트매터 강제는 하네스 중립성과 맞바꾼다.

### bootstrap (`using-groundwork` 개편)

- flow 사슬을 위 아홉 단계로 갱신하고 "크리틱" 표기를 "리뷰"로 바꾼다.
- S1이 짓는 단계는 `bootstrap`·`finding-unknowns`·`spec-review` 셋뿐이다.
  `writing-plans` 이후 단계는 S1 시점에 미구축이다.
  bootstrap은 이 단계들을 flow 사슬에 싣되 "S2·S3에서 구축"으로 표시하고, 그때까지는 기존 `implementation-plan` 스킬로 대체한다고 명시한다.
- 지원 하네스가 Claude Code·Codex 둘임을 명시한다.

### finding-unknowns 개편

- 조사 3종을 템플릿형 프롬프트로 추가한다: `blindspot`(블라인드 스팟 패스), `reference`(참조 대조), `spike`(위험 가정 검증). 메인이 병렬 디스패치한다.
- 역인터뷰와 프로토타이핑은 메인이 전담한다.
  근거는 두 가지다.
  서브에이전트는 사용자와 상호작용할 수 없다.
  그리고 사전 조사와 사용자 대면 활동은 성격이 달라 같은 디스패치 묶음에 들지 않는다.

### spec-review (`critic-panel` 개편)

- 명칭을 `critic-panel`에서 `spec-review`로 바꾼다.
- lens를 재구성한다.
  기본(필수)은 여섯이다: `junior-read`(자기완결·신참 판독, 기존 coldreader), `completeness`(완전성), `consistency`(일관성), `clarity`(명확성), `scope`(범위), `yagni`(과잉설계). 뒤 다섯은 superpowers 사양서 리뷰어의 점검 축이다.
  재량(roster가 문서 표면을 보고 추가)은 넷이다: `experience`(UI/UX), `facts`(외부 사실 주장), `crossref`(형제·하류 정합), `intent`(사용자 의도 정합).
- superpowers 사양서 리뷰어는 기본 5축으로 흡수되므로 별도 리뷰어로 두지 않는다.
- 각 lens를 템플릿형 프롬프트로 두고 메인이 병렬 디스패치한다.
  리뷰어 프롬프트는 read-only 도구(`Read`·`Glob`·`Grep`, facts·crossref는 실측 도구 추가)만 쓰도록 지시하고, 출력 마지막 줄에 판정 토큰 `REVIEW_VERDICT: PASS|FAIL`을 낸다.
  이 토큰은 메인이 읽는 리뷰어 출력 계약이라 게이트 훅이 파싱하던 `CRITIC_VERDICT`(게이트째 삭제)와 별개다.
- 코멘트 수렴 루프를 유지하되 하드 게이트 없이 스킬 안내로 돌린다.
  종료 조건은 전 리뷰어 PASS와 코멘트 닫힘이고, 판정 주체는 메인 에이전트다(훅이 강제하지 않는다).

### roster 개편

- `roster` 스킬은 존치한다.
  spec-review가 문서 표면을 보고 재량 lens를 고르는 선정 로직이 여전히 필요하다.
- 필수·재량 목록을 위 lens 재구성으로 갱신한다.
  필수 = 기본 6, 재량 = experience·facts·crossref·intent. 기존 `~/.claude/hooks/plan-file-gate.sh`의 `REQ` 참조는 게이트 제거로 사라지므로, 필수 집합의 정본을 roster 스킬 본문으로 옮긴다.

### 산출물 규약 (self-contained)

산출물 네 종이다.
규약을 groundwork 스킬 본문에 담아 전역 `~/.claude/rules/artifacts.md` 의존을 끊는다.

| 타입 | 위치 | 명명 | 커밋 |
|------|------|------|------|
| 스펙 | `docs/specs/` | `SPEC-NNNN-<topic>.md` | 정규 커밋 |
| 플랜 | `docs/plans/` | `PLAN-NNNN-<topic>.md` | 정규 커밋 |
| ADR | `docs/adr/` | `ADR-NNNN-<slug>.md` | 정규 커밋 |
| 아티팩트 | `.claude/artifacts/` | `ARTIFACT-NNNN-<review\|proto>.<ext>` | 커밋 금지 |

- 번호는 4자리다.
  스펙과 플랜이 같은 번호를 공유한다(페어).
- 아티팩트는 대응 스펙의 번호를 공유하고, 용도 접미로 승인 요약(`review`)과 프로토타입(`proto`)을 구분한다.
  한 스펙에 둘 다 필요하면 접미로 갈린다.
- 노트를 폐지한다.
  구현 중 판단은 코드 주석(코드가 설명하는 것)이나 프로젝트 ADR(결정이 중요한 것)로 간다.
- **리뷰 루프 규약**: spec-review의 코멘트 수렴 루프가 쓰는 코멘트 파일·사이드카·status 규약도 groundwork 규약에 담는다.
  코멘트 파일은 대상 문서와 같은 디렉터리에 `<basename>.T<n>.comment.md`로 두고(T번호 문서당 단조 증가), status는 `open → answered → reviewed | re-opened` 네 값을 쓴다.
  인덱스 사이드카는 `<basename>.critique.md`다.
  이 규약을 담지 않으면 self-contained가 깨진다.

### 글쓰기 규범 스킬 이관

- `writing-clearly-and-concisely`를 `~/.claude/skills/`에서 groundwork `skills/`로 **복사**한다(원본 유지).
  스펙·플랜 작성이 이 스킬 규범에 의존하므로 사본을 품는다.
  복사 후 groundwork flow는 사본을 참조한다.
  전역 원본은 다른 프로젝트가 계속 쓰므로 삭제하지 않는다.
  사본과 원본은 시간이 지나며 갈릴 수 있고, groundwork 안에서는 사본이 정본이다.

### 규율 게이트 제거

- 파일 통째 삭제: `mark-critic-pass.sh`, `critic-roster-reset.sh`, `mark-doc-write.sh`(등록 로직이 페이로드 전부라 no-op 대신 삭제), `artifact-number-gate.sh`, `artifact-prose-gate.sh`, `health-freshness-gate.sh`.
- 부분 편집: `plan-file-gate.sh`의 크리틱 게이트 블록만 제거한다(이 훅에는 크리틱과 무관한 부분이 남아 파일을 삭제하지 않는다).
- `~/.claude/settings.json`의 해당 배선을 제거한다.
- 유지: 안전 게이트 3종(`block-dangerous-git`·`block-sensitive-files`·`gateguard-destructive`).

## 호환성·마이그레이션

- `agents/critic-*.md` 일곱의 처리는 1:1로 다음과 같다.
  `coldreader`는 기본 `junior-read` 프롬프트로 이전한다.
  `intent`·`facts`·`crossref`·`experience`는 각각 동명 재량 lens 프롬프트로 이전한다.
  `gaps`·`consistency`는 폐기한다(역할이 기본 5축에 흡수된다).
  이전·폐기를 마친 뒤 `agents/` 디렉터리를 삭제한다.
- 기본 5축(`completeness`·`consistency`·`clarity`·`scope`·`yagni`) 프롬프트는 기존 에이전트를 refactor하지 않고 superpowers 사양서 리뷰어를 한국어로 번역해 신규 작성한다.
- 위 「규율 게이트 제거」의 삭제·부분편집 대상을 그대로 적용하고 `~/.claude/settings.json` 배선을 제거한다.
  이는 groundwork repo 밖 전역 변경이라 되돌리기 전 사용자 확인을 받는다.
- 크리틱 게이트 제거로 `CRITIC_VERDICT`·`CRITIC_GATE_DIR`가 소멸한다.
  이때 정리 대상은 실측 귀속대로다: `mark-critic-pass.sh`(토큰 파싱, 통째 삭제), `mark-doc-write.sh`(등록 로직이 페이로드 전부라 통째 삭제 + PostToolUse Edit·Write 배선 제거), `stale-spec-check.sh`(`critic-gate` 디렉터리 GC 라인 제거).
- 기존 산출물 경로(`.claude/specs`·`.claude/plans` 등)를 `docs/` 규약으로 옮긴다.
  이 경로를 참조하던 스킬 본문을 갱신한다.
- `~/.claude/skills/writing-clearly-and-concisely`를 `skills/`로 복사한다(원본 유지).
- flow 하류 단계는 S1 시점에 미구축이다.
  bootstrap의 flow 사슬에서 `writing-plans` 이후를 "S2·S3 구축 예정, 그때까지 `implementation-plan` 대체"로 표기한다.

## 기각된 대안

- **선언형 서브에이전트 유지**: `agents/*.md`는 Claude Code 전용이라 Codex에서 작동하지 않는다.
  멀티하네스 요구로 기각했다.
  superpowers도 같은 이유로 선언형을 쓰지 않는다.
- **크리틱→리뷰 내부 토큰 전면 개명**: 게이트 훅이 파싱하던 `CRITIC_VERDICT`·`CRITIC_GATE_DIR`는 게이트째 삭제되어 재작성이 불필요하다.
  다만 spec-review 리뷰어 프롬프트의 출력 판정 토큰은 메인이 읽는 사용자 대면 계약이라 `REVIEW_VERDICT`로 표기를 맞춘다(게이트 훅 토큰과 구별).
- **노트 산출물 유지**: 노트는 코드 주석과 ADR 사이의 애매한 중간층이고, 담긴 항목 대부분이 코드 주석이나 ADR로 재분류된다.
  폐지했다.
- **게이트 완화(차단 → 권고)**: 규율 게이트 자체를 불필요로 판단해 완화가 아니라 제거를 택했다.
  안전 게이트는 성격이 달라 남긴다.
- **superpowers 사양서 리뷰어를 별도 lens로 추가**: 사양서 리뷰어의 5범주(completeness·consistency·clarity·scope·yagni)를 기본 lens로 직접 채택하므로 별도 리뷰어가 중복이다.
  기각했다.
- **기존 lens(facts·crossref·intent) 폐기**: 이번 스펙 리뷰에서 facts가 훅 귀속 오류를, crossref가 Codex 부트스트랩 누락을, intent가 요청 해석 gap을 잡아 실효를 보였다.
  폐기 대신 재량 lens로 남긴다.
