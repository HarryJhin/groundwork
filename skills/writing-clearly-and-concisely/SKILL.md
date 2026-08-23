---
name: writing-clearly-and-concisely
description: Use when writing or editing prose a human will read - documentation, README, commit message, PR description, error message, UI copy, help text, report, or explanation. Also use when a sentence reads long, passive, hedged, or vague and you cannot say why.
---

# Writing clearly and concisely

**경로 기준**: 이 문서의 상대 경로는 이 스킬 디렉터리를 기준으로 한다.

## The rules

Strunk의 규칙 열여덟이다.  
볼드는 가장 자주 어기는 것이므로 먼저 검사한다.

### Elementary rules of usage

영어 문법과 구두점 규칙이라 영어 산문에만 적용한다.

1. Form possessive singular by adding 's
2. Use comma after each term in series except last
3. Enclose parenthetic expressions between commas
4. Comma before conjunction introducing co-ordinate clause
5. Don't join independent clauses by comma
6. Don't break sentences in two
7. Participial phrase at beginning refers to grammatical subject

### Elementary principles of composition

어느 언어에나 적용한다.

8. One paragraph per topic
9. Begin paragraph with topic sentence
10. **Use active voice**
11. **Put statements in positive form**
12. **Use definite, specific, concrete language**
13. **Omit needless words**
14. Avoid succession of loose sentences
15. Express co-ordinate ideas in similar form
16. **Keep related words together**
17. Keep to one tense in summaries
18. **Place emphatic words at end of sentence**

한국어로 쓸 때는 8~18을 적용하고, 실행 환경이 그 언어의 문장 규범 스킬을 제공하면 함께 로드한다.

## When to open the full text

[elements-of-style.md](elements-of-style.md)는 1918년 원문 전문이고 약 12,000 토큰이다.  
**규칙을 적용하려고 이 파일을 열지 않는다.**  
위 열여덟이 규칙의 전부이고 각 규칙의 뜻과 예시는 이미 알고 있다.

이 파일을 여는 경우는 하나다.  
**특정 단어의 용법이 의심스러워 Section V (Words and expressions commonly misused)를 조회할 때**다.  
그때도 전문을 읽지 말고 그 항목만 찾는다.  
항목은 알파벳 순이라 Grep으로 단어를 직접 친다.

```bash
grep -n -A3 '^\*\*Nice\.\*\*' elements-of-style.md
```
