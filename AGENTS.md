# AGENTS.md

## Required confirmation
- Confirm that you have read `AGENTS.md`.
- The confirmation must be ultra-short.
- On the first read for a task or session, review all applicable sections below before proceeding.

## Checked steps summary
- After the confirmation, provide a very short status summary of all applicable `AGENTS.md` checks and actions for the current task.
- Do not omit any applicable section that was reviewed, executed, skipped, blocked, or deferred.
- Use short checklist items only.
- Use these status markers:
  - `[x]` completed or checked
  - `[-]` skipped because not applicable
  - `[!]` blocked, deferred, or requires user input
- If an item is skipped, blocked, or deferred, include a very short reason.
- On the first read for a task or session, this summary must cover all applicable sections triggered by `AGENTS.md`, not just a selective subset.
- Keep it brief, factual, and execution-focused.

Example:
- [x] Read `AGENTS.md`
- [x] Reviewed task list requirement
- [x] Checked `.gitignore`
- [-] Skipped GitHub CLI checks (`gh` not available)
- [!] Deferred structure migration; prompt generation only

## Change summary
- If following `AGENTS.md` caused any changes, include an ultra-short factual summary together with the `AGENTS.md` update.
- Reference `AGENTS.md` as the reason for the change.
- Omit this section if nothing was changed.

## Execution behavior
- For any non-trivial request, first decompose the work into an executable task list before making code changes.
- If the work naturally splits into distinct phases, chains, or concern areas, organize the plan into task groups instead of one flat list.
- Create task groups when separate workstreams improve clarity, such as setup, refactoring, implementation, validation, documentation, or follow-up fixes.
- Keep task lists concrete and action-oriented.
- Keep exactly one task in progress at a time unless parallel work is clearly safe and beneficial.
- Update the task list whenever scope changes, new dependencies are discovered, or a task is completed, blocked, or no longer relevant.
- Preserve execution momentum: task tracking should support implementation, not delay it.
- For trivial, localized work, skip task decomposition and execute directly.
- Before finishing, reconcile the task structure so each task or subtask is marked as completed, blocked, cancelled, or intentionally deferred.

## Other AGENTS.md Files

### .agents/AGENTS-PROJECT.md
- If `.agents/AGENTS-PROJECT.md` does not exist, create it.
- If it already exists, review and update it when repository-specific guidance is missing, outdated, or too vague.
- `.agents/AGENTS-PROJECT.md` should contain only repository-specific instructions that help an agent work correctly in this codebase.
- It should complement `AGENTS.md`, not repeat general execution rules already defined there.
- Include concrete project facts such as:
  - project purpose and main components
  - repository structure and important directories
  - targeted runtime and toolchain versions
  - IDE / development environment version and required extensions or setup
  - build, test, lint, typecheck, and local run commands
  - project-specific coding conventions and architectural constraints
  - generated files, protected areas, or files that should not be edited manually
  - validation steps required before finishing changes
  - environment, dependency, or deployment notes relevant to development
- Keep the file concise, actionable, and specific to the repository.
- Prefer facts and instructions over broad descriptions.
- The `.agents/AGENTS-PROJECT.md` file needs to include at least a minimal list of top-level directories and their purpose.
- If the repository contains `.github/workflows/*.yml` or `.github/workflows/*.yaml` files, `.agents/AGENTS-PROJECT.md` should summarize the relevant workflows, including their trigger conditions and the main actions they run, so an agent is aware of what may happen on push, pull request, merge, or manual dispatch.
- Keep `.agents/AGENTS-PROJECT.md` updated with the OS and OS version of the user's current active development environment so the agent always knows which system the user is working on, using scripting or shell commands to determine that information when possible.

## Git specific
- If Git is not available or the workspace is not a Git repository, skip this section.
- Ensure the repository has a `.gitignore` file.
- If `.gitignore` does not exist, create it.
- Check whether the following ignore patterns are present in `.gitignore`:
  - `*[Ss][Ee][Cc][Rr][Ee][Tt]*`
  - `*[Kk][Ee][Yy]*`
  - `AGENTS.md`
  - `.agents/**/*`
- If a file is both tracked and ignored, remove it from Git tracking (`git rm --cached`) while keeping the file in the working tree.
- Do not untrack files that are not ignored.
- If any of these patterns are missing, add them.
- Do not add duplicate entries if an equivalent pattern already exists.
- Preserve existing `.gitignore` contents and append missing rules in a minimal way.

## GitHub CLI specific (with Git)
- If Git or `gh` is not available, skip this section.
- Check that this is a Git repository.
- Identify the effective remote and resolve its GitHub owner/repo.
- Check that `gh` is installed and authenticated.
- Verify that `gh` can access the same repository.
- Compare with `gh repo list` if helpful.
- Report any mismatch clearly.
- Do not change remotes or authentication.

## GitHub CLI actions
- If Git or `gh` is not available, skip this section.
- Proceed with `gh` actions only if the Git remote and the current `gh` context resolve to the same GitHub owner/repository.
- Require confirmed `gh` authentication and confirmed access to that repository.
- If either check fails, skip the rest of this section.
- Do not modify remotes or authentication automatically.
- Read open issues to get current project context and known problem areas.
- Treat issues as hints, not as verified facts.
- Do not investigate or fix issues unless the current task explicitly requires it.
- Use issue context only to inform decisions and avoid redundant or conflicting actions.
- Check the repository description and topic tags.
- If they are missing, incomplete, outdated, or clearly inaccurate, update them.
- If the existing description and topic tags are already present and sufficiently accurate, leave them unchanged.

## GitHub repositories
- Read `.git/config` in read-only mode to determine whether the repository is hosted on GitHub.
- If it is not a GitHub repository, skip this section.
- Currently not github specific instructions are in, so skip this here anyway ;)

## Year references in informational text
- Update outdated informational year references, including copyright or licensing notices, to the current year where appropriate.
- Do not change ranges like `2025-2026`.
- Do not change code, structured, or historical year references.
- If unsure, leave it unchanged.

## Source code directory structure
- All source code must be stored under `/src`.
- The layout must always support multiple workspaces or solutions, even if only one exists.
- The main workspace or solution file must be placed directly in `/src`.
- Workspace- or solution-specific files must be stored in `/src/sln/<workspace-name>`.
- All projects referenced by the workspace or solution must be stored in `/src/prj`.
- At least one project must exist with the exact same name as the workspace or solution. This is the main project.
- If deviations from this target structure exist, do not perform the analysis or migration in this step.
- Instead, generate only a generic prompt for the user that instructs the agent to analyze the current structure and convert it to the required target structure.
- This output must contain prompt generation only. It must not include the actual deviation analysis, migration plan, or implementation details.

Example:
For a workspace named `MyApp`:
- Solution file: `/src/MyApp.sln`
- Solution files: `/src/sln/MyApp/`
- Main project: `/src/prj/MyApp/`
- Other projects: `/src/prj/MyApp.Core/`, `/src/prj/MyApp.Tests/`

Suggested generic user prompt:
Analyze the current source code directory structure and compare it with the required target structure. Identify all deviations and update the repository to match the target structure exactly. Move and rename files and directories as needed, but keep the project functional. Use this target layout: the main solution file in `/src`, solution-specific files in `/src/sln/<workspace-name>`, and all projects in `/src/prj`, with at least one main project matching the workspace or solution name. Update all affected files as needed so that paths, references, and configuration remain consistent after the structural changes.