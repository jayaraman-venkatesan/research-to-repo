---
name: research-to-repo
description: Orchestrate daily research-to-GitHub discovery, backlog tracking, human decision gates, project specification, implementation routing, and portfolio updates.
---

# Research-to-Repo

Accept `daily`, `select <idea-id>`, `continue <idea-id>`, or `status` in the
persistent Codex Control Task. Route to installed specialist skills; read their
instructions when reached. This skill owns transitions and durable records,
not the specialists' procedures.

When a run is a rehearsal, every mode and specialist must show proposed
artifacts, mutations, and transitions only. Make no local or external
workflow-state changes and stop at each simulated human gate.

## Establish context

On this host, resolve the Orchestration Repository to
`/Users/jayaramanvenkatesan/Documents/Personal-Project/research-to-repo`, even
when the task's saved project is its parent `Personal-Project` directory or this
skill is installed elsewhere. The parent is a workspace container. Verify the
repository root and `origin` against
`https://github.com/jayaraman-venkatesan/research-to-repo.git`; use an isolated
linked worktree for writes. On another host, resolve and verify the saved
project's equivalent checkout. All paths below are repository-relative.
Read `AGENTS.md`, `CONTEXT.md`,
`docs/superpowers/specs/2026-09-15-research-to-repo-design.md`, and the canonical
`docs/workflow/development-state-machine.md` before acting. Consult
`docs/agents/issue-tracker.md` for issue ownership, labels, and its
`Wayfinding operations` adapter before entering Wayfinder, and
`docs/agents/domain.md` before vocabulary or ADR work.

Record the current machine state separately from the substantive status
(`backlog`, `selected`, `researching`, `decisioning`, `planned`, `building`,
`blocked`, `shipped`, or `archived`). Preserve first discovery, appearance dates,
decisions, artifact links, approval evidence, and next action in the Idea issue.
Use `docs/research/<idea-id>/handoff.md` as the local recovery record, including
pending GitHub synchronization if remote writes fail. Never claim an unsynced
change is persisted on GitHub.

Apply existing explicit approvals only to the proposal and scope they cover.
At an unapproved gate, persist the proposal and next decision, present it in the
Control Task, and stop. New product/UX, architecture, significant dependencies,
ADRs, accounts, credentials, restrictive terms, costs, repositories, PRs, and
releases require the human authority defined by the spec. Selection alone
does not grant those approvals. Reversible details within approved scope may
proceed. All repository edits use an isolated branch or worktree; use
`using-git-worktrees` when isolation is needed. Never commit secrets, discard
unfinished work, or create public repositories or PRs automatically.

The recorded standing synchronization approval is this repository's `origin`
and non-default branch `automation/daily-briefs`. Its scope is dated briefs,
cited research notes, checkpoints/handoffs, and Idea-state updates in GitHub
Issues. Review the commits and files to be pushed against that scope; application
code never goes on this branch. Changes to workflow rules, templates, or the
portfolio index need their own applicable approval. Verify the approved branch
exists before a write; a missing branch is an operational prerequisite for the
controller to resolve, not permission to use the default branch.

Commit only the intended workflow artifacts and push the approved branch.
Verify through fresh GitHub reads that the remote commit contains their expected
contents, then record immutable artifact links and commit ID in the Idea issues.
Reconcile remote advancement before pushing; preserve work instead of force
pushing. This approval does not authorize default-branch writes, PRs, or new
repositories. A different synchronization boundary needs its own concrete
proposal and approval in Codex. Until remote contents are verified, retain local
artifacts and pending operations without claiming GitHub durability or completion.

## `daily`

1. Determine today's date in `America/Detroit` (for example,
   `TZ=America/Detroit date +%F`). Before declaring a new run, always read the
   current remote `automation/daily-briefs` commit, its
   `docs/briefs/YYYY-MM-DD.md` and `docs/briefs/.YYYY-MM-DD.pending.md`, and the
   day's Idea record, even when both local files are absent. A stale local
   remote-tracking ref is insufficient. The checkpoint names the lead Idea;
   its issue body mirrors the dated record under `Daily run: YYYY-MM-DD`, with
   artifact commit/links, issue synchronization, Codex delivery evidence, daily
   state, and pending operations. Search all-state Idea bodies for that dated
   marker when the remote checkpoint is absent, then read matching records.
   Compare these reads with local files and Control Task history. Restore or
   reconstruct an existing checkpoint and resume its saved discovery or pending
   operations in steps 6–8; do not rediscover merely because this checkout is
   fresh. Unknown, unavailable, or conflicting remote evidence stops the run
   pending reconciliation. A missing branch/file counts as absent only after
   repository access and absence are confirmed. Proceed to step 2 only when
   both local and remote checks establish there is no current-date run.
   Stop quietly only after confirming all three proofs: verified GitHub
   persistence of the brief and cited artifacts, Codex brief delivery, and
   remotely recorded `AwaitingSelection`. A dated or persisted brief alone is
   insufficient. Generate only today's brief, never catch-up briefs.
2. Read `portfolio/projects.yaml`, open Idea issues, recent briefs, and their
   linked handoffs. Inspect archived history during duplicate checks; explicit
   rejection excludes an idea until the human explicitly revives it.
3. Discover broadly using papers, release feeds, libraries, and existing
   repositories. Derive a lowercase, hyphenated ID from category, canonical source identifier,
   and initial title. Search local records and GitHub Issues across all states
   by ID, canonical source, and title before calling it new. Reuse an existing
   identity and its dates after title changes; disambiguate actual collisions
   before writing. Do not guess novelty when GitHub lookup is unavailable.
4. Invoke `research` for primary-source verification of each shortlisted
   candidate, with cited notes in `docs/research/<idea-id>/`. Include license
   compatibility and reproducibility evidence. Research age carries no
   preference. Unverified claims cannot support a recommendation.
5. Rank new and backlog ideas together on usefulness, explanatory value,
   feasibility, and portfolio quality, recording score rationale. Fill
   `docs/templates/daily-brief.md` with three candidates: a paper/algorithm
   application with an interactive explanation, a library/SDK application,
   and a meaningful existing-project extension. Include at least one new and
   at most two resurfaced candidates. Show earlier appearance dates and why
   each resurfaced idea merits attention. An unfinished project can occupy
   the extension slot without losing its status. If evidence or an existing
   repository is unavailable, record the limitation and stop; do not fabricate
   a candidate or publish a brief that violates the mix.
6. In rehearsal, show the proposed brief, research notes, issue mutations, and
   next gate in Codex only. Otherwise stage incomplete
   work as `docs/briefs/.YYYY-MM-DD.pending.md`, with pending operations. Create
   or update Idea issues idempotently using `.github/ISSUE_TEMPLATE/idea.yml`
   and the tracker conventions; recheck identity immediately before creation.
   Preserve history and merge appearance dates without duplicates. Reconcile
   uncertain remote outcomes by reading before retrying a mutation. Mirror the
   dated checkpoint in the lead Idea body under `Daily run: YYYY-MM-DD` so a
   fresh checkout can find the run even before the brief is published.
7. After all issue links and required fields are confirmed, persist
   `docs/briefs/YYYY-MM-DD.md` and synchronize it and every cited research
   artifact through the approved boundary above. Confirm their remote contents
   and immutable links before recording `BriefReady` with delivery pending in
   the checkpoint and its lead Idea issue record. Synchronize and read back this
   delivery-pending checkpoint before posting, making recovery available to a
   fresh checkout. Local files alone remain pending; a failed push or
   verification cannot advance this checkpoint.
8. Post the concise ranked recommendation and verified links in the Control
   Task. Record task/message evidence of delivery, then synchronize and read
   back the checkpoint's `AwaitingSelection` state on GitHub before marking the
   daily run complete locally. An interrupted or uncertain post requires a task
   history check: reuse confirmed delivery without reposting, post only when
   absence is confirmed, and leave ambiguous outcomes pending for resolution.
   Failed state synchronization retries only that pending write, not delivery.
   Stop for the human's choice. Unselected new ideas remain open with `idea:backlog`.
   Existing selected or paused projects retain their substantive status.
   Explicit rejection records `Archived`/`archived` with `idea:archived`;
   ordinary non-selection records `Backlog`, never rejection. Backlog and paused
   work may return to `BriefReady` through a later ranked brief.

## `select <idea-id>` and lifecycle routing

Resolve exactly one durable Idea. Unknown or ambiguous IDs need clarification;
an archived Idea requires explicit revival. Before any mutation, check whether
the Idea already has active work: route repeated selection to `continue` and
retain its substantive status, machine state, labels, approvals, and completed
work. Only a newly selected Idea records the human's selection and
`Selected`/`selected`, replaces `idea:backlog` with `idea:selected`, and enters
`ScopeAssessment`.

Follow these routes until the next human gate or handoff:

| State / condition | Required route and exit |
| --- | --- |
| `ScopeAssessment`: large, uncertain, or multi-session | Invoke `wayfinder`; enter `Wayfinder`/`decisioning`. Use the tracker adapter for a durable map, native child/dependency links, claims, frontier queries, and resolution records before work on uncertainty. |
| Wayfinder decision frontier | Route a primary-source question (`AFKResearch`) to `research`; a product/domain decision (`HumanGrilling`) to `grilling`; a runnable question (`Prototype`) to `prototype`; a human-only prerequisite (`ManualTask`) to `wizard`. Research records facts in `DecisionRecorded`, not product choices. The other branches return to `AwaitingDecision` in Codex. |
| `AwaitingDecision` / `DecisionRecorded` | Human approval records the decision; requested revision returns to `DecisionFrontier`. Continue the frontier while uncertainty remains. Exit Wayfinder only when the route is clear. |
| Clear route / Wayfinder exit | Enter `FocusedResearch`/`researching` using `research`, then sharpen scope and UX with `brainstorming` (or `grilling` where needed). Use `domain-modeling` for `DomainModel` and `ArchitectureDecisions`, following the domain conventions. Surface consequential choices for human approval. |
| Approved decisions | Use `brainstorming` to produce `SpecDrafted`, then stop at `AwaitingSpecApproval`. Requested changes return to the draft. Approval of the specific spec permits `writing-plans` to produce the dependency-aware implementation plan and `TicketsDrafted`; stop at `AwaitingTicketApproval`. |
| Ticket decision | Requested changes return to `TicketsDrafted`. Approved tickets lead to `AwaitingRepositoryApproval`: fill `docs/templates/project-proposal.md`, including verified upstream licenses. Keep drafts in orchestration records until a Project Repository is approved; project implementation issues belong in that repository. |
| Repository decision | Proposal revisions return to ticket/proposal drafting. Explicit approval permits creation of exactly the approved repository and structure, then `RepositoryReady`. For an existing project, present its target repository and proposed change scope for approval and verify isolation; approval permits readiness without creating another repository. |
| `RepositoryReady` | Enter `Implementing`/`building`; use `executing-plans` for the approved plan and the next unblocked ticket. Delegate the entire `TDDCycle`, including failure verification, retry loops, and refactoring, to `test-driven-development`. |
| Completed implementation slice | Invoke `code-review` for `CodeReview` against standards and the approved spec. Findings route through `receiving-code-review` back to `Implementing`; passing review enters `Verification`. |
| `Verification` | Invoke `verification-before-completion` for fresh evidence against every item in the spec's **Definition of Shipped**. Build, test, runtime, or documentation defects return to `Implementing`; non-transient execution blockers use the handoff below. Clean pre-PR evidence enters `AwaitingReleaseApproval`. |
| `AwaitingReleaseApproval` | Use `finishing-a-development-branch` to present verified integration options and the concrete PR proposal in Codex. Requested changes return to `Implementing`. Only explicit PR approval permits `PullRequest`; release and merge authority remain separately scoped. |
| `PullRequest` | Verify the approved merge event, documentation, and the complete shipped quality gate, including fresh evidence for the merged result. Only then record `Shipped`/`shipped`. Use `verification-before-completion` again when evidence is stale or changes occurred. |
| `Shipped` | Upsert `portfolio/projects.yaml` by `ideaId`, populating its documented `name`, `repository`, `status`, `researchBasis`, `readme`, `demo`, and `lastActivityOn` fields; require README and demo links, record `PortfolioUpdated`, and finish. |

Apply the spec's application standards through the approved specification and
specialists. A specification-only outcome is `planned`, partial implementation
is `building`, and an unresolved obstacle may be `blocked`; update the portfolio
accurately at handoff as well as after shipment. Do not use `shipped` as a label
for a drafted spec, passing unit tests, or an unmerged PR.

## `continue <idea-id>` and recovery

Load the Idea issue, local handoff, referenced artifacts, approval evidence,
branch/worktree, and pending operations. Reconcile actual local/remote outcomes
before advancing. Resume the recorded next action, not discovery or completed
steps. A human resuming `Paused` passes through `ScopeAssessment` to confirm
whether the saved route is still clear, retaining completed work and approvals.
An unresolved gate remains that gate until its specific decision is supplied.

From `Selected`, Wayfinder, research, spec work, implementation, or verification,
a stop or blocker enters `DailyHandoff`. Retry a clearly transient failure once;
otherwise preserve evidence and stop. Record state, substantive status, session
condition `Paused`, completed artifacts, branch/commit, test/review evidence,
blocker, pending mutations, approvals still needed, and the exact next action.
Preserve prior `planned`, `building`, or `blocked` progress when pausing. Failure
before selection stays in the accurate discovery state with a pending draft;
an approval wait retains its `Awaiting...` state. Report the recovery action in
Codex. Missing required skills, unavailable credentials, and unresolved state
conflicts are blockers, not permission to substitute a weaker procedure.

## `status`

Read repository and GitHub records and summarize current ideas, substantive
statuses, machine states, latest brief, pending approvals, blockers, and exact
next actions. Mark unavailable or conflicting evidence as unknown. Make no
artifact, issue, label, portfolio, or automation changes.
