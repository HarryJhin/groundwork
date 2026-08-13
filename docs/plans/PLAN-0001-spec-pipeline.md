---
created: 2026-07-25
status: closed
---

# 플랜: groundwork 스펙 파이프라인 재편 (S1)

## Goal

groundwork를 superpowers(정렬 기준으로 삼는 형제 플러그인 리포, `~/Projects/superpowers/`)의 구조에 정렬하는 재편의 첫 조각(S1)을 구현한다.
flow 앞단(bootstrap·finding-unknowns·spec-review)과 그 기반(멀티하네스 배포·템플릿형 서브에이전트·산출물 규약·규율 게이트 제거)을 짓는다.
대응 스펙: `docs/specs/SPEC-0001-spec-pipeline.md`.

이 repo에는 빌드·테스트 인프라가 없다.
산출물은 스킬(`skills/*/SKILL.md`)·프롬프트 템플릿(`skills/*/*-prompt.md`)·훅(bash)·매니페스트(json)다.
태스크 경계의 "green"은 다음으로 정의한다: 스킬 프론트매터가 유효(`name`·`description` 존재)하고 프롬프트 파일이 존재하며 json이 `jq`로 파싱되고 훅이 `bash -n`으로 문법 통과한다.

## Global Constraints (스펙 verbatim)

- 지원 하네스는 Claude Code와 Codex 둘이다.
  `skills/` 하나를 공유하고 훅은 Claude Code 전용이다(Codex 배포는 `hooks:{}`).
- 서브에이전트는 템플릿형이다.
  정의 파일(`agents/`) 대신 `general-purpose`에 주입하는 프롬프트 템플릿(`*-prompt.md`)으로 둔다.
  도구 격리는 프롬프트 지시로 대체한다(예: "Read·Glob·Grep만 사용").
- "크리틱" 표기를 "리뷰"로 바꾼다(사용자 대면 표기만).
  게이트 훅이 파싱하던 내부 토큰은 게이트째 삭제로 소멸한다.
  spec-review 리뷰어 프롬프트의 출력 판정 토큰은 `REVIEW_VERDICT`로 맞춘다.
- spec-review lens: 기본 6 = `junior-read`·`completeness`·`consistency`·`clarity`·`scope`·`yagni`. 재량 4 = `experience`·`facts`·`crossref`·`intent`. 기본 5축(junior-read 제외)은 superpowers 사양서 리뷰어를 번역해 신규 작성한다.
- 규율 게이트를 제거하고 안전 게이트 3종은 유지한다.
  전역 훅 변경은 되돌리기 전 사용자 확인을 받는다.
- 산출물 4종: 스펙 `docs/specs/SPEC-NNNN-<topic>.md`, 플랜 `docs/plans/PLAN-NNNN-<topic>.md`, ADR `docs/adr/ADR-NNNN-<slug>.md`, 아티팩트 `.claude/artifacts/ARTIFACT-NNNN-<review|proto>.<ext>`. 번호 4자리, 스펙·플랜 페어 번호 공유. 노트는 폐지.
- `korean-writing`은 이관하지 않는다.
  비공개 전제 아래 MIT 고지를 넣지 않는다.

## 공통 완료 기준 (통합 종료 불변식, T7 이후)

다음은 개명이 끝나는 T7 이후에 전역으로 참이어야 하는 통합 종료 불변식이다.
개별 태스크 green이 아니라 플랜 최종 검증이다.
각 태스크의 green은 자기 실행 검증 커맨드로 판정하고 그 grep 범위는 태스크가 소유한 디렉터리로 한정한다(초기 태스크가 미착수 스킬의 잔존 탓에 오판되지 않도록).

- `! grep -rniq 'critic-panel' skills/` (spec-review로 개명 완료)
- `! grep -rniq '크리틱' skills/` (리뷰로 표기 전환 완료)
- `! grep -rq 'rules/artifacts.md' skills/` (전역 규약 `~/.claude/rules/artifacts.md`(산출물·서술 규약 정본) 의존 제거)
- `! grep -rqE '\.claude/(specs|plans|notes)' skills/` (docs/ 규약 전환, notes 폐지)

## 태스크

### T1 · 멀티하네스 매니페스트

- **Files**
  - 신규 `.codex-plugin/plugin.json`: superpowers `.codex-plugin/plugin.json`을 본떠 `name`·`version`·`description`·`"skills":"./skills/"`·`"hooks":{}`. `interface` 블록은 생략(선택).
  - 변경 없음 `.claude-plugin/plugin.json`: skills 자동 발견이라 포인터 불요.
    현행 유지 확인.
- **실행 검증**: `jq . .codex-plugin/plugin.json` · `jq -e '.skills=="./skills/" and (.hooks|length==0)' .codex-plugin/plugin.json`
- **의존**: 없음

### T2 · spec-review 리뷰어 프롬프트 (lens 10종)

`agents/critic-*.md` 일곱을 lens 재구성에 맞춰 `skills/spec-review/` 프롬프트 템플릿으로 이전·신규 작성한다.
각 프롬프트는 `general-purpose` 대상이며 다음을 반드시 담는다: (a) read-only 도구 격리 지시("Read·Glob·Grep만 사용", facts·crossref는 실측 도구 추가 허용), (b) 출력 마지막 줄 `REVIEW_VERDICT: PASS|FAIL`, (c) 판정 근거를 문서·리포·일반지식으로 한정(전역 `artifacts.md` 참조 금지, 필요한 규범은 프롬프트에 내재화).

- **Files** (모두 `skills/spec-review/`)
  - 신규 `junior-read-prompt.md`: `agents/critic-coldreader.md` 본문 이전(자기완결 판독 축), `artifacts.md` 참조는 자체 규범으로 대체.
  - 신규 `completeness-prompt.md`·`consistency-prompt.md`·`clarity-prompt.md`·`scope-prompt.md`·`yagni-prompt.md`: `~/Projects/superpowers/skills/brainstorming/spec-document-reviewer-prompt.md`의 5범주를 축별로 분리해 한국어 신규 작성.
  - 신규 `experience-prompt.md`·`facts-prompt.md`·`crossref-prompt.md`·`intent-prompt.md`: `agents/critic-experience.md`·`critic-facts.md`·`critic-crossref.md`·`critic-intent.md` 본문 이전, `CRITIC_VERDICT`→`REVIEW_VERDICT` 및 `artifacts.md` 참조 대체.
  - 삭제 `agents/critic-coldreader.md`·`critic-experience.md`·`critic-facts.md`·`critic-crossref.md`·`critic-intent.md`(이전 소스 5), `agents/critic-gaps.md`·`critic-consistency.md`(역할 흡수로 폐기 2).
- **실행 검증**: `ls skills/spec-review/*-prompt.md | wc -l` (10) · `grep -L 'REVIEW_VERDICT' skills/spec-review/*-prompt.md` (빈) · `! grep -rq 'CRITIC_VERDICT' skills/spec-review/` · `! grep -rq 'rules/artifacts.md' skills/spec-review/` · `grep -L 'Read' skills/spec-review/*-prompt.md` (빈 출력, 전 프롬프트에 도구 지시 존재)
- **의존**: 없음

### T3 · spec-review 스킬

- **Files**
  - 신규 `skills/spec-review/SKILL.md`: `skills/critic-panel/SKILL.md`의 코멘트 루프 워크플로우 이전. (a) `name: spec-review`, (b) 리뷰어를 `general-purpose` + 프롬프트 템플릿 주입으로 디스패치(구 `subagent_type` 제거), (c) 하드 게이트 참조 제거, 종료 판정은 메인이 전 리뷰어 `REVIEW_VERDICT: PASS` + 코멘트 닫힘으로, (d) 코멘트 파일 규약(`<basename>.T<n>.comment.md`, status 4값 `open→answered→reviewed|re-opened`, 사이드카 `<basename>.critique.md`) 자체 명시.
  - 삭제 `skills/critic-panel/` 디렉터리(내용물 SKILL.md 하나).
- **실행 검증**: `grep -q '^name: spec-review' skills/spec-review/SKILL.md` · `! test -e skills/critic-panel` · `! grep -rqE 'critic-roster-reset|mark-critic-pass|CRITIC_VERDICT|SPEC_CRITIC_OFF' skills/spec-review/` (삭제될 훅·게이트 토큰 잔존 금지)
- **의존**: T2, T4

### T4 · roster 개편

- **Files**
  - 변경 `skills/roster/SKILL.md`: 필수 = `junior-read`·`completeness`·`consistency`·`clarity`·`scope`·`yagni`, 재량 = `experience`·`facts`·`crossref`·`intent`로 목록 갱신. `plan-file-gate.sh`의 `REQ` 참조 문장 삭제(필수 정본을 본문 선언). `critic-panel`→`spec-review`, "크리틱"→"리뷰" 표기 개명. 예시 반환의 구 lens명(`coldreader gaps intent …`)을 새 lens명으로 갱신.
- **실행 검증**: `grep -q 'junior-read' skills/roster/SKILL.md` · `! grep -q 'plan-file-gate' skills/roster/SKILL.md` · `! grep -rniqE 'critic-panel|크리틱' skills/roster/`
- **의존**: 없음

### T5 · finding-unknowns 조사 프롬프트 · 경로·번호 규약

- **Files**
  - 신규 `skills/finding-unknowns/blindspot-prompt.md`·`reference-prompt.md`·`spike-prompt.md`: 각 조사 기법을 `general-purpose`에 주입할 프롬프트(입력·출력·도구 지시 포함).
  - 변경 `skills/finding-unknowns/SKILL.md`: 조사 3종 병렬 디스패치 명시, 역인터뷰·프로토타이핑은 메인 전담 서술. 산출물 경로를 `docs/specs/SPEC-NNNN-<topic>.md`로 갱신. **번호 예약 스캔 대상 디렉터리에서 `.claude/notes` 제거**하고 `docs/specs`·`docs/plans`·`docs/adr`·`.claude/artifacts` 기준으로 개편. "크리틱"→"리뷰" 표기와 `groundwork:critic-panel` 핸드오프를 `spec-review`로 개명한다(새 flow에서 finding-unknowns가 spec-review로 직접 넘긴다).
- **실행 검증**: `ls skills/finding-unknowns/*-prompt.md | wc -l` (3) · `grep -q 'docs/specs/SPEC-' skills/finding-unknowns/SKILL.md` · `! grep -q 'notes' skills/finding-unknowns/SKILL.md`
- **의존**: 없음

### T6 · bootstrap 개편

- **Files**
  - 변경 `skills/using-groundwork/SKILL.md`: flow 사슬을 9단계로 갱신, "크리틱"→"리뷰" 표기, `critic-panel`→`spec-review`. S1 3단계 + `writing-plans` 이후 "S2·S3 구축 예정, 그때까지 `implementation-plan` 대체" 표기. 지원 하네스 Claude Code·Codex 명시. **구 7 lens 열거를 새 lens(기본 6 + 재량 4)로 갱신**, `.claude/notes`·`rules/artifacts.md` 참조 제거. 리뷰어 디스패치 서술을 `general-purpose` + 프롬프트 템플릿 주입 방식으로 교체한다(구 `subagent_type`·`groundwork:critic-<lens>` 프레이밍 제거).
- **실행 검증**: `grep -q 'spec-review' skills/using-groundwork/SKILL.md` · `! grep -rniqE 'critic-panel|크리틱|groundwork:critic-' skills/using-groundwork/`
- **의존**: T3, T5

### T7 · 산출물 규약 내재화 · 글쓰기 스킬 복사 · 잔존 개명

- **Files**
  - 변경 `skills/finding-unknowns/SKILL.md`·`skills/implementation-plan/SKILL.md`·`skills/spec-review/SKILL.md`: 산출물 경로·명명을 `docs/` 4자리 규약으로 갱신. `implementation-plan`은 `critic-panel`→`spec-review` 및 "크리틱"→"리뷰" 개명 포함. `rules/artifacts.md` 참조를 자체 규약으로 대체.
  - 변경(규약 정본 소재 지정) `skills/using-groundwork/SKILL.md`: 산출물 규약 4종 전체(스펙·플랜·ADR·아티팩트의 경로·명명, 4자리 번호, 스펙·플랜 페어 공유, `docs/` 커밋·아티팩트 커밋금지)를 bootstrap 본문의 산출물 규약 절로 담는다(전역 `artifacts.md` 대체 정본).
  - 신규 `skills/writing-clearly-and-concisely/`: `~/.claude/skills/writing-clearly-and-concisely/` 복사(원본 유지). 사본이 groundwork 내 정본.
- **실행 검증**: `test -f skills/writing-clearly-and-concisely/SKILL.md` · `grep -q 'ADR-NNNN' skills/using-groundwork/SKILL.md` · `grep -q 'ARTIFACT-NNNN' skills/using-groundwork/SKILL.md` · 통합 종료 불변식 전부(T7이 마지막 개명이라 이 시점 전역 참): `! grep -rniq 'critic-panel' skills/` · `! grep -rniq '크리틱' skills/` · `! grep -rq 'rules/artifacts.md' skills/` · `! grep -rqE '\.claude/(specs|plans|notes)' skills/`
- **의존**: T3, T5, T6

### T8 · 규율 게이트 제거 (전역, 사용자 확인)

`~/.claude/` 전역을 바꾸는 비가역 변경이다.
착수 전 사용자 확인을 받는다.

- **Files**
  - 삭제 `~/.claude/hooks/`: `mark-critic-pass.sh`·`critic-roster-reset.sh`·`artifact-number-gate.sh`·`artifact-prose-gate.sh`·`health-freshness-gate.sh`·**`mark-doc-write.sh`**(등록 로직이 페이로드 전부라 no-op 대신 삭제).
  - 삭제 `~/.claude/hooks/test/`: `test-artifact-number-gate.sh`·`test-artifact-prose-gate.sh`·`test-health-gate.sh`(삭제되는 게이트 훅의 전용 테스트라 함께 소멸, 이관 불요).
  - 이관 후 삭제 `~/.claude/hooks/test/test-critic-gate.sh`: 이 파일의 안전 게이트(`block-dangerous-git`) 서브테스트는 유지 대상 커버리지다.
    신설 `~/.claude/hooks/test/test-block-dangerous-git.sh`로 그 서브테스트를 이관해 회귀 그물을 보존한 뒤 원본을 삭제한다.
  - 이관 후 삭제 `~/.claude/hooks/test/test-critic-scope.sh`: 삭제 훅 `mark-doc-write` 참조로 red가 되나, 존치 훅 `stale-spec-check.sh`의 회귀 서브테스트(closed 미경고·active 경고·stale 경고)도 담는다.
    그 stale 서브테스트를 신설 `~/.claude/hooks/test/test-stale-spec-check.sh`로 이관해 커버리지를 보존한 뒤 원본을 삭제한다.
  - 부분 편집 `~/.claude/hooks/plan-file-gate.sh`(크리틱 게이트 블록 제거 + 잔존 plan 권고 메시지의 "크리틱"→"리뷰" 표기 갱신)·`stale-spec-check.sh`(`critic-gate` GC 라인 제거)·`lib/hook-common.sh`(`CRITIC_GATE_DIR` 정의 제거, 다른 헬퍼는 잔존 훅이 쓰므로 유지)·`test/test-plan-file-gate.sh`(크리틱 케이스가 있으면 정리).
  - 변경 `~/.claude/settings.json`: 삭제 훅의 배선 제거 + `mark-doc-write.sh`의 PostToolUse `Edit`·`Write` 두 배선 제거.
- **실행 검증**: `make -C ~/.claude/hooks test` (green) · `bash -n ~/.claude/hooks/plan-file-gate.sh` · `jq . ~/.claude/settings.json` · `! test -e ~/.claude/hooks/mark-critic-pass.sh` · `! test -e ~/.claude/hooks/mark-doc-write.sh`
- **의존**: 전 태스크(T1~T7·T9) 뒤. 착수 전 사용자 확인 필수.

### T9 · agents 디렉터리 정리

- **Files**: 삭제 `agents/` 디렉터리(critic-* 7종이 T2에서 이전·삭제된 뒤 빈 디렉터리).
- **실행 검증**: `! test -e agents`
- **의존**: T2

## 의존 순서 요약

```
T1 ─────────────────────────────────────┐
T2 ─┬─→ T3 ─┐                            │
T4 ─┘       ├─→ T6 ─→ T7 ─┐              ├─→ T8 (사용자 확인, 전 태스크 종점)
T5 ─────────┘             │              │
T2 ─→ T9 ─────────────────┴──────────────┘
```
- T3은 T2(프롬프트)와 T4(roster lens)를 소비한다.
- T6은 T3·T5를 소비한다.
  T7은 T3·T5·T6을 소비한다.
- T8은 모든 브랜치의 공통 종점이다(T1·T7·T9 포함 전 태스크 뒤).
