# Development State Machine

This diagram is the canonical lifecycle for Research-to-Repo. Human approval gates return to the persistent Codex control task and cannot be crossed automatically.

```mermaid
stateDiagram-v2
    [*] --> DailyDiscovery: Daily trigger

    DailyDiscovery --> BriefReady: Research 3 candidate types
    BriefReady --> AwaitingSelection: Post ranked brief in Codex

    AwaitingSelection --> Backlog: Not selected
    Backlog --> BriefReady: Resurface in a later brief
    AwaitingSelection --> Selected: Human chooses an idea
    AwaitingSelection --> Archived: Human explicitly rejects it

    Selected --> ScopeAssessment
    ScopeAssessment --> Wayfinder: Large, uncertain, or multi-session
    ScopeAssessment --> FocusedResearch: Path already clear

    state Wayfinder {
        [*] --> MapCreated
        MapCreated --> DecisionFrontier
        DecisionFrontier --> AFKResearch: Primary-source question
        DecisionFrontier --> HumanGrilling: Product/domain decision
        DecisionFrontier --> Prototype: Runnable answer needed
        DecisionFrontier --> ManualTask: Human-only prerequisite

        AFKResearch --> DecisionRecorded
        HumanGrilling --> AwaitingDecision
        Prototype --> AwaitingDecision
        ManualTask --> AwaitingDecision
        AwaitingDecision --> DecisionRecorded: Human approves
        AwaitingDecision --> DecisionFrontier: Revise
        DecisionRecorded --> DecisionFrontier: More fog remains
        DecisionRecorded --> [*]: Route is clear
    }

    Wayfinder --> FocusedResearch
    FocusedResearch --> DomainModel
    DomainModel --> ArchitectureDecisions
    ArchitectureDecisions --> SpecDrafted

    SpecDrafted --> AwaitingSpecApproval
    AwaitingSpecApproval --> SpecDrafted: Human requests changes
    AwaitingSpecApproval --> TicketsDrafted: Human approves

    TicketsDrafted --> AwaitingTicketApproval
    AwaitingTicketApproval --> TicketsDrafted: Human requests changes
    AwaitingTicketApproval --> AwaitingRepositoryApproval: Human approves
    AwaitingRepositoryApproval --> RepositoryReady: Human approves repository
    AwaitingRepositoryApproval --> TicketsDrafted: Revise proposal

    RepositoryReady --> Implementing
    Implementing --> TDDCycle: Next unblocked ticket

    state TDDCycle {
        [*] --> Red
        Red --> VerifyFailure
        VerifyFailure --> Red: Wrong failure
        VerifyFailure --> Green: Expected failure
        Green --> VerifyPass
        VerifyPass --> Green: Still failing
        VerifyPass --> Refactor: Passing
        Refactor --> VerifyPass
        VerifyPass --> [*]: Slice complete
    }

    TDDCycle --> CodeReview
    CodeReview --> Implementing: Standards or spec issues
    CodeReview --> Verification: Review passes
    Verification --> Implementing: Build, test, runtime, or docs failure
    Verification --> AwaitingReleaseApproval: Evidence is clean

    AwaitingReleaseApproval --> PullRequest: Human approves PR
    AwaitingReleaseApproval --> Implementing: Human requests changes
    PullRequest --> Shipped: Merged and documented
    Shipped --> PortfolioUpdated
    PortfolioUpdated --> [*]

    Selected --> DailyHandoff: Stop or blocker
    Wayfinder --> DailyHandoff: Stop or blocker
    FocusedResearch --> DailyHandoff: Stop or blocker
    SpecDrafted --> DailyHandoff: Stop or blocker
    Implementing --> DailyHandoff: Stop or blocker
    Verification --> DailyHandoff: Non-transient failure
    DailyHandoff --> Paused: Persist state, evidence, and next action
    Paused --> BriefReady: Offer continuation in a later brief
    Paused --> ScopeAssessment: Human resumes selected work
```

## Transition Rules

- A clearly transient failure may be retried once before `DailyHandoff`.
- No state transition deletes an idea or unfinished work. `Paused` retains the
  project's prior `planned`, `building`, or `blocked` progress status.
- `Archived` records an explicit rejection and can be reversed only by explicit human revival.
- `RepositoryReady`, `PullRequest`, and `Shipped` require distinct human approvals or verified events.
- A specification-only result is `planned`; partial implementation is `building`; neither is `shipped`.
- Reruns update the existing state record and dated brief rather than producing duplicates.
