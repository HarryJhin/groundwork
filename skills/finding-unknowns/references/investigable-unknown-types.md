# Lineage of the investigable types

`SKILL.md`의 「Definitions of the investigable types」가 쓰는 유형 4종의 이름(리포 미지·표면 미지·관측 미지·참조 미지)은 이 스킬의 조어다.
4종을 한 묶음으로 갖는 통용 분류 체계는 확인되지 않았다.
각 유형은 서로 다른 문헌의 독립된 개념에 대응하고 이 문서가 그 대응과 실증 근거를 담는다.

조어를 유지하는 이유는 축이 다르기 때문이다.
통용 명칭들은 각각 자기 연구 전통에서 왔고 서로를 참조하지 않는다.
이 스킬이 필요한 축은 "어느 조사원에게 넘기는가" 하나이고 그 축으로 4종을 한 표에 세우려면 공통 명명이 필요하다.

## Repo unknown to program comprehension

출처: Sillito, Murphy & De Volder, "Asking and Answering Questions during a Programming Change Task", IEEE Transactions on Software Engineering, 2008년 7월.

변경 작업을 수행하는 프로그래머를 관찰해 질문 44종을 목록화하고 4개 그룹으로 묶었다.

```text
Finding focus points
Expanding a focus point
Understanding a subgraph
Questions over groups of subgraphs
```

조직 원리는 소스 코드를 "개체의 그래프"로 보고 프로그래머의 탐색 범위에 따라 질문을 가르는 것이다.
진입점 찾기에서 시작해 개별 개체와 그 관계, 얽힌 구조, 여러 영역에 걸친 파급 순으로 넓어진다.

이 축은 리포 미지의 **내부** 세분류다.
이 스킬의 4종과 같은 층이 아니다.
블라인드 스팟 조사원이 무엇을 물어야 하는지 정할 때 참조할 목록이다.

## Surface unknown to API learning

출처: Robillard, "What Makes APIs Hard to Learn? Answers from Developers", IEEE Software 26(6), 2009년 11/12월. 마이크로소프트 개발자 대상 설문(응답 83명, 유효 80명)과 후속 인터뷰 12건.

Table 1의 주요 범주와 응답자 수는 다음과 같다.

| 주요 범주 | 설명 | 응답자 |
|---|---|---|
| Resources | API 학습 자료(문서 등)의 부족·부재 | 50 |
| Structure | API의 구조·설계 | 36 |
| Background | 응답자의 배경·선행 경험 | 17 |
| Technical environment | API가 쓰이는 기술 환경 | 15 |
| Process | 시간·중단 등 프로세스 | 13 |

전체 74명이 장벽을 하나 이상 언급했고 그중 50명이 자료 관련 장벽을 들었다.
논문은 이를 두고 API 구조 개선 노력이 학습 자료 개선 노력으로 보완돼야 한다고 적는다.

학습 전략 응답은 문서 읽기 78%, 코드 예제 사용 55%, API 실험 34%, 기사 읽기 30%, 동료에게 묻기 29%다.

## Observation unknown to the spike solution

용어는 익스트림 프로그래밍에서 왔다.
Kent Beck과 Ward Cunningham이 1990년대 후반 단일 기술 질문에 답하려고 쓰는 버릴 프로그램을 그렇게 불렀다.
"통나무에 못을 박듯 끝에서 끝까지, 아주 좁게"가 이름의 유래다.
산출물은 프로덕션 코드가 아니라 지식이고 코드를 남기는 것이 안티패턴이다.

이 유형을 별도로 세우는 실증 근거는 두 곳에 있다.

Robillard Table 1에서 `Structure` 아래 `Testing and debugging`(응답자 10)이 "API의 테스트·디버깅·런타임 동작에 관련된 문제"로 분리돼 있다.
논문은 API의 테스트 용이성과 런타임 동작을 추론하는 어려움이 별도 영향을 준다고 적고 응답자 인용으로 "맥락에 따라 달라지는 API 동작의 미묘한 차이"를 든다.
문서를 다 읽어도 해소되지 않는 지식이 있다는 뜻이다.

Ko, DeLine & Venolia(아래)에서 가장 자주 미뤄진 정보가 이 유형이다.

## Reference unknown to analogical reuse and case-based reasoning

사례 기반 추론은 과거 문제의 해법을 사례로 저장해 두고 새 문제에 맞는 것을 꺼내 고쳐 쓰는 기법이다.
유추 추론과 함께 설계 공간을 탐색하는 두 기제로 다뤄진다.

이 스킬이 쓰는 뜻은 그보다 좁다.
사례 저장소를 만들거나 자동 검색하지 않고 이번 작업과 같은 문제를 이미 푼 것이 리포 안에 있는지만 찾는다.

실무 빈도는 두 관측에 있다.
Ko et al. §5.1은 개발자가 API 문서를 검색하고 다른 코드의 예제를 살피는 행위를 두고 "기존 재사용 가능 코드의 공간을 탐색하는 것"으로 볼 수 있다고 적는다.
Robillard에서 코드 예제 사용은 55%이고 `Resources` 아래 `Examples`(응답자 20)가 최다 하위 범주다.

## Empirical basis for the "where the answer lives" axis

출처: Ko, DeLine & Venolia, "Information Needs in Collocated Software Development Teams", ICSE 2007. 대형 소프트웨어 회사의 개발자 17명을 90분 세션으로 관찰해 정보 탐색 334건을 정보 요구 21종으로 추상화했다.

이 논문이 이 스킬의 표에서 「답이 있는 곳」 열과 같은 축을 쓴다.
Figure 3이 정보 유형마다 탐색 시간, 탐색 빈도와 결과(획득·연기·포기), 그리고 **출처 빈도**를 기록한다.
출처로 나타나는 값은 `code`, `docs`, `tools`, `coworker`, `debugger`, `spec`, `intuition`, `memory`, `bug report`, `comment`, `inference`, `email`, `log`, `test`, `compile`, `screenshot`이다.

이 스킬의 도구 배정과 직결되는 관측이 둘 있다.

가장 자주 미뤄진 정보가 관측 미지에 해당한다.

```text
The most often deferred information was the cause of a particular program state
and the situations in which a failure occurs.
```

획득에 가장 오래 걸린 것은 설계 지식(d2 "프로그램이 무엇을 하기로 되어 있나", d3 "왜 이렇게 구현했나")과 동작 지식(u1, u3)이었다.
설계 지식에 대해 논문은 이렇게 적는다.

```text
Design knowledge of all types was scattered among design documents, bug reports,
and personal notebooks. ... Developers rarely searched these sources, because such
sources were thought to be inaccurate and out of date.
```

그리고 "이 문제들 때문에 두 명을 뺀 모든 개발자가 설계 지식 부재로 결정을 미뤘다"고 이어진다.
설계 의도가 코드에도 문서에도 신뢰할 만하게 남지 않는다는 관측이라 이 스킬이 설계 의도를 조사가 아니라 역인터뷰로 돌리는 배치를 지지한다.

## Verification scope

- Ko, DeLine & Venolia 2007: 원문 PDF의 본문(정보 요구 절 전체와 Figure 3)을 직접 대조했다.
  인용문과 출처 목록은 원문에서 옮겼다.
  21종 전체 목록은 Figure 3의 표에서 읽었고 개별 항목의 코드(s1, u3 등)까지 확인했다.
- Robillard 2009: 원문 PDF의 Table 1과 설문 설계·응답자 구성을 직접 대조했다.
  인용한 수치는 표와 본문에서 옮겼다.
  후속 인터뷰 분석(6쪽 이후)은 대조하지 않았다.
- Sillito, Murphy & De Volder 2008: **원문을 대조하지 않았다.**
  4개 그룹의 이름과 조직 원리는 제3자 요약 페이지에서 얻었다.
  질문 44종의 개별 목록은 확인하지 않았다.
  이 항목을 다른 문서로 옮길 때 이 한계를 함께 옮긴다.
- 스파이크의 기원(Beck·Cunningham, XP): **1차 출처를 대조하지 않았다.**
  웹 요약 수준의 확인이다.
  용어와 유래 설명은 널리 통용되지만 Beck의 원저에서 직접 확인한 것이 아니다.
- 사례 기반 추론·유추 재사용: 개념 정의만 2차 자료로 확인했다.
  특정 논문을 1차로 대조하지 않았고 이 스킬이 쓰는 좁은 뜻과 문헌의 뜻이 다르다는 점을 본문에 적어 두었다.
