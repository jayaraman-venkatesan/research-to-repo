# ADR 0001: Use Codex as the Control Plane and GitHub as Durable State

**Status:** Accepted

**Date:** 2026-09-15

## Context

The workflow must discover project ideas daily, preserve an idea backlog, let the human drive consequential decisions from the Codex app, and leave durable artifacts that survive conversation compaction. Selected ideas become separate public GitHub repositories, while the workflow itself needs versioned rules, research notes, decision history, and a portfolio index.

Three architectures were considered:

1. A persistent Codex task backed by a central GitHub repository and GitHub Issues.
2. GitHub-native automation controlled primarily through Issues and Actions.
3. A custom MCP control application built before the daily workflow.

## Decision

Use one persistent Codex task as the human control plane and one central `research-to-repo` GitHub repository as durable workflow state.

The Codex task posts daily briefs and receives selections and approvals. The repository stores the workflow, dated briefs, research, ADRs, project index, and the source-controlled orchestration skill. GitHub Issues store idea history and Wayfinder decision maps. Each selected application uses a separate repository.

The daily heartbeat runs at 8:00 AM `America/Detroit`. Public repository creation, pull-request creation, external services, and releases remain explicit human approval gates.

## Consequences

### Positive

- The human controls decisions from Codex without needing a separate mobile application.
- GitHub provides durable, auditable state across sessions and devices.
- Project repositories remain independent and portfolio-ready.
- The orchestration skill can stay small by routing to specialized skills.
- A future MCP App can be added without replacing the underlying workflow state.

### Negative

- Codex and GitHub must both be available for a fully persisted daily run.
- The workflow must keep conversation state and GitHub state synchronized.
- Repository and issue permissions must be configured before full automation works.
- A persistent task requires idempotent automation to avoid duplicate briefs and issues.

## Rejected Alternatives

### GitHub-native control

This would make GitHub—not Codex—the approval surface and conflict with the desired interaction model. It also adds Actions and authentication infrastructure before the core workflow is proven.

### Custom MCP control application first

This may become a useful portfolio project later, but building it first delays the research-to-project loop and duplicates capabilities already provided by Codex and GitHub.
