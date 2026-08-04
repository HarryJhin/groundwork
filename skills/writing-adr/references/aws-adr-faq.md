출처: https://docs.aws.amazon.com/prescriptive-guidance/latest/architectural-decision-records/faq.html

# FAQ about architectural decision records

**What are the benefits of creating an ADR process?**

The project team should create an ADR process to streamline architectural decision-making, prevent repeated discussions about the same architectural topics, and communicate architectural decisions effectively.

**When should the project team create an ADR?**

The project team should create an ADR for every aspect of the software that affects structure (patterns such as microservices), non-functional requirements (security, high availability, and fault tolerance), dependencies (coupling of components), interfaces (APIs and published contracts), and construction techniques (libraries, frameworks, tools, and processes).

**How often should the project team review an ADR?**

The project team should review the ADR at least once before accepting it.

**Who should create an ADR?**

Every team member can create an ADR. We recommend that you promote a notion of ownership for ADRs. An author who owns the ADR should actively maintain and communicate the ADR content. Other team members can always contribute to an ADR. The ADR owner should approve changes to an ADR.

**What information should an ADR contain?**

At a minimum, each ADR has to define the context of the decision, the decision itself, and the consequences of the decision for the project and its deliverables. The context should mention possible solutions the team considered. It should also contain any relevant information relating to the project, customer, or technology stack. The decision must clearly state, in imperative language, the solution the team has decided to adopt. Avoid using words such as "should," and phrase each decision to say "We use…" or "The team has to use…" The consequences section should mention all known trade-offs of making the decision. Each ADR must have a status and a changelog that contains the change date and the person who is responsible for the change.

**Where can I find ADR templates?**

There are multiple versions and variants of ADR templates available. For a public collection of commonly used ADR templates, see the ADR GitHub repository.
