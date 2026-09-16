# Research-to-Repo Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the durable, testable orchestration foundation that generates and persists daily idea briefs, enforces lifecycle gates, synchronizes approved records with GitHub, and exposes the workflow through a version-controlled Codex skill.

**Architecture:** A small TypeScript CLI owns deterministic behavior: schemas, stable IDs, lifecycle validation, backlog rotation, Markdown rendering, local persistence, GitHub commands, and portfolio validation. The Markdown orchestration skill owns agent behavior and routes research, decisions, specifications, and implementation to the installed specialist skills. GitHub and Codex remain external ports; dry-run adapters make every mutation testable before live setup.

**Tech Stack:** Node.js 22, TypeScript 5, Zod, YAML, Node test runner through `tsx`, Prettier, Docker, GitHub CLI, Markdown/Mermaid.

**Spec:** `docs/superpowers/specs/2026-09-15-research-to-repo-design.md`

## Global Constraints

- The persistent Codex task is the human control plane; GitHub is durable state.
- Daily execution is scheduled for 8:00 AM `America/Detroit`, with at most one current brief and no catch-up burst.
- Every consequential transition requires the human approval defined in the specification.
- Public repository creation and pull-request creation are never automatic.
- Daily discovery offers three categories and uses balanced rotation: at least one new candidate and at most two resurfaced candidates.
- Shortlisted claims require primary-source verification; research age is unrestricted.
- TypeScript is the orchestration implementation language.
- All GitHub mutations support dry-run mode and idempotent reruns.
- No credentials are stored in the repository; `.env.example` documents optional configuration.
- The repository must pass tests, formatting, type checking, production build, and container smoke testing before release.

---

## File Map

```text
AGENTS.md                                      Always-on routing and approval rules
CONTEXT.md                                     Workflow glossary only
README.md                                      Operator-facing setup and usage
.agents/skills/research-to-repo/SKILL.md       Thin Codex orchestration skill
docs/agents/issue-tracker.md                   GitHub issue conventions
docs/agents/domain.md                          Domain-document conventions
docs/operations/heartbeat.md                   Daily heartbeat setup and recovery
docs/templates/daily-brief.md                  Human-readable brief contract
docs/templates/idea-issue.md                   GitHub idea issue contract
portfolio/projects.yaml                        Portfolio registry
package.json                                   Commands and dependency versions
tsconfig.json                                  Strict compiler configuration
.prettierrc.json                               Formatting policy
.gitignore                                     Generated/local state exclusions
.env.example                                   Optional GitHub configuration names
Dockerfile                                     Reproducible CLI runtime
src/domain/idea.ts                             Idea schema and stable identity
src/domain/lifecycle.ts                        Allowed states and transitions
src/domain/rotation.ts                         Daily candidate selection
src/domain/portfolio.ts                        Portfolio schema
src/ports/github.ts                            GitHub mutation interface
src/adapters/gh-cli.ts                         Real and dry-run GitHub adapter
src/services/brief-service.ts                  Render and persist dated briefs
src/services/idea-service.ts                   Persist and transition ideas
src/services/portfolio-service.ts              Validate/update project index
src/cli.ts                                     Command-line entry point
tests/*.test.ts                                Unit and integration tests
tests/fixtures/                                Deterministic sample records
scripts/install-skill.sh                       Safe personal-skill installer
```

### Task 1: Establish the executable repository contract

**Files:**
- Create: `package.json`
- Create: `tsconfig.json`
- Create: `.prettierrc.json`
- Create: `.gitignore`
- Create: `.env.example`
- Create: `src/cli.ts`
- Create: `tests/cli.test.ts`

**Interfaces:**
- Consumes: Node.js 22 and npm.
- Produces: `npm run test`, `npm run typecheck`, `npm run lint`, `npm run build`, and `npm run start -- <command>`.

- [ ] **Step 1: Write the failing CLI smoke test**

```ts
// tests/cli.test.ts
import assert from "node:assert/strict";
import test from "node:test";
import { run } from "../src/cli.js";

test("prints the available commands", async () => {
  const lines: string[] = [];
  const exitCode = await run(["help"], (line) => lines.push(line));

  assert.equal(exitCode, 0);
  assert.match(lines.join("\n"), /brief:prepare/);
  assert.match(lines.join("\n"), /idea:transition/);
  assert.match(lines.join("\n"), /portfolio:validate/);
});
```

- [ ] **Step 2: Add the package and compiler configuration**

```json
// package.json
{
  "name": "research-to-repo",
  "private": true,
  "type": "module",
  "scripts": {
    "test": "tsx --test tests/**/*.test.ts",
    "typecheck": "tsc --noEmit",
    "lint": "prettier --check .",
    "format": "prettier --write .",
    "build": "tsc",
    "start": "node dist/cli.js"
  },
  "dependencies": {
    "yaml": "^2.8.1",
    "zod": "^4.1.5"
  },
  "devDependencies": {
    "@types/node": "^22.18.1",
    "prettier": "^3.6.2",
    "tsx": "^4.20.5",
    "typescript": "^5.9.2"
  }
}
```

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "rootDir": ".",
    "outDir": "dist",
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "declaration": true,
    "sourceMap": true
  },
  "include": ["src/**/*.ts", "tests/**/*.ts"]
}
```

- [ ] **Step 3: Implement the minimal command router**

```ts
// src/cli.ts
export type WriteLine = (line: string) => void;

const commands = ["brief:prepare", "idea:transition", "portfolio:validate"];

export async function run(args: string[], write: WriteLine = console.log): Promise<number> {
  if (args[0] === "help" || args.length === 0) {
    write(commands.join("\n"));
    return 0;
  }
  write(`Unknown command: ${args[0]}`);
  return 2;
}

if (import.meta.url === `file://${process.argv[1]}`) {
  process.exitCode = await run(process.argv.slice(2));
}
```

- [ ] **Step 4: Add formatting and local-state exclusions**

```json
// .prettierrc.json
{ "semi": true, "singleQuote": false, "trailingComma": "all" }
```

```gitignore
node_modules/
dist/
.env
.local/
coverage/
```

```dotenv
# .env.example
GITHUB_OWNER=
GITHUB_TOKEN=
```

- [ ] **Step 5: Install dependencies and verify the red-green cycle**

Run: `npm install && npm test`

Expected: the smoke test passes after initially failing because `src/cli.ts` did not exist.

- [ ] **Step 6: Commit**

```bash
git add package.json package-lock.json tsconfig.json .prettierrc.json .gitignore .env.example src/cli.ts tests/cli.test.ts
git commit -m "build: establish TypeScript orchestration CLI"
```

### Task 2: Define stable idea records

**Files:**
- Create: `src/domain/idea.ts`
- Create: `tests/idea.test.ts`
- Create: `tests/fixtures/ideas.ts`

**Interfaces:**
- Consumes: candidate fields produced by research.
- Produces: `Idea`, `IdeaCategory`, `IdeaStatus`, `parseIdea(input)`, and `createIdeaId(category, canonicalSource, title)`.

- [ ] **Step 1: Write failing schema and stable-ID tests**

```ts
// tests/idea.test.ts
import assert from "node:assert/strict";
import test from "node:test";
import { createIdeaId, parseIdea } from "../src/domain/idea.js";

test("creates the same ID for equivalent source and title text", () => {
  const first = createIdeaId("paper-app", "https://arxiv.org/abs/1706.03762", "Attention Is All You Need");
  const second = createIdeaId("paper-app", "https://arxiv.org/abs/1706.03762/", "  attention is all you need  ");
  assert.equal(first, second);
});

test("rejects an idea without a primary source", () => {
  assert.throws(() => parseIdea({ id: "idea-x", title: "Missing evidence" }), /category/);
});
```

- [ ] **Step 2: Implement the schema and identity function**

```ts
// src/domain/idea.ts
import { createHash } from "node:crypto";
import { z } from "zod";

export const IdeaCategorySchema = z.enum(["paper-app", "library-app", "existing-extension"]);
export const IdeaStatusSchema = z.enum([
  "backlog", "selected", "researching", "decisioning", "planned",
  "building", "blocked", "shipped", "archived",
]);

export const IdeaSchema = z.object({
  id: z.string().regex(/^idea-[a-f0-9]{12}$/),
  title: z.string().min(3),
  pitch: z.string().min(10),
  category: IdeaCategorySchema,
  status: IdeaStatusSchema,
  discoveredOn: z.string().date(),
  appearedOn: z.array(z.string().date()).min(1),
  canonicalSource: z.string().url(),
  primarySources: z.array(z.string().url()).min(1),
  score: z.number().min(0).max(100),
  scoreRationale: z.string().min(10),
  userValue: z.string().min(10),
  interactiveExperience: z.string().min(10),
  verticalSlice: z.string().min(10),
  risks: z.array(z.string()),
  priorAppearances: z.number().int().nonnegative(),
});

export type Idea = z.infer<typeof IdeaSchema>;
export type IdeaCategory = z.infer<typeof IdeaCategorySchema>;
export type IdeaStatus = z.infer<typeof IdeaStatusSchema>;

const normalize = (value: string) => value.trim().toLowerCase().replace(/\/$/, "");

export function createIdeaId(category: IdeaCategory, canonicalSource: string, title: string): string {
  const input = `${category}:${normalize(canonicalSource)}:${normalize(title)}`;
  return `idea-${createHash("sha256").update(input).digest("hex").slice(0, 12)}`;
}

export const parseIdea = (input: unknown): Idea => IdeaSchema.parse(input);
```

- [ ] **Step 3: Add one valid fixture per category**

Create `tests/fixtures/ideas.ts` exporting `paperIdea`, `libraryIdea`, and `extensionIdea`, each satisfying every `Idea` field with fixed 2026-09 dates and source URLs owned by the referenced project or paper.

- [ ] **Step 4: Run the focused tests**

Run: `npm test -- tests/idea.test.ts`

Expected: both tests pass and malformed records fail with Zod errors.

- [ ] **Step 5: Commit**

```bash
git add src/domain/idea.ts tests/idea.test.ts tests/fixtures/ideas.ts
git commit -m "feat: define durable idea records"
```

### Task 3: Enforce lifecycle and approval gates

**Files:**
- Create: `src/domain/lifecycle.ts`
- Create: `tests/lifecycle.test.ts`

**Interfaces:**
- Consumes: `IdeaStatus`, target status, and an `ApprovalEvidence` object.
- Produces: `transitionIdea(current, target, evidence)` and `allowedTargets(current)`.

- [ ] **Step 1: Write failing transition tests**

```ts
// tests/lifecycle.test.ts
import assert from "node:assert/strict";
import test from "node:test";
import { transitionIdea } from "../src/domain/lifecycle.js";

test("blocks selection without human evidence", () => {
  assert.throws(() => transitionIdea("backlog", "selected", {}), /approval/);
});

test("allows approved selection", () => {
  assert.equal(
    transitionIdea("backlog", "selected", { approvedBy: "human", approvedAt: "2026-09-15T12:00:00Z" }),
    "selected",
  );
});

test("never transitions partial work directly to shipped", () => {
  assert.throws(() => transitionIdea("building", "shipped", { verificationPassed: false }), /verification/);
});
```

- [ ] **Step 2: Implement explicit transitions and gates**

```ts
// src/domain/lifecycle.ts
import type { IdeaStatus } from "./idea.js";

export interface ApprovalEvidence {
  approvedBy?: "human";
  approvedAt?: string;
  verificationPassed?: boolean;
  mergedPullRequest?: string;
}

const targets: Record<IdeaStatus, readonly IdeaStatus[]> = {
  backlog: ["selected", "archived"], selected: ["researching", "decisioning", "blocked"],
  researching: ["decisioning", "planned", "blocked"], decisioning: ["researching", "planned", "blocked"],
  planned: ["building", "blocked"], building: ["blocked", "shipped"], blocked: ["researching", "decisioning", "planned", "building"],
  shipped: [], archived: ["backlog"],
};

const humanGates = new Set(["backlog:selected", "backlog:archived", "archived:backlog", "planned:building"]);

export function allowedTargets(current: IdeaStatus): readonly IdeaStatus[] { return targets[current]; }

export function transitionIdea(current: IdeaStatus, target: IdeaStatus, evidence: ApprovalEvidence): IdeaStatus {
  if (!targets[current].includes(target)) throw new Error(`invalid transition: ${current} -> ${target}`);
  if (humanGates.has(`${current}:${target}`) && evidence.approvedBy !== "human") throw new Error("human approval required");
  if (target === "shipped" && (!evidence.verificationPassed || !evidence.mergedPullRequest)) {
    throw new Error("verification and merged pull request required");
  }
  return target;
}
```

- [ ] **Step 3: Cover every state-machine edge**

Add a table-driven test enumerating every allowed edge in `docs/workflow/development-state-machine.md`, plus rejected direct transitions such as `backlog -> building`, `planned -> shipped`, and `archived -> selected`.

- [ ] **Step 4: Run tests**

Run: `npm test -- tests/lifecycle.test.ts`

Expected: all documented edges pass and unsupported shortcuts fail.

- [ ] **Step 5: Commit**

```bash
git add src/domain/lifecycle.ts tests/lifecycle.test.ts
git commit -m "feat: enforce idea lifecycle gates"
```

### Task 4: Implement balanced backlog rotation

**Files:**
- Create: `src/domain/rotation.ts`
- Create: `tests/rotation.test.ts`

**Interfaces:**
- Consumes: new and backlogged `Idea[]` plus a brief date.
- Produces: `selectDailyCandidates(input): [Idea, Idea, Idea]` with one candidate per category, at least one new idea, and no more than two resurfaced ideas.

- [ ] **Step 1: Write failing selection tests**

```ts
// tests/rotation.test.ts
import assert from "node:assert/strict";
import test from "node:test";
import { selectDailyCandidates } from "../src/domain/rotation.js";
import { extensionIdea, libraryIdea, paperIdea } from "./fixtures/ideas.js";

test("selects one candidate per category", () => {
  const selected = selectDailyCandidates({ newIdeas: [paperIdea], backlog: [libraryIdea, extensionIdea] });
  assert.deepEqual(new Set(selected.map((idea) => idea.category)), new Set(["paper-app", "library-app", "existing-extension"]));
});

test("rejects a brief with no newly discovered candidate", () => {
  assert.throws(() => selectDailyCandidates({ newIdeas: [], backlog: [paperIdea, libraryIdea, extensionIdea] }), /new candidate/);
});
```

- [ ] **Step 2: Implement deterministic ranking**

Implement `selectDailyCandidates` by sorting each category by descending `score`, then ascending `priorAppearances`, then `id`. Select the best available candidate in every category while reserving one slot for a new idea. Throw a descriptive error when a category is empty or the new-candidate rule cannot be satisfied.

```ts
export interface RotationInput { newIdeas: Idea[]; backlog: Idea[]; }
export type DailyCandidates = readonly [Idea, Idea, Idea];
export function selectDailyCandidates(input: RotationInput): DailyCandidates;
```

- [ ] **Step 3: Test deterministic ties and resurfacing limits**

Add cases proving stable ordering, exactly three results, at most two `priorAppearances > 0`, and a useful error when a category has no candidate.

- [ ] **Step 4: Run tests and commit**

Run: `npm test -- tests/rotation.test.ts`

```bash
git add src/domain/rotation.ts tests/rotation.test.ts
git commit -m "feat: rotate daily research candidates"
```

### Task 5: Persist idempotent briefs and idea records

**Files:**
- Create: `src/services/brief-service.ts`
- Create: `src/services/idea-service.ts`
- Create: `docs/templates/daily-brief.md`
- Create: `docs/templates/idea-issue.md`
- Create: `tests/brief-service.test.ts`
- Create: `tests/idea-service.test.ts`

**Interfaces:**
- Consumes: a date, `DailyCandidates`, and repository root.
- Produces: `renderBrief`, `persistBrief`, `loadIdeas`, and `upsertIdeas`.

- [ ] **Step 1: Write failing idempotency tests**

```ts
test("rerunning a date replaces the same brief instead of creating another", async () => {
  const first = await persistBrief(tempRoot, "2026-09-16", candidates);
  const second = await persistBrief(tempRoot, "2026-09-16", candidates);
  assert.equal(first.path, second.path);
  assert.equal((await readdir(join(tempRoot, "docs/briefs"))).length, 1);
});
```

```ts
test("upsertIdeas preserves prior appearance dates", async () => {
  await upsertIdeas(tempRoot, [paperIdea], "2026-09-15");
  const [updated] = await upsertIdeas(tempRoot, [paperIdea], "2026-09-16");
  assert.deepEqual(updated.appearedOn, ["2026-09-15", "2026-09-16"]);
});
```

- [ ] **Step 2: Implement deterministic Markdown rendering**

`renderBrief(date, candidates)` must emit the date, ranking, category, stable ID, source links, pitch, usefulness, interactive experience, vertical slice, risks, score rationale, and resurfacing history. Escape user-controlled Markdown link labels and sort sources.

- [ ] **Step 3: Implement atomic local persistence**

Write briefs to `docs/briefs/YYYY-MM-DD.md` through a sibling `.tmp` file followed by `rename`. Persist idea records as individual YAML files under `data/ideas/<idea-id>.yaml`; parse every read through `IdeaSchema`.

- [ ] **Step 4: Add human-readable templates**

The daily-brief template documents the rendered sections. The idea-issue template contains `Idea ID`, `Discovered`, `Appearances`, `Category`, `Status`, `Primary sources`, `Proposal`, `Risks`, and `Next decision` headings.

- [ ] **Step 5: Run focused tests and commit**

Run: `npm test -- tests/brief-service.test.ts tests/idea-service.test.ts`

```bash
git add src/services docs/templates tests/brief-service.test.ts tests/idea-service.test.ts
git commit -m "feat: persist daily briefs and ideas"
```

### Task 6: Add an approval-safe GitHub adapter

**Files:**
- Create: `src/ports/github.ts`
- Create: `src/adapters/gh-cli.ts`
- Create: `tests/gh-cli.test.ts`
- Create: `docs/agents/issue-tracker.md`

**Interfaces:**
- Consumes: validated ideas, approval evidence, repository coordinates, and injected command execution.
- Produces: `GitHubPort.ensureIdeaIssue`, `GitHubPort.ensureLabels`, and `GitHubPort.proposeRepository`; no method creates a repository or PR without an explicit approved operation.

- [ ] **Step 1: Write failing dry-run and idempotency tests**

```ts
test("dry-run returns commands without executing them", async () => {
  const executed: string[][] = [];
  const github = createGhCli({ dryRun: true, exec: async (args) => { executed.push(args); return { stdout: "", exitCode: 0 }; } });
  const result = await github.ensureIdeaIssue(paperIdea);
  assert.equal(executed.length, 0);
  assert.match(result.preview, /gh issue create/);
});
```

```ts
test("finds an existing issue by stable idea ID before creating", async () => {
  const calls: string[][] = [];
  const github = createGhCli({ dryRun: false, exec: fakeGhReturningExistingIssue(calls, paperIdea.id) });
  const result = await github.ensureIdeaIssue(paperIdea);
  assert.equal(result.created, false);
  assert.equal(calls.filter((args) => args.includes("create")).length, 0);
});
```

- [ ] **Step 2: Define the port**

```ts
export interface GitHubPort {
  ensureLabels(): Promise<void>;
  ensureIdeaIssue(idea: Idea): Promise<{ created: boolean; url?: string; preview: string }>;
  proposeRepository(input: RepositoryProposal): Promise<{ preview: string }>;
}

export interface RepositoryProposal {
  name: string;
  description: string;
  visibility: "public";
  license: "MIT" | string;
  initialStructure: string[];
}
```

- [ ] **Step 3: Implement `gh` command construction**

Search issues using the stable ID before creating. Use labels `idea`, `idea:backlog`, `idea:selected`, `idea:archived`, and the three category labels. Pass bodies using temporary files, never shell interpolation. `proposeRepository` returns a Markdown preview only; it must not invoke `gh repo create`.

- [ ] **Step 4: Document GitHub issue operations**

Record issue identity, label vocabulary, Wayfinder child issues, and the rule that repository and PR creation require separate human approval.

- [ ] **Step 5: Run tests and commit**

Run: `npm test -- tests/gh-cli.test.ts`

```bash
git add src/ports/github.ts src/adapters/gh-cli.ts tests/gh-cli.test.ts docs/agents/issue-tracker.md
git commit -m "feat: add dry-run GitHub synchronization"
```

### Task 7: Validate the portfolio registry

**Files:**
- Create: `src/domain/portfolio.ts`
- Create: `src/services/portfolio-service.ts`
- Create: `portfolio/projects.yaml`
- Create: `tests/portfolio-service.test.ts`

**Interfaces:**
- Consumes: YAML project records.
- Produces: `PortfolioProject`, `validatePortfolio(path)`, and `upsertPortfolioProject(path, project)`.

- [ ] **Step 1: Write failing registry tests**

Test that duplicate repository URLs, unknown statuses, a `shipped` project without README/demo links, and malformed dates fail. Test that a valid empty registry and valid planned project pass.

- [ ] **Step 2: Implement the portfolio schema**

```ts
export const PortfolioProjectSchema = z.object({
  ideaId: z.string().regex(/^idea-[a-f0-9]{12}$/),
  name: z.string().min(2),
  repository: z.string().url(),
  status: z.enum(["planned", "building", "blocked", "shipped"]),
  researchBasis: z.array(z.string().url()).min(1),
  readme: z.string().url().optional(),
  demo: z.string().url().optional(),
  lastActivityOn: z.string().date(),
});
```

Add a refinement requiring `readme` and `demo` when status is `shipped`. Implement atomic YAML updates sorted by project name.

- [ ] **Step 3: Seed the empty registry**

```yaml
version: 1
projects: []
```

- [ ] **Step 4: Run tests and commit**

Run: `npm test -- tests/portfolio-service.test.ts`

```bash
git add src/domain/portfolio.ts src/services/portfolio-service.ts portfolio/projects.yaml tests/portfolio-service.test.ts
git commit -m "feat: validate portfolio project registry"
```

### Task 8: Wire the CLI around domain services

**Files:**
- Modify: `src/cli.ts`
- Modify: `tests/cli.test.ts`
- Create: `tests/cli-integration.test.ts`

**Interfaces:**
- Consumes: CLI arguments and filesystem/GitHub adapters.
- Produces: working commands `brief:prepare`, `idea:transition`, `github:sync`, and `portfolio:validate`.

- [ ] **Step 1: Write failing command-level tests**

Cover:

```text
brief:prepare --date 2026-09-16 --new fixtures/new --backlog fixtures/backlog --dry-run
idea:transition --id idea-abc123abc123 --to selected --approved-by human
github:sync --date 2026-09-16 --dry-run
portfolio:validate
```

Assert exit `0` on valid input, exit `2` on bad arguments, exit `1` on domain validation failure, and no filesystem or GitHub mutation during `--dry-run`.

- [ ] **Step 2: Add dependency injection to `run`**

```ts
export interface CliDependencies {
  cwd: string;
  now: () => Date;
  write: WriteLine;
  github: GitHubPort;
}

export async function run(args: string[], dependencies?: Partial<CliDependencies>): Promise<number>;
```

- [ ] **Step 3: Implement each command as a thin adapter**

Parse flags without shell evaluation, call the domain/service function, print the artifact path or preview, and map known validation errors to exit `1`. Do not place lifecycle logic in `src/cli.ts`.

- [ ] **Step 4: Run the full test suite and commit**

Run: `npm test && npm run typecheck`

```bash
git add src/cli.ts tests/cli.test.ts tests/cli-integration.test.ts
git commit -m "feat: expose orchestration commands"
```

### Task 9: Add the Codex orchestration skill and domain docs

**Files:**
- Create: `.agents/skills/research-to-repo/SKILL.md`
- Create: `AGENTS.md`
- Create: `CONTEXT.md`
- Create: `docs/agents/domain.md`
- Create: `scripts/install-skill.sh`
- Create: `tests/install-skill.test.ts`

**Interfaces:**
- Consumes: installed specialist skills and repository CLI.
- Produces: manually invokable `$research-to-repo` behavior and a safe installer into `${CODEX_HOME:-$HOME/.codex}/skills/research-to-repo`.

- [ ] **Step 1: Write the installer behavior test**

Run the installer against temporary `CODEX_HOME` values and assert that it creates a symlink to the repository skill, refuses to overwrite a non-symlink directory, and is idempotent when rerun.

- [ ] **Step 2: Write the thin orchestration skill**

The skill must:

1. Load the approved spec, state machine, issue-tracker rules, and current idea records.
2. On `daily`, use broad discovery and primary-source verification, invoke the installed research skill for cited notes, create validated candidate records, run balanced rotation, dry-run persistence/GitHub changes, then apply them and post the brief.
3. On `select <idea-id>`, require human selection evidence, transition the idea, assess whether Wayfinder is needed, and stop at the next approval gate.
4. Route large uncertain work to Wayfinder; route resolved ideas through domain modeling, specification, tickets, TDD, review, verification, and branch finishing.
5. Never create a public repository, external account, paid resource, PR, or release without explicit approval.
6. On failure, retry only a clearly transient operation once, then preserve evidence and produce a handoff.
7. Never copy the detailed procedures owned by specialist skills.

- [ ] **Step 3: Add repository-wide agent instructions**

`AGENTS.md` names the orchestration skill, points to the issue tracker and domain docs, requires the state machine, and states that `docs/superpowers/specs/2026-09-15-research-to-repo-design.md` is authoritative.

- [ ] **Step 4: Define the glossary**

`CONTEXT.md` defines only domain terms: Idea, Candidate, Daily Brief, Backlog, Selected Project, Decision Gate, Wayfinder Map, Daily Handoff, Shipped, Control Task, Orchestration Repository, and Project Repository. `docs/agents/domain.md` records the single-context layout and ADR rules.

- [ ] **Step 5: Implement the safe installer**

Use `set -euo pipefail`, resolve the repository root from the script location, create only the parent skills directory, reject an occupied non-symlink target, and use `ln -s` with explicit source and destination paths.

- [ ] **Step 6: Run tests and commit**

Run: `npm test -- tests/install-skill.test.ts`

```bash
git add .agents AGENTS.md CONTEXT.md docs/agents/domain.md scripts/install-skill.sh tests/install-skill.test.ts
git commit -m "feat: add research-to-repo Codex skill"
```

### Task 10: Complete operations, containers, and end-to-end verification

**Files:**
- Create: `Dockerfile`
- Create: `README.md`
- Create: `docs/operations/heartbeat.md`
- Create: `tests/end-to-end.test.ts`
- Create: `tests/fixtures/new/*.yaml`
- Create: `tests/fixtures/backlog/*.yaml`
- Modify: `package.json`

**Interfaces:**
- Consumes: all previous components.
- Produces: a documented local/container workflow, end-to-end dry run, and the exact heartbeat prompt to configure after approval.

- [ ] **Step 1: Write the failing end-to-end test**

Create an isolated temporary repository, feed it fixed new/backlog fixtures, run `brief:prepare`, `github:sync --dry-run`, an approved transition, and `portfolio:validate`. Assert one dated brief, three idea records, no external commands, valid category mix, and deterministic output on a second run.

- [ ] **Step 2: Add the container image**

```dockerfile
FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY tsconfig.json ./
COPY src ./src
RUN npm run build

FROM node:22-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY package*.json ./
RUN npm ci --omit=dev
COPY --from=build /app/dist ./dist
ENTRYPOINT ["node", "dist/src/cli.js"]
CMD ["help"]
```

- [ ] **Step 3: Document setup and operation**

README sections must cover purpose, architecture, workflow diagram link, requirements, `npm ci`, tests, build, CLI examples, dry-run, GitHub authentication, skill installation, Docker usage, state recovery, limitations, and license. `docs/operations/heartbeat.md` contains the daily schedule, missed-run semantics, manual fallback, and this human-readable prompt:

```text
Invoke $research-to-repo in daily mode. Work in the research-to-repo project. Generate at most one brief for the current America/Detroit date. Stay quiet if today's persisted brief already exists. Preserve all unselected ideas. Stop for human selection and every approval gate defined by the canonical state machine.
```

- [ ] **Step 4: Add aggregate verification scripts**

Add `verify` as `npm run lint && npm run typecheck && npm test && npm run build`. Run:

```bash
npm run verify
docker build -t research-to-repo:test .
docker run --rm research-to-repo:test help
```

Expected: all commands exit `0`, tests report no failures, and the container prints the command list.

- [ ] **Step 5: Perform a controlled manual dry run**

Run the CLI against fixture inputs with `github:sync --dry-run`. Confirm the preview contains issue commands but `gh issue list` shows no new issues. Record the command and observed result in `docs/operations/heartbeat.md` under `Verification record`.

- [ ] **Step 6: Commit**

```bash
git add Dockerfile README.md docs/operations/heartbeat.md tests/end-to-end.test.ts tests/fixtures package.json package-lock.json
git commit -m "docs: complete orchestration operations"
```

### Task 11: Publish the control repository and configure the live heartbeat after final approval

**Files:**
- Modify: `docs/operations/heartbeat.md`

**Interfaces:**
- Consumes: verified local installation and explicit human authorization.
- Produces: an approved public orchestration repository, initialized issue labels, and one active daily Codex heartbeat targeting the persistent control task.

- [ ] **Step 1: Show both live-mutation proposals to the human**

Present:

```text
Repository name: research-to-repo
Visibility: public
Description: A Codex-controlled workflow that turns research and open-source ideas into verified GitHub projects.
License: MIT
Initial branch: main
```

Also present the exact heartbeat prompt from Task 10 and the schedule `8:00 AM America/Detroit daily`. Request separate explicit approvals for public repository creation and heartbeat creation. If either is declined, keep the corresponding integration local and continue no further with that integration.

- [ ] **Step 2: Create and verify the public repository only after approval**

Run:

```bash
gh repo create research-to-repo --public --source=. --remote=origin --description "A Codex-controlled workflow that turns research and open-source ideas into verified GitHub projects."
git push -u origin main
gh repo view --json name,visibility,url,defaultBranchRef
```

Expected: the repository is public, its default branch is `main`, and the returned URL belongs to the authenticated user. Stop and report if the name is occupied or the authenticated owner is unexpected; do not silently choose another name or owner.

- [ ] **Step 3: Initialize and verify issue labels**

Run `npm run start -- github:sync --labels-only`, then query the repository labels with `gh label list`. Verify `idea`, each idea status label, and each category label exist exactly once.

- [ ] **Step 4: Install the personal skill and create the heartbeat through the Codex automation API**

Run `scripts/install-skill.sh` and verify the installed path resolves to `.agents/skills/research-to-repo/SKILL.md` in this repository.

Create one active heartbeat named `Daily research-to-repo brief`, targeting this persistent task. The prompt must instruct it to remain quiet when today's brief already exists and to notify only on a new brief, meaningful failure, completion, or required human decision.

- [ ] **Step 5: Inspect the saved heartbeat**

Read it back and verify name, schedule, target task, active state, notification behavior, and prompt text. If any value differs, update the same heartbeat rather than creating a duplicate.

- [ ] **Step 6: Record non-secret automation metadata and commit**

Add the heartbeat name and verified schedule—not credentials or private identifiers—to `docs/operations/heartbeat.md`.

```bash
git add docs/operations/heartbeat.md
git commit -m "ops: record daily brief heartbeat"
```

## Final Verification

After all tasks:

1. Run `npm run verify` and capture the zero-failure output.
2. Run the Docker build and help smoke test.
3. Run the full dry-run scenario twice and compare generated artifacts for idempotence.
4. Check the implementation line-by-line against the approved specification.
5. Run the two-axis code review against the commit preceding Task 1.
6. Resolve all Critical and Important review findings and rerun verification.
7. Verify the public repository and heartbeat exist only if their separate Task 11 approvals were granted.
8. For future project repositories and pull requests, continue to request explicit approval; Task 11 authorizes only the `research-to-repo` control repository.
