# 플랜 예시

위 「플랜 문서 형식」이 정한 구성을 실제 사례로 보인다.
아래 구분선 다음이 플랜 전문이다.
이 리포에서 실제로 있었던 작업을 그 형식으로 옮겼다.

대응 스펙 예시가 `groundwork:finding-unknowns`의 `example-spec.md`에 있다.
같은 작업이라 스펙의 결정이 태스크로 어떻게 갈라지는지 나란히 볼 수 있다.

무엇을 보라는 것인지 짚어 둔다.
Files가 신규·변경·삭제를 심볼 단위로 표시한다.
Interfaces의 Produces가 뒤 태스크에 도달하는 유일한 경로다.
실행 검증이 그 태스크의 산출물을 실제로 판정한다.
이 리포처럼 테스트 인프라가 없으면 Goal에서 green을 직접 정의한다.

---

```yaml
---
created: 2026-08-04
---
```

# 플랜: 인터뷰를 추출에서 grounding으로 전환

`finding-unknowns`의 조사 발동에서 저자 판정을 없애고 인터뷰를 묻기와 돌려주기의 순환으로 바꾼다.
대응 스펙: `docs/specs/SPEC-0002-interview-grounding.md`.

이 repo에는 빌드·테스트 인프라가 없다.
산출물은 스킬(`skills/*/SKILL.md`)·프롬프트 템플릿(`skills/*/*-prompt.md`)·근거 문서(`skills/*/references/*.md`)다.
태스크 경계의 "green"은 다음 3가지가 모두 참인 상태로 정의한다.

- 스킬 프론트매터에 `name`과 `description`이 있다
- 그 태스크가 만들기로 한 파일이 실재한다
- 그 태스크가 건드린 문서의 상대 경로 참조가 모두 실재 파일을 가리킨다

## Global Constraints (스펙 verbatim)

- 조사 3종(블라인드 스팟·레퍼런스·스파이크)은 조건 판정 없이 모든 스펙에서 디스패치한다.
- 조사원은 대상을 스스로 찾는다.
  저자가 참조 위치나 검증할 가정을 모르는 상태로도 디스패치할 수 있어야 한다.
- 빈 결과는 실패가 아니다.
  조사원은 훑은 범위와 함께 "없음"을 반환한다.
- 인터뷰는 0문항으로 끝내지 않는다.
- 스펙 본문은 제작 과정을 담지 않는다.
  조사·인터뷰 이력을 적는 절을 새로 만들지 않는다.

## 공통 완료 기준

플랜 최종 검증이다.
개별 태스크 green이 아니라 T4 이후 전역으로 참이어야 한다.

- `! grep -rq '강제 아님' skills/finding-unknowns/` (조사 절의 면제 문구 제거)
- `! grep -rq '「인터뷰 요약」' skills/` (스펙에 인터뷰 전용 절을 두지 않음)
- 모든 `references/*.md` 링크가 실재 파일을 가리킨다

## 태스크

### Task 1: 조사원 프롬프트 입력 계약 완화

프롬프트 3종이 저자만 알 수 있는 값을 필수 입력으로 요구해 디스패치를 막고 있다.
후보 탐색과 가정 식별을 조사원의 첫 절차로 옮긴다.

- **Files** (모두 `skills/finding-unknowns/`)
  - 변경 `reference-prompt.md`: 「입력」에서 참조 실체 위치를 선택으로 내리고 「절차」 1번에 후보 탐색 추가.
    「출력」에 `REFERENCE_FOUND: 없음` + `SEARCHED` 경로 추가
  - 변경 `spike-prompt.md`: 「입력」에서 검증할 가정을 선택으로 내리고 「절차」 1번에 가정 식별 추가.
    「출력」에 `ASSUMPTIONS_FOUND: 없음` + `SCANNED`, `DEFERRED` 경로 추가
  - 변경 `blindspot-prompt.md`: 도입부와 역할 문장에서 "낯선 코드·도메인이면" 조건 삭제. "전수 발굴"을 훑은 범위 반환으로 낮춤
- **Interfaces**
  - Produces: 조사원 반환 토큰 `REFERENCE_FOUND`·`SEARCHED`·`ASSUMPTIONS_FOUND`·`SCANNED`·`DEFERRED`. Task 2가 본문에서 이 토큰들을 빈 결과의 근거로 지목한다
- **실행 검증**: `grep -q 'REFERENCE_FOUND: 없음' skills/finding-unknowns/reference-prompt.md` · `grep -q 'ASSUMPTIONS_FOUND: 없음' skills/finding-unknowns/spike-prompt.md` · `! grep -q '전수 발굴' skills/finding-unknowns/blindspot-prompt.md`
- **의존**: 없음

### Task 2: 기법 절을 무조건 발동으로 전환

- **Files**
  - 변경 `skills/finding-unknowns/SKILL.md`: 「기법」 절 제목에서 "순서·전부 강제 아님" 삭제. 조건 판정이 성립하지 않는 이유(찾기 전에는 없어 보임)를 본문에 명시. 각 기법 설명의 조건절("낯선 코드·도메인이면", "참조 코드·목업이 있으면", "docs로 확인되면 생략") 삭제. 빈 결과가 근거로 남는다는 문단 추가
  - 변경 `skills/finding-unknowns/SKILL.md`: 「금지」에 저자 판정 생략 금지 추가.
    「Red Flags」 표 신설(합리화 문장과 그 반박)
- **Interfaces**
  - Consumes: Task 1의 반환 토큰. 본문이 "훑은 범위와 함께 없음을 반환한다"로 그 계약을 서술한다
- **실행 검증**: `! grep -q '강제 아님' skills/finding-unknowns/SKILL.md` · `grep -q '무조건 발동' skills/finding-unknowns/SKILL.md` · `grep -q 'Red Flags' skills/finding-unknowns/SKILL.md`
- **의존**: Task 1

### Task 3: 인터뷰 절차를 양방향 순환으로 재작성

- **Files**
  - 신규 `skills/finding-unknowns/references/grounding-in-interview.md`: Clark & Brennan 1991의 presentation·acceptance 정의, grounding criterion, installment, least collaborative effort를 원문 인용으로. 「확인 범위」 절에 원문 대조 여부 표기
  - 변경 `skills/finding-unknowns/SKILL.md`: 「역인터뷰 절차」를 「인터뷰 절차」로 승격. 두 방향 구조와 근거 문단 추가.
    절차를 조각 단위 순환으로 재작성(묻기 → 돌려주기 → 어긋나면 그 조각 다시 마무리). 최소 확정 항목(제외 범위·완료 판정·조사가 드러낸 갈림길) 추가.
    원문 명시 항목의 면제를 확인 문항 발행으로 교체
  - 변경 `skills/finding-unknowns/SKILL.md`: 「references 읽기 트리거」에 새 근거 파일 행 추가
- **Interfaces**
  - Produces: 절 이름 「인터뷰 절차」. Task 4의 리뷰어 프롬프트가 이 절이 정한 규칙(0문항 금지, 확인 문항 발행)을 판정 기준으로 인용한다
- **실행 검증**: `test -f skills/finding-unknowns/references/grounding-in-interview.md` · `grep -q '확인 범위' skills/finding-unknowns/references/grounding-in-interview.md` · `grep -q '## 인터뷰 절차\|### 인터뷰 절차' skills/finding-unknowns/SKILL.md` · `grep -q '0문항으로 끝내지 않는다' skills/finding-unknowns/SKILL.md`
- **의존**: 없음

### Task 4: 리뷰어 게이트를 근거 밀도 판정으로 전환

리뷰어가 "조사했음" 선언을 찾게 하면 스펙에 제작 과정을 적게 만든다.
근거의 부재로 판정하게 바꾼다.

- **Files**
  - 변경 `skills/spec-review/completeness-prompt.md`: 「판정 축」 아래 「조사·인터뷰 게이트」 신설. 선언을 찾지 말라는 지시와 근거 부재 판정 항목(근거 없는 단정, 전제 미검사, 저자 추정으로 채운 제외 범위·완료 판정, 포기한 것 부재). 「캘리브레이션」에 이 축은 크기와 무관하게 FAIL 명시
- **Interfaces**
  - Consumes: Task 3이 정한 인터뷰 규칙. 판정 문구가 그 규칙을 그대로 인용한다
- **실행 검증**: `grep -q '조사·인터뷰 게이트' skills/spec-review/completeness-prompt.md` · `grep -q '근거의 부재' skills/spec-review/completeness-prompt.md` · `grep -q 'REVIEW_VERDICT' skills/spec-review/completeness-prompt.md`
- **의존**: Task 3
