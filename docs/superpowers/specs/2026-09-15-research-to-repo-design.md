# Research-to-Repo Design

**Date:** 2026-09-15

**Status:** Approved in conversation; awaiting written-spec review

**Decision record:** [ADR 0001](../../adr/0001-codex-orchestrated-github-backed-workflow.md)

**Canonical lifecycle:** [Development state machine](../../workflow/development-state-machine.md)

## Purpose

Research-to-Repo is a daily, Codex-controlled workflow that turns research, algorithms, open-source libraries, and opportunities in existing repositories into useful public GitHub projects. The system proposes ideas; the human chooses direction and approves consequential decisions. Each selected idea should produce a verified runnable application when feasible and, at minimum, durable research, a specification, ADRs where warranted, tickets, and an implementation plan.

The portfolio should demonstrate how an idea works and why it matters. A paper-focused project therefore combines an interactive explanation with a practical application instead of stopping at a visualization or paper summary.

Research age is unrestricted. A decades-old mathematical result and a newly released MCP capability compete on usefulness, explanatory value, feasibility, and portfolio quality rather than recency.

## Success Criteria

The system succeeds when it:

1. Posts one ranked daily brief in a persistent Codex control task.
2. Offers three concrete candidates drawn from research and the durable backlog.
3. Preserves every candidate, appearance date, source, decision, and state transition.
4. Stops at every consequential human approval gate.
5. Creates a separate GitHub repository for each approved project only after explicit approval.
6. Produces a well-researched specification and plan for every selected idea.
7. Attempts a useful, documented, containerized vertical slice without weakening engineering quality to meet a calendar deadline.
8. Marks a project `shipped` only after fresh verification demonstrates that the runnable release meets the defined quality gate.

## Workspace and Repository Boundaries

The local workspace root is a container, not a Git repository:

```text
Personal-Project/
├── research-to-repo/          # Central orchestration Git repository
├── projects/                  # Separate application Git repositories
└── prototypes/                # Throwaway design probes
```

The orchestration repository will use this target layout:

```text
research-to-repo/
├── AGENTS.md
├── CONTEXT.md
├── README.md
├── .agents/
│   └── skills/
│       └── research-to-repo/
│           └── SKILL.md
├── docs/
│   ├── workflow/
│   │   └── development-state-machine.md
│   ├── adr/
│   │   └── 0001-codex-orchestrated-github-backed-workflow.md
│   ├── agents/
│   │   ├── issue-tracker.md
│   │   └── domain.md
│   ├── briefs/
│   ├── research/
│   └── superpowers/
│       ├── specs/
│       └── plans/
└── portfolio/
    └── projects.yaml
```

The orchestration repository owns discovery, workflow rules, briefs, the idea ledger, decision maps, and the portfolio index. Each application repository owns its code, project-specific vocabulary, ADRs, specification, tickets, tests, documentation, and deployment assets. The portfolio index links to application repositories rather than embedding them as submodules.

## Control Plane

One persistent Codex task is the human control plane. A heartbeat returns to that task every day, and the human uses it to select ideas and approve consequential decisions. GitHub holds durable state so conversation compaction does not erase history.

The heartbeat runs daily at 8:00 AM in `America/Detroit`. If Codex is unavailable at that time, it creates one current brief when it next becomes available. It never creates multiple catch-up briefs.

The version-controlled `.agents/skills/research-to-repo/SKILL.md` is the source of truth for orchestration behavior. A setup mechanism installs or links it into the user's personal Codex skills. Scheduled and manual runs explicitly invoke the skill. The skill stays thin: it enforces the lifecycle, routes to specialized skills, updates state, and stops at approval gates rather than copying their instructions.

No third-party app is required for the initial system. A custom MCP App may be considered later as a portfolio project, but it is outside the first implementation.

## Daily Discovery and Brief

Every daily brief contains three ranked, buildable candidates:

1. A paper or algorithm transformed into both an interactive explanation and a useful application. This explicitly includes highly mathematical research.
2. A useful application built around an interesting open-source library or emerging SDK capability, including MCP Apps.
3. A meaningful extension to an existing portfolio repository.

A candidate may combine categories. The slots describe the desired mix, not rigid content boundaries.

Each candidate records:

- Stable idea ID and discovery date
- All brief appearance dates
- Category and lifecycle status
- One-sentence pitch
- Primary sources and relevant repository links
- The technical idea and why it matters
- Intended users and practical usefulness
- Proposed interactive experience
- Recommended architecture and technology stack
- A one-day vertical slice and longer-term potential
- Technical risks, unknowns, licensing, maintenance, and reproducibility concerns
- Likely Wayfinder decisions
- Novelty comparison with the backlog and portfolio
- Recommendation score with rationale

Discovery may use paper indexes, release feeds, curated lists, and community signals. Every shortlisted claim must be verified through the original paper, official documentation, source repository, release notes, or specification. Research notes cite sources and record license compatibility and reproducibility concerns.

The rotation policy balances novelty and continuity. New and backlogged candidates are ranked together; a brief contains at least one new candidate and at most two resurfaced candidates. A resurfaced candidate shows its earlier appearance dates and explains why it remains strong.

Every candidate becomes a GitHub issue in the orchestration repository. Unselected ideas remain open with a backlog status. Rejected ideas remain historically visible but do not resurface unless revived explicitly. Dated Markdown briefs link to their idea issues.

Canonical lifecycle statuses are `backlog`, `selected`, `researching`, `decisioning`, `planned`, `building`, `blocked`, `shipped`, and `archived`. A paused daily session retains the project's substantive status and records a resumable handoff; `paused` is a session condition, not a replacement lifecycle status.

## Human Authority

The human approves:

- Idea selection
- Product scope and user experience
- Architecture and significant dependencies
- ADRs
- Specification and implementation tickets
- Repository name, description, visibility, license, and initial structure
- Account creation, credentials, restrictive terms, or costs
- Pull-request creation and release

Codex may decide reversible implementation details that remain within an approved specification. It must surface new consequential choices rather than silently expanding its authority.

Repositories are public only after explicit approval. Before repository creation, Codex proposes the name, description, license, and initial structure. Existing projects are changed only in an isolated branch or worktree. Codex verifies the complete change and asks before opening a pull request; it never commits directly to the default branch.

## Skill Routing

The orchestration skill routes responsibilities as follows:

- `research`: gather cited facts from primary sources; research informs but does not make product decisions.
- `wayfinder`: chart large, uncertain, multi-session efforts as a map of decision tickets. It produces decisions, not implementation.
- `domain-modeling`: maintain precise project vocabulary and create ADRs only for hard-to-reverse, surprising choices involving real trade-offs.
- Brainstorming or the Matt Pocock grilling flow: sharpen a selected idea with the human before specification.
- Specification and planning: collapse approved decisions into a coherent spec, then create buildable, dependency-aware tickets and a detailed implementation plan.
- `test-driven-development`: enforce red-green-refactor for implementation behavior.
- `code-review`: review both repository standards and conformance to the approved specification.
- `verification-before-completion`: require fresh evidence before completion claims.
- `finishing-a-development-branch`: require the human to choose how verified work is integrated.

Project implementation tickets live in the application repository. Wayfinder decisions about the overall research-to-repo system live in the orchestration repository. A project may have its own Wayfinder map when its route is too uncertain for one working session.

## Application Standards

TypeScript is the default for interactive UI. C# or Python is the default for backend and scientific work. A different language requires a concrete technical reason in the specification or an ADR.

Applications are local-first. A documented container command must run every shipped project. Live hosting is optional when it is inexpensive, secure, and materially improves the demonstration.

MIT is the default license after compatibility review. Before implementation, the workflow verifies the terms for paper code, datasets, models, libraries, and assets. A project uses another compatible license or rejects the candidate when upstream terms require it, and records that decision.

External services are approval-gated. Prefer open data and local services, never commit secrets, and provide `.env.example`. Creating accounts, adding credentials, accepting restrictive terms, or incurring cost requires explicit approval.

## Definition of Shipped

`shipped` means a verified runnable release. The following must all pass:

- Automated tests
- Lint
- Type checking where applicable
- Production build
- Container build and startup smoke test
- Documented setup and usage
- Example or seed data where needed
- Compatible license
- Screenshots or demo media
- Approved and merged pull request

The README and supporting documentation must explain the purpose, research basis, architecture, setup, container usage, testing, limitations, and demonstration. Missing documentation blocks `shipped`. A specification-only result remains `planned`; partial code remains `building`.

## Failure and Recovery

The canonical transitions are defined in the development state machine. A clearly transient failure is retried once. Any other failure stops safely, preserves artifacts and evidence, records the exact next action, assigns `blocked` or `building` accurately, and asks the human in Codex.

At a daily cutoff or natural stopping point, incomplete work creates a durable handoff. The next brief may present continuation as the existing-project extension candidate. No work is discarded merely because it did not finish that day.

Daily runs are idempotent: there is one dated brief per day and stable IDs for ideas. Re-running a partial job updates existing artifacts instead of duplicating them. If GitHub is unavailable, the workflow may preserve a local draft but cannot claim that the brief or state transition was persisted.

## Verification Strategy

The lean orchestration foundation is Markdown-driven rather than a custom application. Before activation, verify it through a controlled rehearsal that:

- Loads the intended specialist skills and stops at mandatory approval gates
- Walks only transitions allowed by the canonical state machine
- Creates stable idea IDs and checks existing issues before proposing new ones
- Applies the balanced backlog rotation constraints
- Produces a complete daily brief and portfolio entry from the documented templates
- Preserves citations and repository links
- Renders valid Markdown and Mermaid
- Performs no GitHub mutation during the rehearsal
- Reaches a simulated release decision without crossing a human gate

If repeated operation exposes errors that documents and checklists cannot prevent, add deterministic tooling in a later ADR rather than pre-building a workflow engine. Every application still verifies its own tests, lint, type checking, build, container startup, documentation, and demo evidence before release approval.

## Initial Scope

The first implementation includes:

- The orchestration repository and documented workflow
- A thin orchestration skill
- Idea, brief, and portfolio templates
- GitHub issue conventions and labels
- Daily brief generation and persistence
- Codex heartbeat configuration
- A no-mutation rehearsal of the complete workflow
- Setup documentation

The first implementation excludes:

- A custom mobile application
- A custom MCP control application
- A custom TypeScript CLI or state engine
- Automatic public repository creation
- Automatic pull-request creation
- Mandatory cloud hosting
- Paid discovery or deployment services

## Approved Decisions Summary

- Codex-orchestrated, GitHub-backed architecture
- One persistent Codex control task
- Separate repository per project plus a central portfolio index
- Daily brief at 8:00 AM `America/Detroit`
- Balanced backlog rotation
- Broad discovery with primary-source verification
- No recency preference
- Explicit approval before public repository creation and pull-request creation
- Consequential human approval gates; reversible implementation autonomy
- Isolated branches or worktrees for existing repositories
- Verified runnable release as the `shipped` definition
- Containers required; live hosting optional
- Documentation and README mandatory
- TypeScript UI; C# or Python backend/scientific defaults
- MIT default license with compatibility review
- Local-first, approval-gated external services and secrets
- Preserve and report failures; never discard unfinished work automatically
