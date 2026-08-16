출처: https://research.aston.ac.uk/en/publications/unknown-knowns-tacit-knowledge-in-requirements-engineering/

# Unknown knowns: Tacit knowledge in requirements engineering

P. Sawyer, V. Gervasi, B. Nuseibeh. RE'11 (19th IEEE International Requirements Engineering Conference), Trento, 2011.

## Central claim

Rumsfeld의 3분류는 요구 지식에 잘 대응하지만 한 칸을 빠뜨렸다.
**unknown known**이다.
요구공학에서 unknown known은 사용자가 알고 있으나 분석자에게 도달하지 않은 지식을 뜻하고 여러 tacit knowledge 정의 중 최소 하나에 들어맞는다.

## Four causes of reachability failure (verbatim quotations)

| 원인 | 원문 |
|---|---|
| 의도적 은닉 | "withhold the knowledge deliberately for some perceived personal advantage" |
| 우발적 생략 | "not realizing the value of their knowledge" |
| 발화 불가 | "unable to articulate it" |
| 자각 없음 | "knowledge they don't even realize they hold" |

## The expressible and relevant predicates

Gervasi 등의 틀은 소프트웨어 프로젝트 참여자 사이의 소통을 모델링하며 정보 단위 `k`에 술어를 건다.

- `expressible(k)`: 고객이 발화로 표현할 수 있는가
- `relevant(k)`: 논의 중인 시스템·프로젝트에 관련이 있는가

## Where the skill uses this

`expressible`가 「미발화」와 「무발화」를 가르는 축이다.

- 「미발화」 행은 원인 2·4에 대응한다.
  `relevant`가 거짓으로 잘못 판단됐거나 자각이 없는 경우라 질문이 relevance를 알려주면 해소된다.
- 「무발화」 행은 원인 3에 대응한다.
  `expressible`가 거짓이라 질문을 몇 번 반복해도 해소되지 않는다.
  도구를 프로토타입 병치로 바꾼다.
- 원인 1(의도적 은닉)은 사용자 한 사람과 일하는 groundwork 맥락에서 대상이 아니다.
  이해관계자가 여럿인 조직 도입에서는 되살아난다.

## Verification scope

원인 4가지의 인용구는 초록·서지 페이지에서 확인했고 논문 전문은 대조하지 않았다.
`expressible`·`relevant` 술어는 2차 요약을 경유한 것이라 원논문 정의와 대조하지 않았다.

저자들은 원인을 분류할 뿐 원인별 대응 기법을 제시하지 않는다.
위 「Where the skill uses this」의 도구 배정은 이 스킬의 판단이고 논문의 주장이 아니다.
인용을 다른 문서로 옮길 때 이 표기를 함께 옮긴다.
