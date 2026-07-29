# Eigenverft Naming Migration — Autonomous Planning Instruction

## Purpose

This instruction defines how an autonomous agent analyzes, plans, discusses, and executes an Eigenverft naming migration.

The canonical naming reference is:

`https://raw.githubusercontent.com/eigenverft/eigenverft/main/NAMING.md`

The agent must read the complete current naming convention before evaluating repository, product, project, package, assembly, command, or namespace names.

The naming convention defines the target naming system. This instruction defines the migration process and the interaction with the user.

---

## Core workflow

The workflow has five separate stages:

1. **Read-only investigation**
2. **Initial migration plan**
3. **Discussion and final plan**
4. **Source-state completion and readiness checkpoint**
5. **Explicitly authorized migration execution**

The agent must remain read-only during the first three stages.

The fourth stage is a mandatory safety gate. It closes and remotely secures existing work before any migration target is created or any Git identity is changed.

The fifth stage may begin only after the source-state gate has passed.

The agent must not begin changing files, repositories, remotes, packages, publications, or settings merely because it has found naming inconsistencies.

The initial plan is a proposal, not an execution order.

The discussion with the user is part of the planning process. Decisions and new facts from that discussion must be incorporated into the final plan.

Execution begins only after the user explicitly instructs the agent to implement the final agreed plan.

---

## Mandatory source-state completion gate

A naming migration must start from a clear, recoverable, remotely verifiable source state.

Read-only analysis may continue when the repository contains open work. Migration execution must not begin while that work is unresolved.

Before creating a target repository, changing remotes, updating Git references, modifying names, or creating a new working copy, verify all of the following:

- no merge, rebase, cherry-pick, revert, bisect, or conflict resolution is in progress,
- all intended tracked changes are reviewed and committed,
- relevant untracked files are either deliberately committed or preserved through an explicitly agreed safe method,
- ignored files that contain required local state are identified and handled deliberately,
- no relevant work exists only in the index, working tree, stash, another worktree, or an unpublished local branch,
- every relevant local commit exists on an accessible remote branch,
- the configured tracking branch is correct,
- the local branch is not unexpectedly ahead of, behind, or diverged from its tracking branch,
- the relationship between `origin`, `upstream`, and the canonical repository is understood,
- the source branch is synchronized with the intended canonical upstream state, or any deliberate divergence is documented and approved,
- relevant tags are available remotely,
- required Git LFS objects have been pushed,
- submodules and additional worktrees have no unreviewed local work,
- the exact source commit selected for migration is recorded.

Do not interpret "pushed to upstream" mechanically. In fork workflows, `upstream` may be read-only and owned by another organization. The requirement is that all work is committed and backed by an appropriate accessible remote, while the branch relationship to the canonical upstream is current, understood, and explicitly verified.

The agent must never make the repository appear clean by silently running destructive or concealing operations.

Without explicit approval, do not:

- discard changes,
- run `git reset --hard`,
- run `git clean`,
- delete untracked files,
- drop or clear stashes,
- amend or squash existing commits,
- force-push,
- move unfinished work into an undocumented temporary location,
- commit secrets, credentials, machine-specific files, or generated output merely to obtain a clean status.

When open work exists, deny migration readiness and stop before any migration action.

The open work must first be reviewed, completed, committed, and pushed through the repository's normal user branch workflow. Do not create a special migration branch, safety branch, temporary preservation branch, or tracking issue merely to bypass the preflight gate.

An issue, checklist, comment, or migration note may document follow-up work, but it is not evidence that source work has been safely completed. Deferred items can be forgotten or become stale. The gate requires an actual clear Git state, not a promise to resolve it later.

After source completion, produce a readiness record containing at least:

| Check | Verified state |
|---|---|
| Working tree | Clean, with no unexplained files |
| Current branch | Recorded |
| Local source commit | Recorded SHA |
| Tracking branch | Recorded |
| Remote source commit | Matching recorded SHA |
| Canonical upstream relation | Current or explicitly documented |
| Other branches, stashes, and worktrees | Reviewed and preserved |
| Tags and LFS | Verified where applicable |

The gate passes only when the agent can state:

> All relevant existing work is committed, preserved on an appropriate remote, reconciled with the intended upstream relationship, and recoverable from a recorded source commit.

If this statement cannot be supported by evidence, stop before migration and explain what remains unresolved.

---

## Migration principle

Prefer **creation, migration, verification, controlled transition, and later cleanup** over in-place renaming.

For Git repositories, local working folders, published packages, and other externally visible artifacts, the default migration pattern is:

```text
create target
→ migrate content and history
→ verify independently
→ switch references and consumers
→ keep the previous artifact available during transition
→ archive, deprecate, hide, or retire it only when appropriate
→ remove it only after separate explicit approval
```

An in-place rename must not be the default recommendation.

A rename may preserve hidden state, stale references, path dependencies, incorrect remotes, or assumptions that are difficult to verify. Creating a new target and validating it independently usually produces a clearer migration boundary.

The old source must remain intact until the new target has been proven complete and usable.

---

# 1. Read-only investigation

## 1.1 Read the naming convention

Read `NAMING.md` completely.

Use only categories, schemas, and precedence rules defined there.

Do not invent categories.

Do not infer mandatory rules only from examples when the normative text says otherwise.

## 1.2 Inspect the repository autonomously

Determine as much as possible without asking the user for information that can be discovered directly.

Inspect at least:

- repository owner or organization,
- repository name,
- repository visibility,
- canonical Git remote,
- all configured local remotes,
- `origin` and `upstream` roles,
- default branch,
- local tracking branches,
- local commits not present on a remote,
- uncommitted changes,
- tags,
- releases,
- Git LFS usage,
- submodules,
- additional worktrees,
- branch and tag protection where discoverable,
- repository permissions available to the current user or agent,
- README and documentation,
- solutions and projects,
- package and assembly metadata,
- root namespaces,
- executable and command names,
- build and release automation,
- package publishing configuration,
- public installation instructions,
- known internal or external consumers.

Do not assume:

- that `origin` is the canonical upstream,
- that `upstream` should point to the same repository as `origin`,
- that all local commits have been pushed,
- that a successful fetch implies push permission,
- that the current local directory can be replaced safely,
- that every public artifact can be withdrawn,
- that every platform supports deprecation, hiding, unlisting, or archival in the same way.

## 1.3 Check local top-level access

Before proposing a local migration, determine whether the agent can safely work in the parent directory of the current checkout.

Check whether it is possible to:

- create a new sibling directory,
- clone into the new directory,
- preserve the current working copy,
- access required credentials,
- use sufficient disk space,
- build and test from the new directory,
- compare the old and new working copies.

If the parent directory cannot be accessed or modified, state this limitation in the plan. Do not improvise by altering the existing checkout in place.

---

# 2. Determine whether the convention should be applied

Evaluate whether the Eigenverft naming convention should apply fully, partially, through a controlled migration, or not at all.

Consider:

- whether the repository belongs to Eigenverft,
- whether the convention is already partially used,
- whether the repository contains one product or several products,
- whether it is a special repository form such as `Suite`, `Templates`, `Lab`, `Meta`, or `Archive`,
- whether the proposed names improve product identity,
- whether established public names already form a contract,
- whether the migration benefit justifies its operational and compatibility cost.

Use one of these conclusions:

- **Apply fully**
- **Apply with a controlled migration**
- **Apply partially**
- **Do not apply**
- **Not yet decidable**

A deviation from `NAMING.md` does not by itself prove that migration is appropriate.

---

# 3. Determine visibility and publication status

## 3.1 Repository visibility

Classify the repository as:

- public,
- private,
- or not reliably determinable.

Use repository metadata when available. Do not guess from the repository name or content.

## 3.2 Publication status

Classify every relevant product or artifact as:

- unpublished,
- published only internally,
- published publicly,
- or publication status unknown.

Look for evidence such as:

- Git hosting releases,
- release tags,
- NuGet packages,
- .NET tools,
- PowerShell modules,
- container images,
- installers,
- downloadable binaries,
- package IDs,
- assembly names,
- public namespaces and APIs,
- public commands,
- documented installation commands,
- external links and consumers.

Record the evidence for the classification.

## 3.3 Supported lifecycle actions

For every previously published artifact, determine which lifecycle actions are actually supported by its platform.

Possible actions include:

- mark as deprecated,
- unlist,
- hide from normal discovery,
- reduce visibility,
- archive,
- make read-only,
- add a successor notice,
- add a migration notice,
- publish a compatibility or transition package,
- publish a new successor while retaining the old artifact.

Do not claim that an action is possible until it has been verified for the actual platform and artifact type.

Do not treat a published version as if it can always be withdrawn, renamed, or erased.

The default for public artifacts is preservation plus clear transition guidance, not destructive cleanup.

---

# 4. Determine the target naming model

For every relevant product determine:

- `Root`,
- `Category`,
- `Product`,
- optional `Variant`.

Use:

`<Root>.<Category>.<Product>[.<Variant>]`

Determine the category from the public consumption or execution model, not merely from the implementation technology.

Pay particular attention to:

- `Cli` versus `Tool`,
- `Web` versus `Service`,
- `WebLib` versus `BlazorLib`,
- `DesktopLib` versus `WinLib`,
- `WinLib` versus `InteropLib`,
- `Build` versus `Generator`,
- build-time artifacts versus runtime libraries,
- `Lib` versus `NetLib`,
- modern libraries versus `*FxLib`,
- a single product versus `Suite`,
- an active product versus `Lab` or `Archive`.

Do not force all internal directories or helper projects to become independently branded products.

Distinguish between:

- public product identity,
- public technical contracts,
- build and packaging identity,
- internal implementation structure.

---

# 5. Initial plan for the user

## 5.1 Keep the plan readable

The initial plan must be useful to a human decision-maker.

Do not present a long file-by-file checklist as the main plan.

Summarize the migration into **three to five important decisions**.

For each decision:

- assign a letter,
- provide two to four numbered options,
- identify one recommended option,
- explain the consequence in simple language.

The user must be able to respond with selections such as:

```text
A1, B1, C2, D1
```

or:

```text
Please use all recommended options.
```

An option selection updates the plan. It does not by itself authorize execution.

## 5.2 Initial output structure

The initial output must use this structure:

### Result

State briefly whether the convention should be applied and whether a controlled migration is needed.

### Repository context

Summarize:

- owner or organization,
- visibility,
- primary purpose,
- main products,
- repository form,
- current Git topology.

### Source readiness

Summarize:

- whether the working tree is clean,
- whether local commits are fully backed by remote branches,
- whether `origin`, `upstream`, and branch tracking have clear roles,
- whether stashes, untracked files, additional worktrees, submodules, tags, or LFS contain unresolved work,
- the exact condition that must be completed before migration can begin.

If the source-state gate already passes, say so explicitly. If it does not pass, make source completion the first decision block.

### Publication status

Summarize:

- published artifacts,
- supporting evidence,
- known or possible consumers,
- available lifecycle actions that still require a decision.

### Target model

Describe the proposed target naming structure in a few sentences.

### Main mappings

Show only the important product-level mappings initially:

| Current identity | Proposed identity | Reason |
|---|---|---|
| Current name | Target name | Short rule-based explanation |

Group related repository, project, assembly, package, and namespace changes under one product identity when practical.

### Decisions

Present three to five lettered decision blocks.

### Recommended selection

End with a concise recommendation such as:

```text
Recommended selection: A1, B1, C1, D2
```

Explain why the combination is preferred and what risk it avoids.

### Next step

Ask the user to select options or suggest changes.

Remain read-only.

---

# 6. Standard decision blocks

Use only the blocks relevant to the repository. Normally use three to five blocks.

## R. Source-state preflight blocker

Show this block whenever the source-state gate does not already pass.

This is not a migration option. It is a denial of readiness.

State clearly which normal user branch contains the open work and what remains unresolved. The repository owner or user must complete the work through the established branch workflow, commit it appropriately, push it to the correct remote, and verify the resulting remote commit.

Do not create a special migration branch, safety branch, temporary branch, or issue to park the work. Do not move the uncertainty into a separate artifact that can be forgotten.

Do not offer discarding, cleaning, hiding, stashing, or deleting work as a shortcut.

The only permitted next states are:

- the work is completed on its normal intended branch, reviewed, committed, pushed, and verified; or
- the migration remains paused in read-only mode.

After the user reports completion, independently re-run the complete source-state preflight. Do not rely only on the user's statement.

The Git migration decisions below remain blocked until the preflight passes.

---

## A. Git remote migration

### A1 — Create a new repository and migrate — recommended

Create a new repository with the target name. Transfer Git history and references. Validate it independently. Keep the previous repository available during transition.

Use this when the repository identity itself should change.

### A2 — Keep the current repository

Keep the current remote repository name and URL. Apply naming changes only to products and repository content.

Use this when the repository name is already acceptable or when changing the public Git identity would create more cost than value.

### A3 — Defer the Git identity decision

Plan product naming first but do not create a new remote yet.

Use this only when ownership, visibility, permissions, or target organization are still unclear.

Do not recommend an in-place repository rename as the default migration mechanism.

If a user explicitly asks for an in-place rename, treat it as a separate non-default option and explain why independent creation and migration is safer to validate.

---

## B. Local working copy migration

### B1 — Create a fresh sibling working copy — recommended

Verify access to the parent directory. Clone the new canonical repository into a new sibling folder. Validate remotes, branch tracking, build, and tests there. Keep the old working copy unchanged until the new one is accepted.

### B2 — Keep the existing working copy temporarily

Update its remote configuration only after the new remote has been validated. Do not change the top-level directory yet.

### B3 — Maintain both working copies during transition

Use the new clone for migration work while the old checkout remains available as a reference for a defined transition period.

Do not make local folder deletion part of the initial migration step.

---

## C. Previous Git repository lifecycle

Show this block when a new Git repository is proposed.

### C1 — Archive or make read-only with a successor notice — recommended

Keep history and public links available. Add a clear pointer to the successor. Prevent new development in the previous repository where the platform supports it.

### C2 — Keep active during a transition period

Use when automation, consumers, or contributors need time to move.

### C3 — Consider retirement later

Do not remove the previous repository during the initial migration. Reassess only after the successor has been validated and consumers have migrated.

Permanent removal must never be bundled implicitly into the initial migration approval.

---

## D. Product naming scope

### D1 — Migrate public identities and their direct technical contracts — recommended

Apply the target product identity consistently to repository references, solution, primary project, assembly, package, root namespace, executable or command name where applicable.

Keep unrelated internal helper names unchanged unless consistency requires them to move with the public product.

### D2 — Migrate only low-risk unpublished identities

Keep established public package, assembly, namespace, or command names for now.

### D3 — Full product migration

Change all relevant public and internal identities. Use only with a deliberate compatibility and publication strategy.

---

## E. Published artifact transition

Show this block when a package, module, command, image, installer, or release is already published.

### E1 — Publish a successor and deprecate or unlist the previous artifact where supported — recommended

Keep existing versions installable when necessary. Point users to the successor. Verify the exact platform capabilities before acting.

### E2 — Keep the published identity and migrate only unpublished parts

Use when changing the public contract would produce disproportionate disruption.

### E3 — Introduce the new identity through a major release or explicit breaking migration

Use when the public identity must change and compatibility cannot reasonably be preserved.

### E4 — Archive, hide, or reduce discovery where supported

Use for obsolete artifacts that should remain accessible for existing consumers but should no longer be promoted to new users.

For every artifact state exactly:

- platform,
- old identity,
- proposed successor,
- supported lifecycle action,
- whether old versions remain reachable or installable,
- user-facing migration path.

---

# 7. Git-first execution model

When a new Git repository is approved, complete the Git migration as its own phase before changing product, package, assembly, or namespace identities.

The Git phase includes Git identity and direct Git references only.

It may include:

- target repository creation,
- Git history migration,
- branches and tags,
- Git LFS migration,
- default branch configuration,
- remote configuration,
- repository URLs,
- clone URLs,
- badges,
- source repository metadata,
- issue and support URLs,
- submodule URLs,
- CI/CD references to the repository,
- documentation links that identify the Git repository.

It must not silently include:

- package ID changes,
- assembly name changes,
- root namespace changes,
- executable or command renaming,
- public API migration,
- publication lifecycle actions unrelated to the Git move.

Those belong to later explicit phases.

---

# 8. Detailed Git migration sequence

Use this sequence after explicit authorization.

## Step 0 — Complete and remotely secure the source state

Before any target repository is created, independently verify that the source-state preflight passes.

If open work exists, remain read-only until it has been completed through the repository's normal user branch workflow. Do not create a special branch or tracking issue as a workaround.

Verify that:

- all intended changes are completed and committed on their normal intended branches,
- no unfinished work has been moved to a special migration, safety, or temporary branch to bypass the gate,
- every relevant commit is present on an accessible remote,
- local and remote commit IDs match,
- branch tracking is correct,
- the canonical upstream relationship has been fetched and reconciled or explicitly documented,
- no relevant work remains only in stashes, untracked files, ignored local state, additional worktrees, submodules, or unpublished branches,
- required tags and Git LFS objects are available remotely.

Record the final source commit that will be migrated.

Do not proceed to Step 1 unless the mandatory source-state completion gate passes.

## Step 1 — Capture the source state

Record:

- current repository URL,
- owner and visibility,
- default branch,
- remotes,
- branch tracking,
- all local branches,
- remote branches,
- tags,
- relevant commit IDs,
- worktree status,
- unpublished local commits,
- Git LFS usage,
- submodules,
- release and automation dependencies.

Stop if the working state contains unreviewed local work that could be lost or omitted.

## Step 2 — Verify permissions and target availability

Confirm that the target repository can be created with the intended:

- owner or organization,
- target name,
- visibility,
- permissions,
- default branch strategy.

Confirm that the current credentials permit both repository creation and push.

Do not modify the source repository yet.

## Step 3 — Create the target repository

Create a new empty target repository.

Avoid automatically generated commits such as an initial README when they would interfere with a history-preserving migration.

Record the canonical target URL.

## Step 4 — Migrate Git history and references

Transfer all required Git content, including as applicable:

- complete commit history,
- branches,
- tags,
- Git LFS objects,
- required notes or special references.

Do not assume that a normal push of the current branch constitutes a complete repository migration.

## Step 5 — Validate the target remote

Verify independently:

- expected branches exist,
- expected tags exist,
- important source and target commit IDs match,
- default branch is correct,
- read access works,
- push access works,
- branch tracking can be configured correctly,
- Git LFS objects are available,
- submodule relationships remain valid or have an explicit migration plan.

Use a fresh clone as a primary validation method.

A successful push alone is not sufficient proof.

## Step 6 — Create a fresh local sibling checkout

Check access to the parent directory first.

Create a new sibling folder by cloning the validated target repository.

In the new checkout verify:

- `origin` points to the target repository,
- `upstream` exists only when it has a real distinct purpose,
- branch tracking points to the correct remote branches,
- the expected latest commit is checked out,
- tags are present,
- submodules and LFS content resolve,
- repository-specific tooling can run.

Do not overwrite or remove the old checkout.

## Step 7 — Update direct Git references

Search for all references to the previous Git repository.

Update confirmed references such as:

- README links,
- badges,
- clone commands,
- repository metadata,
- source links,
- issue links,
- support links,
- submodule URLs,
- CI/CD repository references,
- release scripts,
- documentation links.

Do not use blind global replacement without reviewing context.

## Step 8 — Commit and push the Git-reference migration

Review the diff.

Commit only the Git-focused changes.

Push to the new canonical repository only when commit and push are included in the user's execution authorization.

## Step 9 — Validate from the new canonical state

From the new sibling checkout:

- fetch from the target remote,
- verify clean status,
- verify remote URLs,
- verify branch tracking,
- verify the expected commit is remote,
- run relevant builds and tests,
- verify documentation links where practical,
- search for unintended remaining references to the previous repository.

## Step 10 — Transition the previous repository

Only after successful target validation apply the separately approved transition action:

- archive,
- make read-only,
- add a successor notice,
- keep active for a transition period,
- or defer any lifecycle change.

Do not remove the previous repository as part of this step unless the user issued a separate, explicit, informed instruction after validation.

## Step 11 — Local cleanup is a later decision

The old local folder remains available until:

- the new clone is independently validated,
- all required local-only files have been identified,
- builds and tests succeed,
- remotes and tracking are correct,
- the user has accepted the new working location.

Any later cleanup must first show the user:

- old path,
- new path,
- validation status,
- untracked or ignored files found only in the old path,
- the exact proposed cleanup action.

Do not treat local cleanup as an automatic consequence of migration approval.

---

# 9. Discussion and final plan

After the user selects options, do not execute immediately.

First:

1. update the plan,
2. test the selected options for consistency,
3. identify contradictions or missing decisions,
4. incorporate new facts from the discussion,
5. present the consolidated final plan.

The final plan must include:

- selected options,
- changed recommendations,
- final main mappings,
- Git migration strategy,
- local working copy strategy,
- publication lifecycle strategy,
- ordered execution phases,
- validation criteria,
- explicitly excluded actions,
- remaining unknowns and risks.

Keep the final user-facing plan readable. Put detailed technical inventories in supporting sections rather than the main decision summary.

---

# 10. Execution authorization

Option selection alone is not execution authorization.

For example:

```text
A1, B1, C1, D1, E1
```

means:

- update the plan,
- verify consistency,
- present the final plan,
- remain read-only.

Valid execution instructions include:

```text
Implement the final plan.
```

```text
Implement A1, B1, C1, D1, and E1 as consolidated in the latest plan.
```

```text
Implement everything using the recommended options from the final plan.
```

If commit, push, repository creation, archival, publication, deprecation, unlisting, or visibility changes are intended, the final plan must make them explicit.

A generic instruction to “continue” must not be interpreted as permission for destructive, external, or publication-related actions when the scope is unclear.

---

# 11. Hard read-only boundary

Before explicit execution authorization, do not:

- create a remote repository,
- change repository settings,
- alter repository visibility,
- change remotes,
- create or remove local working folders,
- modify files,
- change solutions or projects,
- change package IDs,
- change assembly names,
- replace namespaces,
- change command names,
- modify build or release configuration,
- alter documentation,
- deprecate publications,
- unlist or hide publications,
- archive repositories,
- commit,
- push,
- publish.

Only reading, analysis, planning, and plan discussion are allowed.

---

# 12. Execution safety rules

After authorization:

1. Implement only the final agreed plan.
2. Recheck external state immediately before external writes.
3. Preserve the source until the target is validated.
4. Prefer new independently testable targets over in-place transformations.
5. Do not perform unplanned cleanup.
6. Do not use blind global replacement for naming changes.
7. Stop when new facts materially change the approved plan.
8. Discuss substantial deviations before implementing them.
9. Verify platform capabilities before lifecycle actions.
10. Keep Git migration, product identity migration, and publication transition as separately reviewable phases.
11. Validate after every major phase.
12. Report exactly what was changed, what remains, and what was intentionally preserved.

---

# 13. Validation requirements

The final validation must cover all applicable areas.

## Git

- target repository exists,
- correct owner and visibility,
- expected branches and tags,
- matching important commit IDs,
- correct default branch,
- correct `origin`,
- correct and intentional `upstream`,
- correct branch tracking,
- successful fetch,
- authorized push confirmed,
- fresh clone successful,
- LFS and submodules verified where applicable.

## Local working copy

- new sibling directory exists,
- source directory still intact unless separately approved otherwise,
- no local-only required files were omitted,
- repository status clean after committed work,
- build and tests succeed where available.

## References

- old Git URLs removed from places that must migrate,
- intentional historical references preserved,
- badges and clone instructions updated,
- package repository metadata updated,
- CI/CD and release links updated,
- no accidental replacement inside changelogs, history, or migration documentation.

## Product identity

For later naming phases:

- repository, solution, project, assembly, package, command, and namespace identities match the approved mapping,
- intentionally unchanged identities are documented,
- compatibility measures are present,
- builds and tests succeed,
- packaging output is inspected,
- published migration guidance is accurate.

## Publication lifecycle

- lifecycle feature is supported by the platform,
- selected action was applied only to approved artifacts,
- old versions remain accessible where required,
- successor is clearly identified,
- migration instructions are available,
- no artifact was removed merely because a successor exists.

---

# 14. Final execution report

After implementation, report:

### Implemented decisions

List the selected option codes and their meaning.

### Created targets

List new repositories, folders, packages, or other successor identities.

### Migrated content

Summarize history, branches, tags, files, references, and product identities migrated.

### Validation

Report Git, local clone, build, test, package, and publication checks.

### Preserved sources

List old repositories, folders, packages, names, or versions intentionally retained.

### Lifecycle actions

List archival, deprecation, unlisting, visibility, or successor notices actually applied.

### Remaining work

List later phases, transition periods, consumer migrations, or cleanup decisions still pending.

### Commit and push status

State exactly which repository and branch contain the committed changes and whether they were pushed.

---

## Default recommendation

When the repository identity must change and no contrary facts are found, the default strategy is:

```text
A1 — create a new repository and migrate
B1 — create a fresh sibling working copy
C1 — archive or make the previous repository read-only with a successor notice
D1 — migrate public identities and their direct technical contracts
E1 — publish successors and deprecate or unlist previous artifacts where supported
```

The default sequence is:

```text
read-only investigation
→ initial user-facing plan
→ option discussion
→ consolidated final plan
→ explicit execution authorization
→ create new Git target
→ migrate and validate Git
→ create and validate fresh local checkout
→ update Git references
→ commit and push Git-focused changes
→ migrate product identities in later reviewable phases
→ transition published artifacts
→ archive previous sources where approved
→ consider cleanup only as a separate final decision
```

The old repository, old local checkout, and old published artifacts remain available until the successor has been independently validated and the user has explicitly approved the relevant lifecycle action.
