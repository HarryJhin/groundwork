출처: [^steinmacher2014-chapter-barriersfacedbyn]

# Barriers Faced by Newcomers to Open Source Projects: A Systematic Review

I. Steinmacher, M.A.G. Silva, M.A. Gerosa. OSS 2014, IFIP AICT.

오픈소스 프로젝트에 처음 들어오는 사람이 부딪히는 장벽을 문헌 리뷰로 모아 5개 범주의 계층 모델로 정리한다.  
이 스킬이 "주니어"를 능력이 아니라 맥락의 부재로 정의한 근거다.

## The five categories and their barriers (Table 1 verbatim)

| 범주                          | 장벽                                                                                                                                            |
|-------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| Finding a Way to Start        | Finding appropriate task/issue / Finding the correct artifacts to fix an issue                                                                  |
| Newcomers' Previous Knowledge | Lacking of Domain expertise / Lacking of Previous Technical Experience / Lacking of Knowledge on processes and practices                        |
| Code Issues                   | Dealing with code complexity/instability / Understanding architecture/code structure / Setting up Local Workspace                               |
| Documentation Problems        | Outdated documentation / Code comments not clear / Information overload                                                                         |
| Social Interactions           | Socializing with project members / Receiving (timely and proper) response / Sending a correct/meaningful message / Finding Help - Mentor/Expert |

## Quotations that bear on this skill

**도메인 지식의 분리**: Von Krogh 등은 "feature gifts by newcomers emerge from the newcomers prior domain knowledge and user experience"라 하고 Stol 등의 연구에서 피험자들은 "reported their unfamiliarity with the domain to be a hindrance"라 답했다.  
저자들은 "newcomers who present previous domain knowledge have more chances to have a successful onboarding"으로 정리한다.

**정보 과부하**: "A rich documentation is essential for newcomers trying to understand the projects. However, just providing a bunch of documentation leads to information overload. So, the project should provide easy ways to find this documentation."

**구조 이해의 장벽**: 한 피험자는 "the hierarchy of the source code directory was counter intuitive for someone with little architecting experience"라 보고했고 Cubranic & Murphy는 "We also had reports of a pair missing a relevant suggestion because they lacked knowledge about the overall structure of the system"을 전한다.

## Where the skill uses this

- **독자 정의의 근거**다.  
  이 모델은 기술 경험(Previous Technical Experience)과 도메인 지식(Domain expertise)을 별도 장벽으로 분리한다.  
  이 스킬이 독자를 "기술은 알지만 이 프로젝트는 모르는 사람"으로 정의하고 "주니어는 능력이 아니라 맥락의 부재"라고 명시한 것이 이 분리에 대응한다.
- **정보 과부하 항목**이 D4(형식 부담)와 D3(정보 분산)의 실무 근거다.  
  문서를 많이 두는 것과 독자가 필요한 것을 찾는 것은 다른 문제라는 진술이 그것이다.
- **Documentation Problems 범주에 "Code comments not clear"가 들어간 것**이 문서 품질을 온보딩 장벽으로 취급하는 근거다.  
  이 스킬이 판독성을 문체 취향이 아니라 진입 비용으로 다루는 이유다.

## Verification scope

Table 1의 범주·장벽 이름과 위 인용구는 저자 공개본 PDF의 해당 페이지에서 확인했다.  
인용은 그 PDF 표기 그대로이고 인용구 안의 출처 번호는 원 논문이 참조하는 2차 문헌이라 이 파일에서 그 원문까지 대조하지는 않았다.

리뷰가 분석한 연구 편수는 출처마다 다르게 표기된다.  
검색 결과 요약은 21편이라 하고 자동 추출 요약은 11편이라 했으며 PDF 본문은 범주별 근거 편수(사회적 상호작용 13편, 나머지 8~9편)만 확인됐다.  
총 편수는 확정하지 않았다.

이 리뷰는 오픈소스 프로젝트의 사람 기여자를 다루고 문서를 읽는 에이전트를 다루지 않는다.  
장벽 모델을 문서 판독성 판정으로 옮긴 것은 이 스킬의 유추다.  
Social Interactions 범주는 이 스킬의 대상이 아니라 옮기지 않았다.

[^steinmacher2014-chapter-barriersfacedbyn]: https://www.ime.usp.br/~gerosa/papers/Steinmacher2014_Chapter_BarriersFacedByNewcomersToOpen.pdf
