# Daily Brief — 2026-09-15 — fictional rehearsal

This is a rehearsal of `daily`, using the [daily brief template](../templates/daily-brief.md).
All candidates, sources, issue references, approvals, and remote evidence are
fictional fixtures. `example.invalid` links are inert illustrations and were not
opened. The fixed Detroit date is a test input, not a live scheduled run.
There was no external mutation. This file is test evidence, not a completed
`docs/briefs/2026-09-15.md` or a live workflow checkpoint.

## Recommendation

Rank 1: Window Queue Lab (paper, 17/20); rank 2: Trace Loom (library, 16/20);
rank 3: Route Board Replay (existing extension, 15/20). Scores sum four equally
weighted 1–5 criteria: usefulness, explanatory value, feasibility, portfolio
quality. Research age does not affect ranking. The paper leads because the
fictional small, reproducible example supports both a useful queue comparison
and an interactive explanation. No recommendation here is based on real research.

## 1. Paper or algorithm application

- **Idea ID:** `paper-fx-p01-window-queue-lab`
- **New/Resurfaced:** Resurfaced; first discovered 2026-09-08; `backlog`.
- **Previous appearances:** 2026-09-09, 2026-09-12; proposed appearance 2026-09-15.
- **Pitch:** Let workshop planners compare queue schedules while stepping through a fictional bounded-window algorithm.
- **Primary sources:** [Fictional paper FX-P01](https://example.invalid/papers/fx-p01), [fictional author example and terms](https://example.invalid/papers/fx-p01/code).
- **Why it matters:** Planners need to see which job waits and why; it resurfaces because the fixture now includes a complete three-job trace that reduces reproduction uncertainty.
- **Useful application:** Compare total waiting time for two local workshop schedules.
- **Interactive experience:** Edit three job durations, advance the trace, and inspect the queue and waiting-time comparison.
- **Suggested stack:** Proposed TypeScript UI and pure local calculation, static app served by a container; architecture awaits approval.
- **One-day vertical slice:** One editable three-job example, step controls, waiting-time result, automated checks, container startup, and explanatory README.
- **Longer-term potential:** Compare larger workshop schedules and export an explanation of waiting-time trade-offs after validating the general algorithm.
- **Risks:** The fixture proves only a tiny example; no general performance claim, real upstream license, or real reproducibility result is established.
- **Likely Wayfinder decisions:** For later expansion, establish valid schedule bounds and choose which comparison metrics planners need; the tiny initial fixture has a clear route.
- **Score:** 17/20: usefulness 4 (planning comparison), explanation 5 (visible trace), feasibility 4 (small deterministic input), portfolio 4 (application plus explanation).
- **Next decision:** Select this candidate for scope assessment, defer it, or explicitly reject it; selection does not approve its scope or repository.

## 2. Open-source library or SDK application

- **Idea ID:** `library-fx-l01-trace-loom`
- **New/Resurfaced:** New in the fixture; first discovered 2026-09-15; proposed `backlog`.
- **Previous appearances:** None; proposed first appearance 2026-09-15.
- **Pitch:** Help local tool authors inspect structured traces using the fictional Trace Loom SDK.
- **Primary sources:** [Fictional official SDK documentation](https://example.invalid/sdk/fx-l01), [fictional source and license](https://example.invalid/sdk/fx-l01/source).
- **Why it matters:** The fixture SDK parses deterministic traces without an account, keeping an inspection tool small enough to build and explain.
- **Useful application:** Load a synthetic trace and identify its slowest operation.
- **Interactive experience:** Select an operation to see duration and its parent chain.
- **Suggested stack:** Proposed TypeScript UI with the fictional SDK adapter; static container; dependency acceptance awaits approval and real verification.
- **One-day vertical slice:** One synthetic trace fixture, local load, duration table, linked detail panel, error state, tests, and README.
- **Longer-term potential:** Compare trace sessions and explain nested operations once import behavior and useful scale are established.
- **Risks:** Parser maintenance and malformed traces; actual SDK availability, compatibility, and licenses remain unverified outside this fixture.
- **Likely Wayfinder decisions:** Verify offline parsing capability, then ask the human to choose import size and malformed-event behavior; the uncertain-route rehearsal maps these questions.
- **Score:** 16/20: usefulness 4 (trace inspection), explanation 4 (parent chain), feasibility 5 (one local trace), portfolio 3 (less distinctive).
- **Next decision:** Select, defer as an open backlog Idea, or explicitly reject.

## 3. Existing project extension

- **Idea ID:** `extension-fx-e01-route-board-replay`
- **New/Resurfaced:** Resurfaced; first discovered 2026-09-07; `backlog`.
- **Previous appearances:** 2026-09-10; proposed appearance 2026-09-15.
- **Pitch:** Add step-by-step route replay to the fictional existing Route Board project so dispatchers can explain a route choice.
- **Primary sources:** [Fictional existing Route Board repository](https://example.invalid/projects/route-board), [fictional extension discussion](https://example.invalid/projects/route-board/discussions/fx-e01).
- **Why it matters:** Dispatchers need to explain reroutes; it resurfaces because a supplied fixture handoff identifies an isolated replay seam in the existing app.
- **Useful application:** Compare an original and revised delivery order on a local synthetic map.
- **Interactive experience:** Step along both routes and inspect accumulated travel cost.
- **Suggested stack:** Retain the fixture project's TypeScript UI and Python route engine in an approved isolated worktree; containerized local run.
- **One-day vertical slice:** Replay one saved route comparison, preserve existing behavior, document an example, and verify the container.
- **Longer-term potential:** Add alternative route constraints and explanations of the cost of each dispatcher choice after the replay seam is proven.
- **Risks:** Real repository existence and change scope are unverified; no unfinished project may be overwritten or replaced to fill this slot.
- **Likely Wayfinder decisions:** Confirm ownership of the replay seam and decide whether later scope includes editing a route or only explaining saved routes.
- **Score:** 15/20: usefulness 4 (explain reroutes), explanation 4 (visible cost), feasibility 3 (integration seam), portfolio 4 (meaningful continuation).
- **Next decision:** Select this extension, defer it, or explicitly reject; any later work requires target-repository and change-scope approval.

## Backlog changes

Propose updating fictional Idea issues FX-101 and FX-103 and creating FX-102
only after a final duplicate check. Each remains open with `idea:backlog` and
its category label until a human chooses. Merge 2026-09-15 into appearances
once; preserve discovery dates, earlier decisions, sources, and handoffs.
Ordinary non-selection keeps these Ideas in `Backlog`; it is not rejection.
If an already selected or paused project replaces the extension fixture in a
future test, preserve its substantive status and work instead of resetting it
to backlog. Detailed [proposed issue payloads and checkpoints](../research/rehearsal/README.md#proposed-issue-mutations)
are rehearsal evidence only.

## Research notes

The [fictional research notes](../research/rehearsal/README.md#fictional-primary-source-fixtures)
record source claims, license assumptions, reproduction traces, and duplicate
checks. Rotation result: exactly three categories, one new candidate and two
resurfaced candidates, with dated histories and reasons for resurfacing.

Proposed Control Task delivery: “Window Queue Lab leads at 17/20, followed by
Trace Loom at 16/20 and Route Board Replay at 15/20. Choose one, defer all, or
explicitly reject an Idea.” Actual next action: review this rehearsal evidence;
no live selection, issue creation, repository approval, or heartbeat activation
has occurred. The [recovery scenario](../research/rehearsal/README.md#github-unavailability-and-recovery)
is explicitly unpersisted to GitHub and cannot claim a completed daily run.
Additional fictional scenarios cover
[recovery with no local state](../research/rehearsal/README.md#missing-local-state-and-remote-checkpoint-recovery)
and [Wayfinder decisions](../research/rehearsal/README.md#uncertain-route-through-wayfinder).
