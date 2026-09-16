# Research-to-Repo Lean Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Establish a lean, Markdown-driven Codex workflow that discovers daily project ideas, tracks them in GitHub, routes selected work through the approved engineering skills, and stops at every human decision gate.

**Architecture:** The repository stores the canonical workflow, templates, idea and portfolio records, and a thin Codex skill. Codex follows those documents and uses GitHub Issues as durable state; no custom CLI, service, database, or state engine is built initially. A daily heartbeat invokes the skill in the persistent control task after a no-mutation rehearsal passes.

**Tech Stack:** Markdown, YAML, Mermaid, Bash, Git, GitHub Issues and CLI, Codex skills and heartbeat automation.

**Spec:** `docs/superpowers/specs/2026-09-15-research-to-repo-design.md`

## Global Constraints

- Codex is the human control plane; GitHub is durable state.
- The brief is scheduled for 8:00 AM `America/Detroit`, with one current brief and no catch-up burst.
- Public repositories, pull requests, external accounts, costs, and releases require explicit approval.
- Each brief offers the three approved categories, with at least one new and at most two resurfaced ideas.
- Shortlisted claims require primary-source verification; research age is unrestricted.
- Unselected ideas and unfinished work are preserved.
- The orchestration skill routes to specialist skills instead of copying their procedures.
- Setup remains local until publishing the control repository and enabling the heartbeat are separately approved.

---

## File Map

```text
AGENTS.md                                      Always-on workflow routing
CONTEXT.md                                     Canonical glossary
README.md                                      Setup and operator guide
.agents/skills/research-to-repo/SKILL.md       Thin orchestration skill
.github/ISSUE_TEMPLATE/idea.yml                Durable idea issue form
docs/agents/issue-tracker.md                   GitHub conventions
docs/agents/domain.md                          Domain-document conventions
docs/operations/heartbeat.md                   Schedule and recovery
docs/templates/daily-brief.md                  Brief template
docs/templates/project-proposal.md             Repository approval template
docs/briefs/.gitkeep                           Dated brief destination
docs/research/.gitkeep                         Cited research destination
portfolio/projects.yaml                        Project index
scripts/install-skill.sh                       Safe skill installer
```

### Task 1: Configure agent routing and vocabulary

**Files:**
- Create: `AGENTS.md`
- Create: `CONTEXT.md`
- Create: `docs/agents/issue-tracker.md`
- Create: `docs/agents/domain.md`

**Interfaces:**
- Consumes: the approved spec, state machine, ADR 0001, and installed skills.
- Produces: repository-wide routing, vocabulary, and GitHub issue rules.

- [ ] **Step 1: Add agent instructions**

Include this mandatory block in `AGENTS.md`:

```markdown
## Research-to-Repo workflow

Use the `research-to-repo` skill for daily discovery, idea selection, or
continuation of tracked work. Treat
`docs/workflow/development-state-machine.md` as canonical and stop at every
human approval gate.

Use the specialist skill named by the orchestrator rather than reproducing
its procedure. Never create a public repository, pull request, external
account, paid resource, or release without explicit approval in Codex.
```

- [ ] **Step 2: Define the glossary**

In `CONTEXT.md`, precisely define Idea, Candidate, Daily Brief, Backlog, Selected Project, Decision Gate, Wayfinder Map, Daily Handoff, Shipped, Control Task, Orchestration Repository, and Project Repository. Keep implementation details out.

- [ ] **Step 3: Record issue conventions**

State in `docs/agents/issue-tracker.md` that ideas and system-level Wayfinder maps live in this repository's GitHub Issues, while project tickets live in each project repository. Define these labels:

```text
idea
idea:backlog
idea:selected
idea:archived
category:paper-app
category:library-app
category:existing-extension
wayfinder:map
wayfinder:research
wayfinder:prototype
wayfinder:grilling
wayfinder:task
```

Require searching by stable idea ID before issue creation and prohibit direct default-branch work.

- [ ] **Step 4: Record domain-document conventions**

Declare a single-context repository with root `CONTEXT.md` and `docs/adr/`. Record the ADR threshold: hard to reverse, surprising without context, and selected through a real trade-off.

- [ ] **Step 5: Verify and commit**

```bash
rg -n "state-machine|approval|issue|ADR" AGENTS.md CONTEXT.md docs/agents
git diff --check
git add AGENTS.md CONTEXT.md docs/agents
git commit -m "docs: configure research-to-repo agent workflow"
```

### Task 2: Add durable workflow templates

**Files:**
- Create: `.github/ISSUE_TEMPLATE/idea.yml`
- Create: `docs/templates/daily-brief.md`
- Create: `docs/templates/project-proposal.md`
- Create: `docs/briefs/.gitkeep`
- Create: `docs/research/.gitkeep`
- Create: `portfolio/projects.yaml`

**Interfaces:**
- Consumes: verified research candidates and decisions.
- Produces: consistent idea issues, briefs, repository proposals, and portfolio entries.

- [ ] **Step 1: Create the idea issue form**

Require Idea ID, discovery date, appearance dates, category, status, pitch, users, primary sources, usefulness, interactive experience, one-day slice, risks, license/reproducibility notes, score rationale, and next decision. Default labels are `idea` and `idea:backlog`.

- [ ] **Step 2: Create the daily brief template**

```markdown
# Daily Brief — YYYY-MM-DD

## Recommendation

<Ranked recommendation and why it leads today>

## 1. Paper or algorithm application
## 2. Open-source library or SDK application
## 3. Existing project extension

Each candidate includes: Idea ID, New/Resurfaced, Previous appearances,
Pitch, Primary sources, Why it matters, Useful application, Interactive
experience, Suggested stack, One-day vertical slice, Risks, Score, and
Next decision.

## Backlog changes
## Research notes
```

- [ ] **Step 3: Create the repository approval template**

Include name, description, visibility, license, initial structure, technology choices, upstream-license findings, estimated scope, and the exact approval question. Default to public and MIT without acting until approval.

- [ ] **Step 4: Seed the portfolio**

```yaml
version: 1
projects: []
```

Document that future entries contain `ideaId`, `name`, `repository`, `status`, `researchBasis`, `readme`, `demo`, and `lastActivityOn`. A shipped entry requires README and demo links.

- [ ] **Step 5: Verify and commit**

```bash
git diff --check
rg -n "Idea ID|Primary sources|Next decision" .github/ISSUE_TEMPLATE/idea.yml docs/templates/daily-brief.md
rg -n "projects: \[\]" portfolio/projects.yaml
git add .github docs/templates docs/briefs docs/research portfolio
git commit -m "docs: add idea and portfolio templates"
```

### Task 3: Create the thin orchestration skill

**Files:**
- Create: `.agents/skills/research-to-repo/SKILL.md`

**Interfaces:**
- Consumes: `daily`, `select <idea-id>`, `continue <idea-id>`, or `status`; repository records; GitHub Issues; installed skills.
- Produces: a persisted brief or the next allowed action, followed by a human gate.

- [ ] **Step 1: Add frontmatter**

```yaml
---
name: research-to-repo
description: Orchestrate daily research-to-GitHub discovery, backlog tracking, human decision gates, project specification, implementation routing, and portfolio updates.
---
```

- [ ] **Step 2: Define `daily` mode**

The skill must:

1. Determine the current `America/Detroit` date and stop quietly if its persisted brief exists.
2. Read the spec, state machine, portfolio, open idea issues, and recent briefs.
3. Use broad discovery, then invoke `research` for primary-source verification and a cited note in `docs/research/<idea-id>/`.
4. Produce the three approved candidate categories.
5. Assign a stable, lowercase ID from category, canonical source, and title; search local records and GitHub before declaring it new.
6. Rank new and backlog ideas together, with at least one new and at most two resurfaced.
7. In rehearsal, show proposed mutations only; otherwise persist the brief and idempotently create or update issues.
8. Post the concise brief in Codex and stop for selection.

- [ ] **Step 3: Define other modes**

`select <idea-id>` records selection, applies `idea:selected`, assesses scope, and routes uncertain work to `wayfinder`. Clear work proceeds through brainstorming/domain modeling, spec approval, tickets, repository approval, implementation, review, verification, PR approval, and portfolio update.

`continue <idea-id>` loads its durable handoff and resumes at its recorded next action. `status` summarizes without mutation.

- [ ] **Step 4: Encode safety and recovery**

Never cross a consequential gate, create a public repository or PR automatically, commit secrets, or discard work. Retry one clearly transient failure; otherwise record evidence and the exact next action and stop in the accurate durable state.

- [ ] **Step 5: Check against the state machine and commit**

Confirm every state-machine edge is handled or routed to a named specialist skill, without copying specialist procedures.

```bash
rg -n "daily|select|continue|status|approval|wayfinder|research|shipped" .agents/skills/research-to-repo/SKILL.md
git diff --check
git add .agents/skills/research-to-repo/SKILL.md
git commit -m "feat: add research-to-repo orchestration skill"
```

### Task 4: Add installation and operator documentation

**Files:**
- Create: `scripts/install-skill.sh`
- Create: `README.md`
- Create: `docs/operations/heartbeat.md`

**Interfaces:**
- Consumes: local checkout and optional `CODEX_HOME`.
- Produces: a personal skill symlink and operating instructions; no publication or scheduling.

- [ ] **Step 1: Create the safe installer**

Use `set -euo pipefail`. Resolve the repo root from the script location and target `${CODEX_HOME:-$HOME/.codex}/skills/research-to-repo`. Create only the parent directory, refuse to overwrite a non-symlink, leave a correct symlink unchanged, report and replace a stale symlink, then link to `.agents/skills/research-to-repo`.

- [ ] **Step 2: Test installation in a temporary home**

```bash
test_root="$(mktemp -d)"
CODEX_HOME="$test_root" scripts/install-skill.sh
test -L "$test_root/skills/research-to-repo"
CODEX_HOME="$test_root" scripts/install-skill.sh
readlink "$test_root/skills/research-to-repo"
```

Expected: both runs exit `0`, one symlink exists, and it resolves to the repository skill.

- [ ] **Step 3: Write README and heartbeat docs**

README covers purpose, architecture, workspace, setup, skill modes, approval gates, GitHub authentication, operation, recovery, project standards, and limitations. State that the system is document-driven with no custom app or CLI.

Heartbeat docs include the schedule, missed-run behavior, manual fallback, quiet unchanged-state behavior, and this prompt:

```text
Invoke $research-to-repo in daily mode. Work in the research-to-repo project. Generate at most one brief for the current America/Detroit date. Stay quiet if today's persisted brief already exists. Preserve all unselected ideas. Notify me with the three ranked candidates, or when a meaningful failure or required human decision occurs. Stop for selection and every approval gate in the canonical state machine.
```

- [ ] **Step 4: Verify and commit**

```bash
bash -n scripts/install-skill.sh
git diff --check
rg -n "document-driven|approval|8:00 AM|America/Detroit" README.md docs/operations/heartbeat.md
git add scripts/install-skill.sh README.md docs/operations/heartbeat.md
git commit -m "docs: add skill setup and operations guide"
```

### Task 5: Rehearse the workflow without mutations

**Files:**
- Create: `docs/briefs/2026-09-15-rehearsal.md`
- Create: `docs/research/rehearsal/README.md`
- Modify: `.agents/skills/research-to-repo/SKILL.md` only for ambiguity revealed by rehearsal

**Interfaces:**
- Consumes: Task 1–4 artifacts and fictional research inputs.
- Produces: evidence that the workflow can be followed without GitHub or automation mutations.

- [ ] **Step 1: Rehearse `daily`**

Use three clearly fictional candidates, one per category. Do not browse, create issues or repositories, or configure automation. Produce the rehearsal brief and list the issue mutations that would be proposed.

- [ ] **Step 2: Rehearse rotation and approvals**

Treat two candidates as backlog and one as new. Confirm the brief shows one new and no more than two resurfaced items with dates. Simulate selecting one and walk to repository creation, confirming stops for scope, spec, tickets, and repository approval.

- [ ] **Step 3: Rehearse failure recovery**

Simulate GitHub unavailability. Confirm one transient retry is described, the draft is marked unpersisted to GitHub, evidence and next action are recorded, and no success is claimed.

- [ ] **Step 4: Fix only revealed ambiguity, then commit evidence**

```bash
git diff --check
rg -n "fictional|rehearsal|no external mutation|next action" docs/briefs/2026-09-15-rehearsal.md docs/research/rehearsal/README.md
git add docs/briefs/2026-09-15-rehearsal.md docs/research/rehearsal/README.md .agents/skills/research-to-repo/SKILL.md
git commit -m "test: rehearse research-to-repo workflow"
```

### Task 6: Publish and schedule after separate approvals

**Files:**
- Modify: `docs/operations/heartbeat.md`

**Interfaces:**
- Consumes: successful rehearsal and explicit publication and heartbeat approvals.
- Produces: public control repo, labels, installed skill, and active heartbeat.

- [ ] **Step 1: Present and approve the control repository proposal**

```text
Name: research-to-repo
Visibility: public
Description: A Codex-controlled workflow that turns research and open-source ideas into verified GitHub projects.
License: MIT
Initial branch: main
```

Wait for explicit approval. This covers only the control repository.

- [ ] **Step 2: Create and verify it after approval**

```bash
gh repo create research-to-repo --public --source=. --remote=origin --description "A Codex-controlled workflow that turns research and open-source ideas into verified GitHub projects."
git push -u origin main
gh repo view --json name,visibility,url,defaultBranchRef
```

Stop if the authenticated owner is unexpected or the name is occupied.

- [ ] **Step 3: Create labels and install the skill**

Create exactly the labels in `docs/agents/issue-tracker.md`, verify them with `gh label list`, run `scripts/install-skill.sh`, and confirm the personal path resolves to the repository skill.

- [ ] **Step 4: Present and approve the heartbeat separately**

Show the exact prompt and `8:00 AM America/Detroit` schedule. Create one active heartbeat named `Daily research-to-repo brief` only after explicit approval.

- [ ] **Step 5: Verify, record, commit, and push**

Read back the heartbeat name, schedule, target task, active state, prompt, and quiet behavior. Record only non-secret metadata.

```bash
git add docs/operations/heartbeat.md
git commit -m "ops: record daily research heartbeat"
git push
```

## Final Verification

1. Run `git diff --check` and confirm a clean worktree.
2. Confirm every path in `AGENTS.md` and `README.md` exists.
3. Confirm the personal skill symlink resolves to the repository source.
4. Compare the skill line-by-line with the canonical state machine.
5. Confirm the rehearsal produced no external mutation.
6. Run the two-axis code review against the commit preceding Task 1.
7. Resolve all Critical and Important findings and repeat the checks.
8. Treat publication and heartbeat configuration as separate approvals.
