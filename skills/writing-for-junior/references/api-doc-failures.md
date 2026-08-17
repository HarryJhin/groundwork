출처: [^ieeesw2015-pdf]

# How API Documentation Fails

Gias Uddin, Martin P. Robillard. IEEE Software 32(4), 2015, 68–75. DOI 10.1109/MS.2014.80.

## Study scale

IBM 소프트웨어 전문가 323명을 대상으로 한 조사 두 건이다.  
탐색 조사는 698명에게 보내 69명이 응답했고(9.9%), 검증 조사는 1,064명에게 보내 254명이 응답했다(23.8%).  
탐색 조사에서 문서 사례 179건(좋은 예 90, 나쁜 예 89)을 모아 문서 단위 131개, API 72종을 다뤘다.

## The ten problems (Table 2 verbatim)

E는 그 문제를 언급한 사례 수, D는 그 문제를 보고한 개발자 수다.

**Content (합계 E=61, D=57)**

| 문제                 | 원문 정의                                                                        | E   | D   |
|----------------------|----------------------------------------------------------------------------------|-----|-----|
| Incompleteness       | "The description of an API element or topic wasn't where it was expected to be." | 20  | 20  |
| Ambiguity            | "The description of an API element was mostly complete but unclear."             | 16  | 15  |
| Unexplained examples | "A code example was insufficiently explained."                                   | 10  | 8   |
| Obsoleteness         | "The documentation on a topic referred to a previous version of the API."        | 6   | 6   |
| Inconsistency        | "The documentation of elements meant to be combined didn't agree."               | 5   | 4   |
| Incorrectness        | "Some information was incorrect."                                                | 4   | 4   |

**Presentation (합계 E=25, D=22)**

| 문제                          | 원문 정의                                                                                                                                                    | E   | D   |
|-------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|-----|-----|
| Bloat                         | "The description of an API element or topic was verbose or excessively extensive."                                                                           | 12  | 11  |
| Fragmentation                 | "The information related to an element or topic was fragmented or scattered over too many pages or sections."                                                | 5   | 5   |
| Excess structural information | "The description of an element contained redundant information about the element's syntax or structure, which could be easily obtained through modern IDEs." | 4   | 3   |
| Tangled information           | "The description of an API element or topic was tangled with information the respondent didn't need."                                                        | 4   | 3   |

## Key conclusion

"We concluded that the most pressing problems were related to content, as opposed to presentation."

가장 심각한 문제 3가지는 ambiguity, incompleteness, incorrectness다.  
응답자들이 문제 6가지를 최소 한 번 이상 "blocker"로 지목했고(incompleteness, ambiguity, obsoleteness, incorrectness, inconsistency, unexplained examples) 초록은 이것을 "다른 API를 쓰게 만든 blocker"로 표현한다.  
ambiguity를 최우선 과제로 고른 비율이 51.9%다.

## Where the skill uses this

- **content가 presentation을 크게 웃돈다(61 대 25)**는 결과가 이 스킬의 구성 판단과 같은 방향이다.  
  문장을 다듬는 것보다 내용의 공백·모호·불일치를 잡는 쪽이 우선이라는 뜻이다.  
  groundwork 스킬 전수 리뷰에서도 산문 결함보다 구조 계약 결함(입력·경로 기준·주체 누락)이 많았다.
- **Incompleteness의 정의**가 "기대한 곳에 없었다"인 점이 B축(참조 해소)의 근거다.  
  정보가 리포 어딘가에 있어도 독자가 기대한 곳에 없으면 없는 것과 같다.  
  해소 비용 항목이 여기서 나온다.
- **Fragmentation**("too many pages or sections에 흩어짐")이 D3(정보 분산)에 직접 대응한다.
- **Inconsistency**("함께 쓰라고 한 요소들의 문서가 서로 어긋남")가 D3의 "같은 규칙을 두 곳에서 다른 값으로 지시" 판정에 대응한다.
- **Bloat**과 **Tangled information**이 D4(형식 부담)에 대응한다.  
  표로 표현해야 읽히는 것을 산문에 묻는 경우와, 독자가 필요로 하지 않는 정보가 엉킨 경우다.
- **Unexplained examples**가 `delta-skill.md`의 I축(셸 블록 성립성)에 대응한다.  
  코드 예시가 설명 없이 놓이면 독자가 그것을 실행으로 옮기지 못한다.

## Verification scope

Table 2의 문제 정의와 수치, 조사 규모, 핵심 결론 문장은 저자 공개본 PDF 전문에서 확인했다.  
인용은 그 PDF의 표기 그대로다.

논문은 API 문서를 대상으로 하고 설계 문서·스킬 문서를 다루지 않는다.  
문제 유형을 이 스킬의 판정 축으로 옮긴 것은 이 스킬의 매핑이고 저자들의 주장이 아니다.  
저자들은 문제를 분류하고 심각도를 재지만 문제별 작성 처방을 제시하지 않는다.

논문의 "ambiguity"는 "대체로 완전하지만 불명확함"으로 정의돼 `coherence` 렌즈의 `모호` 축과 `junior-read`의 D축에 걸쳐 있다.  
어느 한쪽에 배타적으로 대응하지 않는다.

[^ieeesw2015-pdf]: https://www.cs.mcgill.ca/~martin/papers/ieeesw2015.pdf
