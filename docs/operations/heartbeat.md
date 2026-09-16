# Daily research-to-repo heartbeat

## Live configuration

Configured after separate human approval and verified by app read-back on
2026-09-16:

- Name: `Daily research-to-repo brief`
- Automation ID: `daily-research-to-repo-brief`
- Status: `ACTIVE`
- Schedule: daily at 8:00 AM in the host's `America/Detroit` timezone
- Destination: the persistent Codex Control Task for research-to-repo
- Prompt: the unchanged prompt below

## Intended schedule

After a successful no-mutation rehearsal and a separate explicit human
approval, configure one active heartbeat named `Daily research-to-repo brief`
for 8:00 AM `America/Detroit` in the persistent Codex Control Task. Installation
of the skill, publication of the orchestration repository, and heartbeat
activation are distinct actions and approvals. This document does not schedule
or activate anything.

Use this prompt unchanged:

```text
Invoke $research-to-repo in daily mode. Work in the research-to-repo project. Generate at most one brief for the current America/Detroit date. Stay quiet if today's persisted brief already exists. Preserve all unselected ideas. Notify me with the three ranked candidates, or when a meaningful failure or required human decision occurs. Stop for selection and every approval gate in the canonical state machine.
```

## Quiet and missed runs

The heartbeat stays quiet when the current day's run is fully persisted: the
dated brief exists and its checkpoint confirms verified remote artifacts, Codex
delivery evidence, and a remotely recorded `AwaitingSelection` state. A dated
file alone is not enough to suppress work; incomplete proof is reconciled and
the saved pending operation is resumed.

If Codex is unavailable at 8:00 AM, run once when it next becomes available for
the current `America/Detroit` date. Do not create missed-day or multi-day
catch-up briefs. The skill remains quiet when nothing changed, and notifies the
Control Task only with the three ranked candidates, a meaningful failure, or a
required human decision.

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
