# Research-to-Repo

Research-to-Repo is a Codex-controlled, GitHub-backed workflow for turning
research, open-source libraries, and existing-project opportunities into
well-documented portfolio projects. It produces a ranked daily brief, preserves
the backlog, and routes selected work through research, design, planning,
implementation, review, and verification.

This is a **document-driven** system. It intentionally has no custom app,
service, database, or CLI: Markdown, YAML, GitHub Issues, the Codex task, and
specialist Codex skills are its operating surface.

## Architecture and workspace

One persistent Codex Control Task is the human control plane. The
`research-to-repo` Git repository is the orchestration repository and GitHub
Issues are the durable ledger for Ideas and system-level Wayfinder Maps. Each
selected project gets its own application repository; its implementation
tickets, code, tests, and delivery material live there.

On this host the repository root is
`/Users/jayaramanvenkatesan/Documents/Personal-Project/research-to-repo`;
`Personal-Project` is the workspace container, not a Git repository. The expected
local workspace is:

```text
Personal-Project/
├── research-to-repo/  # This orchestration repository
├── projects/          # Separate application repositories
└── prototypes/        # Throwaway design probes
```

The version-controlled skill at
`.agents/skills/research-to-repo/SKILL.md` is the source of truth. The
canonical lifecycle is
[`docs/workflow/development-state-machine.md`](docs/workflow/development-state-machine.md).

## Setup

From this repository, install a personal symlink to the skill:

```bash
scripts/install-skill.sh
```

The installer targets `${CODEX_HOME:-$HOME/.codex}/skills/research-to-repo`.
It creates only the target parent directory, leaves a correct link alone,
replaces a stale link, and refuses to overwrite a non-symlink. To test or use a
separate Codex home, set `CODEX_HOME` before running it:

```bash
CODEX_HOME=/path/to/codex-home scripts/install-skill.sh
```

Before any operation that reads or writes GitHub, authenticate the GitHub CLI
for the intended account and verify its state:

```bash
gh auth login
gh auth status
```

Authentication is capability, not authorization. It does not authorize a
repository, default-branch write, issue mutation, pull request, release,
account, credential, cost, or external-service action.

## Operating the skill

Use the installed skill in the persistent Codex Control Task:

```text
$research-to-repo daily
$research-to-repo select <idea-id>
$research-to-repo continue <idea-id>
$research-to-repo status
```

- `daily` creates or resumes only the current `America/Detroit` day's brief;
  it never creates a catch-up burst.
- `select <idea-id>` records a single human selection and routes work through
  scope assessment.
- `continue <idea-id>` resumes the durable handoff and recorded next action;
  it does not repeat completed discovery.
- `status` reports durable records and pending decisions without mutations.

Daily briefs rank three candidates: a paper/algorithm application, a
library/SDK application, and an existing-project extension. They include at
least one new and at most two resurfaced ideas. Every unselected idea remains
available in the open backlog unless the human explicitly rejects it.

## Approval gates

Selection is not blanket authority. The Control Task must stop for the
relevant human decision at every consequential gate, including product scope
and UX, architecture and significant dependencies, ADRs, specification,
tickets, repository proposal, accounts/credentials/terms/costs, pull-request
creation, and release.

The canonical state machine distinguishes approvals: specification approval
permits ticket drafting; ticket approval permits the repository proposal;
repository approval permits readiness and implementation; release approval
permits the pull request. A public repository, pull request, and shipped
status are never automatic.

Standing synchronization approval covers `origin` at
`https://github.com/jayaraman-venkatesan/research-to-repo.git` and non-default
branch `automation/daily-briefs`. Pushes are limited to dated briefs, cited
research notes, and checkpoints/handoffs, with related Idea-state updates in
GitHub Issues. Application code never goes on this branch. Workflow rules,
templates, portfolio changes, and other remote mutations need their own
applicable approval. A local artifact is not GitHub-persisted until the approved
branch is pushed and its contents are read back. See the
[operational configuration](docs/operations/heartbeat.md) for the verified setup
and live approved heartbeat prompt.

## Recovery and daily operation

The heartbeat is configured for 8:00 AM `America/Detroit`; its approved prompt
and the synchronization branch were applied and read back on 2026-09-16 as
documented in [`docs/operations/heartbeat.md`](docs/operations/heartbeat.md).
Manual invocation of `$research-to-repo daily` is the fallback.

Daily work is idempotent. Even in a fresh checkout with no local brief or
checkpoint, read the remote synchronization branch, dated checkpoint, and Idea
record before declaring a new run. Quiet behavior requires all three proofs:
verified GitHub artifact persistence, Codex delivery, and remotely recorded
`AwaitingSelection`. A dated or persisted brief alone is insufficient. If any
proof is missing, reconcile local, GitHub, and task records, then resume saved
discovery, delivery, or synchronization. Unknown remote state cannot justify a
new run.

On interruption or failure, retry one clearly transient failure. Otherwise,
preserve artifacts and evidence in `docs/research/<idea-id>/handoff.md`, record
the current state, substantive status, branch/commit, blocker, pending
mutations, approvals still required, and exact next action, then stop in the
Control Task. GitHub unavailability may leave a local draft, but it cannot
advance a remote state transition or be claimed as persisted on GitHub.

## Project standards

Selected projects use an isolated branch or worktree. TypeScript is the default
for interactive UI; C# or Python is the default for backend and scientific
work. Different choices need a concrete reason in the approved specification
or an ADR. Projects are local-first, containerized, license-checked (MIT is the
default after compatibility review), and protect secrets with `.env.example`.

`shipped` means a verified, documented runnable release: tests, lint, type
checking where applicable, production build, container build/startup smoke test,
setup and usage docs, example data where needed, compatible license, demo
media, and an approved merged pull request. A specification-only result is
`planned`; partial code is `building`.

## Limitations and scope

The workflow does not create repositories or pull requests automatically,
reconfigure the heartbeat during a daily run, run a custom workflow engine, or
use paid discovery/deployment services. It relies on Codex, GitHub, network
access, and the required specialist skills being available. If repeated use
reveals a failure that documents and checklists cannot prevent, add only the
necessary deterministic tooling later through an ADR.
