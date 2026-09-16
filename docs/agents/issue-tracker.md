# Issue tracker conventions

This Orchestration Repository's GitHub Issues hold Ideas and system-level
Wayfinder Maps. Project tickets belong in the GitHub Issues of the relevant
Project Repository.

## Labels

Use only the following workflow labels for the corresponding issue roles:

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

## Creation and branch rules

Before creating an Idea issue, search GitHub Issues by its stable idea ID.
Update the existing issue when that ID is already present; do not create a
duplicate. Direct work on a repository's default branch is prohibited. Use an
isolated branch or worktree for all repository changes, and request approval
before creating a pull request.

## Wayfinding operations

Use GitHub Issues for the map and its decision tickets, native sub-issues for
children, assignees for claims, and native issue dependencies for blocking.
System maps live here. A selected project's map belongs in its approved Project
Repository; before that repository exists, keep the map and children here,
linked from the Idea, and retain links to their location after repository
readiness. Implementation tickets still belong in the Project Repository.
Creating a map never authorizes creating a repository.

The following are operation recipes, not permission to mutate GitHub. Apply
the recorded scope and human gates, and show proposals only during rehearsal.
Replace `OWNER/REPO`, issue numbers, developer login, and body-file paths with
verified targets. An issue's REST `id` is a database ID; it differs from its
repository issue `number` and GraphQL `node_id`. Read
`GET /repos/{owner}/{repo}/issues/{issue_number}` to resolve these values.

### Create maps and children

Search existing maps and the Idea's links before creating another. A map body
contains `Destination`, `Notes`, `Decisions so far`, `Not yet specified`, and
`Out of scope`. Its destination is the route to a decision or spec; open work
is discovered through its children. Each child body contains a `Question` and
exactly one `wayfinder:research`, `wayfinder:prototype`, `wayfinder:grilling`,
or `wayfinder:task` label.

```bash
gh issue create --repo OWNER/REPO --title 'Map title' --label 'wayfinder:map' --body-file /path/to/map.md
gh issue create --repo OWNER/REPO --title 'Decision question' --label 'wayfinder:research' --body-file /path/to/question.md
```

Read back each returned issue before linking it. Add the existing child using
`POST /repos/{owner}/{repo}/issues/{map_number}/sub_issues`, with the integer
`sub_issue_id` set to the child's REST `id`. Confirm it with
`GET /repos/{owner}/{repo}/issues/{child_number}/parent` and
`GET /repos/{owner}/{repo}/issues/{map_number}/sub_issues`. GitHub requires the
same repository owner for parent and child. Leave `replace_parent` unset;
an unexpected existing parent is a conflict to reconcile. These are the
[native sub-issue API operations](https://docs.github.com/en/rest/issues/sub-issues#add-sub-issue).

### Wire native blocking relationships

Create children first, then wire dependencies once their IDs exist. For “B is
blocked by A,” use B's issue number in the path and A's REST database ID in the
body. Body text and checklists can explain the reason but do not replace the
native relationship.

| Operation | Exact REST request |
| --- | --- |
| Add A as B's blocker | `POST /repos/{owner}/{repo}/issues/{b_number}/dependencies/blocked_by`, integer body field `issue_id` = A's REST `id` |
| Read B's blockers | `GET /repos/{owner}/{repo}/issues/{b_number}/dependencies/blocked_by` |
| Read the issues A blocks | `GET /repos/{owner}/{repo}/issues/{a_number}/dependencies/blocking` |
| Correct an obsolete edge | `DELETE /repos/{owner}/{repo}/issues/{b_number}/dependencies/blocked_by/{a_id}`, after confirming the intended edge |

Read the relationship back after a write, and read before retrying an uncertain
outcome. The endpoints and direction follow
[GitHub's issue-dependency API](https://docs.github.com/en/rest/issues/issue-dependencies#add-a-dependency-an-issue-is-blocked-by).
GitHub's UI alternative is the issue's **Relationships** menu, **Mark as blocked
by** or **Mark as blocking**, then search for and select the related issue.
See [creating issue dependencies](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-issue-dependencies).

### Query the frontier and claim a ticket

The frontier is the map's open, unassigned children whose blockers are all
closed. Query the native child collection, then each candidate's native blockers;
do not infer membership from a label or an issue-body link. Fetch every page:

```bash
gh api --paginate 'repos/OWNER/REPO/issues/MAP_NUMBER/sub_issues?per_page=100'
gh api --paginate 'repos/OWNER/REPO/issues/CHILD_NUMBER/dependencies/blocked_by?per_page=100'
```

From those results keep children with `state: open`, empty `assignees`, and no
blocker with `state: open`. Unless the map's Notes sets a priority, take the
oldest eligible child by `created_at`, then issue number. An unavailable page,
missing access to a blocker, or conflicting record means the frontier is
unknown; stop instead of treating it as empty or unblocked. Do not close the
map merely because all remaining work is claimed or blocked.

Immediately before work, re-read the ticket, its parent, blockers, and
assignees. Assign it to the developer driving the map and read it back:

```bash
gh issue edit CHILD_NUMBER --repo OWNER/REPO --add-assignee DEVELOPER_LOGIN
```

An assignment is the claim, not an atomic lock. The Control Task dispatches at
most one session for a ticket; skip an existing claim unless resuming that
recorded session. If a concurrent assignment or state change is discovered,
reconcile ownership before work. Release an abandoned claim only after its
handoff is recorded, using `--remove-assignee DEVELOPER_LOGIN` and read-back.

### Resolve, close, and update Decisions so far

After factual evidence or the required human decision is available, post a
resolution comment containing the answer, rationale, cited artifact links, and
Control Task approval evidence when applicable. A human gate remains open until
that decision arrives. Then close the resolved ticket as completed:

```bash
gh issue comment CHILD_NUMBER --repo OWNER/REPO --body-file /path/to/resolution.md
gh issue close CHILD_NUMBER --repo OWNER/REPO --reason completed
```

Read back the comment and closure before updating the map. Fetch its latest
body, preserve concurrent edits, and append one named link plus a one-line gist
under `Decisions so far`; keep the full answer in the resolution comment.

```bash
gh issue edit MAP_NUMBER --repo OWNER/REPO --body-file /path/to/updated-map.md
```

Read back the map and query the frontier again. Graduate clarified uncertainty
from `Not yet specified` into children, then wire new dependencies. An excluded
ticket closes with `--reason 'not planned'` and a named explanation in `Out of
scope`, rather than a Decisions-so-far entry. Close the map as completed only
when no open children or in-scope uncertainty remain and the route is clear;
record the next `FocusedResearch` action in the Idea. Map closure is not spec,
repository, implementation, or release approval.

### Supported client operations

Checked on 2026-09-16 against installed `gh` 2.89.0 help for `issue create`,
`issue edit`, `issue comment`, `issue close`, and `api`. That installed client
does not expose parent/dependency flags on `issue create` or `issue edit`.
Use the REST operations above through `gh api --method METHOD ENDPOINT`, with
`-F` for integer fields, `Accept: application/vnd.github+json`, and
`X-GitHub-Api-Version: 2026-03-10`. Use `--paginate` for collection reads.
For request bodies stored as files, use `--input /path/to/request.json`.
These flags are documented in the [GitHub CLI API manual](https://cli.github.com/manual/gh_api).
If the API is unavailable, preserve the pending operation and use the documented
GitHub UI or report the blocker; do not invent CLI syntax or weaken blocking
to a body convention.
