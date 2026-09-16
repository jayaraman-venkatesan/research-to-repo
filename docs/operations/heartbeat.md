# Daily research-to-repo heartbeat

## Last verified live configuration

Configured after separate human approval and verified by app read-back on
2026-09-16:

- Name: `Daily research-to-repo brief`
- Automation ID: `daily-research-to-repo-brief`
- Status: `ACTIVE`
- Schedule: daily at 8:00 AM in the host's `America/Detroit` timezone
- Destination: the persistent Codex Control Task for research-to-repo
- Prompt: the initial prompt is superseded by the approved replacement below;
  updating the live automation and reading it back are pending controller steps.

## Repository and synchronization boundary

The repository root on this host is
`/Users/jayaramanvenkatesan/Documents/Personal-Project/research-to-repo`.
`Personal-Project` is its workspace container, not the Git repository. Resolve
this checkout even when the Control Task is saved against the container or the
personal skill currently links to a worktree. Verify `origin` is
`https://github.com/jayaraman-venkatesan/research-to-repo.git` before operating.

The human approved the standing non-default synchronization branch
`automation/daily-briefs` on 2026-09-16. Branch creation and remote read-back are
pending controller steps. Subsequent pushes are limited to dated briefs, cited
research notes, and checkpoints/handoffs; related Idea-state updates belong in
GitHub Issues. Application code never goes on this branch. Workflow rules,
templates, portfolio changes, other branches, PRs, and repositories require
their own applicable approval. The skill checks the intended commits and files
against this scope and verifies remote contents after each synchronization.

## Schedule and activation policy

Initial activation requires a successful no-mutation rehearsal and separate
explicit human approval for one heartbeat named `Daily research-to-repo brief`
at 8:00 AM `America/Detroit` in the persistent Codex Control Task. Update the
existing automation identified above; do not create a duplicate. Installation
of the skill, publication of the orchestration repository, and heartbeat
activation are distinct actions and approvals. This document does not schedule
or activate anything.

## Approved replacement prompt

The human approved this update on 2026-09-16. Apply it to the existing automation
ID above, preserving its schedule, target, active status, and notification
settings. Verify the saved prompt by app read-back before recording the update
as live. This document alone does not update the automation.

Use this prompt unchanged:

```text
Invoke $research-to-repo in daily mode. Resolve the repository at /Users/jayaramanvenkatesan/Documents/Personal-Project/research-to-repo; Personal-Project is only its workspace container. Verify origin is https://github.com/jayaraman-venkatesan/research-to-repo.git. Use the approved non-default synchronization branch automation/daily-briefs only for dated briefs, cited research notes, checkpoints/handoffs, and related Idea-state updates in GitHub Issues; application code never goes on that branch. Before declaring a new current-date run, look up the remote branch, today's remote checkpoint, and the Idea record even if local files are absent, then reconcile or resume existing state. Generate at most one brief for the current America/Detroit date, with no catch-up briefs. Stay quiet only after all three proofs are confirmed: verified GitHub persistence of the brief and cited artifacts, Codex brief delivery, and remotely recorded AwaitingSelection. A dated or persisted brief alone is insufficient; resume pending synchronization or delivery first. Preserve all unselected ideas. Notify me with the three ranked candidates, or when a meaningful failure or required human decision occurs. Stop for selection and every approval gate in the canonical state machine.
```

## Quiet and missed runs

Before deciding whether the current day's run exists, read the current remote
branch, dated checkpoint, and lead Idea record even when the local brief and
checkpoint are missing. If the remote checkpoint is absent, search all-state
Idea bodies for `Daily run: YYYY-MM-DD`. Restore or reconstruct any existing
checkpoint and reconcile task history before resuming its pending operation.
Unavailable or conflicting evidence cannot establish absence or completion.

The heartbeat stays quiet only after all three completion proofs are confirmed:
verified GitHub artifact persistence, Codex brief delivery, and remotely recorded
`AwaitingSelection`. A dated or persisted brief alone is insufficient. Resume a
missing delivery; if delivery is already confirmed, recover only the pending
checkpoint/state synchronization. Ambiguous delivery requires a task-history
check before posting. The skill defines the complete recovery procedure.

If Codex is unavailable at 8:00 AM, run once when it next becomes available for
the current `America/Detroit` date. Do not create missed-day or multi-day
catch-up briefs. A complete unchanged run stays quiet. Notify the Control Task
only with the three ranked candidates, a meaningful failure, or a required
human decision.

## Manual fallback and recovery

When the heartbeat is not configured, disabled, or missed, invoke
`$research-to-repo daily` manually in the persistent Control Task. Use
`$research-to-repo status` to inspect durable records without mutations, or
`$research-to-repo continue <idea-id>` to resume a selected Idea's recorded
handoff.

The canonical lifecycle is
[`docs/workflow/development-state-machine.md`](../workflow/development-state-machine.md).
The skill must stop for selection and every approval gate. For a non-transient
failure, preserve evidence, state, substantive status, pending mutations,
required approvals, and the exact next action in the durable handoff. A clearly
transient failure may be retried once. Never claim a locally retained draft or
an unverified push as GitHub-persisted state.
