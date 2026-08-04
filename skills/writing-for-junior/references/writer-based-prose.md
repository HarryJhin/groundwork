출처:
- https://mwover.com/wp-content/uploads/2018/05/flower-writer-based-prose.pdf
- https://en.wikipedia.org/wiki/Wikipedia:Manual_of_Style/Self-references_to_avoid
- https://github.com/azizkayumov/clean-code/blob/main/comments.md

# 제작 사정 누출(G축)의 근거

G축이 잡는 결함에는 학술 명칭과 실무 판정 규칙이 각각 따로 있다. 명칭은 현상을 가리키고 규칙은 판정 방법을 준다.

## 현상의 명칭: writer-based prose

Linda S. Flower. "Writer-Based Prose: A Cognitive Basis for Problems in Writing." *College English* 41 (September 1979), 19-37.

정의는 이렇다.

```text
Writer-Based prose is prose in which the writer is essentially talking to
himself. More specifically, in its narrative and/or survey structure and its
elliptical style, Writer-Based prose reflects the interior monologue of a
writer thinking and talking to himself.
```

대비항이 reader-based prose이고, 저자가 아는 것을 독자의 필요에 맞게 변형한 산문을 가리킨다.

Flower의 진단은 원인을 능력이나 성의가 아니라 **변형의 부재**로 잡는다. 유능한 필자는 생각을 표현하는 데 그치지 않고 독자의 필요에 맞춰 그것을 변형한다. 저자 자신에게는 뜻이 다 통하는 글이 독자에게는 같은 뜻을 전하지 못하는 일이 여기서 생긴다.

이 스킬의 「왜 저자는 이 실패를 못 알아채는가」가 같은 진단을 다룬다. G축은 그중 문서가 자기 제작 과정을 기록하는 형태를 떼어 판정 축으로 세운 것이다.

## 판정 규칙: 이식성 테스트

Wikipedia Manual of Style, "Self-references to avoid".

이 규약에서 가져온 것은 금지 목록이 아니라 **판정 방법**이다. 자기 참조를 "위키백과 사본에서 말이 안 되는 텍스트"로 정의한다. 미러나 포크로 옮겼을 때 성립하지 않으면 자기 참조다.

허용 기준도 같은 축으로 정한다. 특정 백과사전이나 접근 방식을 전제하지 않는 서술은 자기 참조가 아니다. 예로 목록 문서가 자기 수록 기준을 서두에 밝히는 것은 허용된다.

G축의 판정식이 이 형태를 그대로 옮겼다. 기준 환경만 바꾼다. 위키백과 사본 대신 "이 문서를 만든 환경 밖"이고, 그 환경은 저자의 도구 설정, 문서를 만든 세션, 거쳐 온 리뷰 라운드를 가리킨다.

## 코드 주석의 대응 분류

Robert C. Martin, *Clean Code*, 4장 Comments의 불량 주석 분류에서 셋이 대응한다.

| 이름 | 정의 | G축의 어느 꼴인가 |
|---|---|---|
| Journal Comments | 변경 이력을 코드에 적는 주석. 버전 관리가 더 잘한다 | 처리 흔적, 연혁 |
| Noise Comments | 값을 더하지 않고 뻔한 것을 되풀이한다 | 형식 선택의 변호, 완결성 선언 |
| Mumbling | 저자에게는 뜻이 있으나 남에게는 안 읽힌다 | 저자의 고민 경과 |

Journal Comment의 논리가 특히 쓸모 있다. 정보가 틀려서 빼는 것이 아니라 **그 정보를 담을 더 나은 자리가 따로 있어서** 뺀다. G축이 "근거가 정말 필요하면 ADR이나 코드 주석으로 간다"고 적은 근거가 같다.

## 부분만 겹치는 것

"throat clearing"은 글머리의 준비운동 문단과 "it is important to note that" 류의 빈 도입부를 가리킨다. 독자가 아니라 저자를 위한 문장이라는 점이 겹치고, 위치가 앞머리로 한정된다는 점이 갈린다. 본문 한가운데의 제작 사정은 이 이름으로 잡히지 않는다.

Ken Hyland의 metadiscourse 분류(*Metadiscourse: Exploring Interaction in Writing*, 2005)에는 저자의 존재를 드러내는 표지로 self-mention 범주가 있다. 범주 이름으로는 정확하지만 판정에는 쓰지 않았다. Hyland는 metadiscourse를 결함이 아니라 기능으로 다루고, 설명서 연구에서는 독자를 안내하는 데 필요한 것으로 본다.

## 확인 범위

Flower의 정의 인용구는 저자 공개본 PDF에서 확인했다. 논문 전문의 사례 분석과 개정 절차는 대조하지 않았다.

Wikipedia 규약의 판정 정의와 허용 기준은 해당 문서에서 확인했다. 이 규약은 백과사전 편집을 대상으로 하고 기술 문서를 대상으로 하지 않으므로, 기준 환경을 바꿔 옮긴 것은 이 스킬의 유추다.

Clean Code 분류의 이름과 정의는 공개 요약본에서 확인했고 원서 본문은 대조하지 않았다.

기술 문서 실무에서 이 결함을 지목하는 전용 안티패턴 명칭은 찾지 못했다. 코드 주석에는 이름이 붙었고 문서에는 붙지 않은 상태로 보인다.
