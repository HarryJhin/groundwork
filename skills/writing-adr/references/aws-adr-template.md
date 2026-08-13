출처: https://docs.aws.amazon.com/prescriptive-guidance/latest/architectural-decision-records/appendix.html

주의: 이 파일은 AWS 원본 예시 ADR이다.
우리 델타 넷(h1 `# ADR-NNNN: <짧은 제목>`, Status 5값, Alternatives 없음, 섹션명 영문·본문 한국어)을 반영하지 않는다.
원본의 4값 Status, h1 부재, Consequences 미분리를 형식 기준으로 삼지 말라.
형식 정본은 이 스킬의 SKILL.md 본문이다.
이 파일은 델타가 다루지 않은 섹션 세부의 배경 확인용이다.

# Appendix: Example ADR

## Title

This decision defines the software development lifecycle approach for ABC application development.

## Status

Accepted

## Date

2022-03-11

## Context

ABC application is a packaged solution, which will be deployed to the customer's environment by using a deployment package. We need to have a development process that will enable us to have a controllable feature, hotfix, and release pipeline.

## Decision

We use an adapted version of the GitFlow workflow to develop ABC application.

For simplicity, we will not be using the hotfix/* and release/* branches, because ABC application will be packaged instead of being deployed to a specific environment. For this reason, there is no need for additional complexity that might prevent us from reacting quickly to fix bugs in production releases, or testing releases in a separate environment.

The following is the agreed branching strategy:

- Each repository must have a protected main branch that will be used to tag releases.
- Each repository must have a protected develop branch for all ongoing development work.

## Consequences

Positive:

- Adapted GitFlow process will enable us to control release versioning of the ABC application.

Negative:

- GitFlow is more complicated than trunk-based development or GitHub flow and has more overhead.

## Compliance

- The main and develop branches in each repository must be marked as Protected.
- Changes to the main and develop branches must be propagated by using merge requests.
- At least one approval is required for every merge request.

## Notes

- Author: Jane Doe
- Version: 0.1
- Changelog:
  - 0.1: Initial proposed version
