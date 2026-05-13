---
name: codingal-extract-model-changes
description: Create a new branch from updated master in the Codingal repo, pull over all migration files from the current source branch plus the backend files that caused those migrations, keep same-app admin wiring by default, and then run the `pr-create` skill to open a PR for the extracted branch.
---

# Codingal Extract Model Changes

Use this skill when the user asks to split migration-causing backend work into a new branch from `master`, move database and migration changes off the current branch, or create a clean migration-first branch for the Codingal repo.

## Scope

This skill is for the Codingal monorepo only.

It extracts a migration-first backend slice from the current branch by default:
- all changed migration files
- the backend files that caused those migrations
- same-app `admin.py` changes when they changed alongside the extracted model work

The default causing files are:
- `models.py`
- same-app `enums.py` when the changed model or migration depends on enum values from that file
- other backend files only when they directly caused the carried migration files

It does not pull `serializers.py`, `views.py`, or `forms.py` by default because those files are more likely to keep changing while the main PR is still evolving.

Do not create new migrations in this workflow. Only carry over migration files that already exist on the source branch.

## Preconditions

1. The source branch must not be `master`.
2. The source branch should be clean before branch extraction.
3. If `git status --short` shows tracked or untracked changes that are part of the intended slice, stop and ask the user to commit or stash them first.
4. Never push automatically except as part of the explicitly requested `pr-create` follow-up.

## Workflow

1. Capture the source branch with `git branch --show-current`.
2. Inspect repo state with:
   - `git status --short`
   - `git diff --name-only master...HEAD`
3. Identify all changed migration files on the source branch.
   - Start from files matching `api/apps/*/migrations/*.py`.
4. For each changed migration file, identify the backend files that caused it.
   - Prefer changed same-app `models.py` first.
   - Include same-app `admin.py` when it changed alongside the model work.
   - Include same-app `enums.py` when the changed model or migration depends on enum values from that file.
   - Only include other backend files when they directly caused the carried migration file.
5. If no changed migration files are found, stop and tell the user there is no migration slice to extract.
6. Summarize the selected files before switching branches.
7. Update local `master` non-interactively.
   - `git fetch origin master`
   - `git switch master`
   - `git pull --ff-only origin master`
8. Create the target branch from updated `master`.
   - Default branch name: `<source-branch>-models`
   - If that name already exists, append a short suffix such as `-2`.
9. Bring the selected files over from the source branch with file checkout, not commit cherry-pick.
   - Use `git checkout <source-branch> -- <selected files>`
10. Show the resulting diff with:
   - `git status --short`
   - `git diff --stat`
11. Commit the extracted slice if the user asked for the full handoff flow.
12. Run the `pr-create` skill automatically after the extraction branch is ready.
13. Resolve the source branch PR title first with `gh pr view --json title` when available.
14. Give `pr-create` a plain PR summary sentence derived from the source branch PR title first, then fall back to the source branch slug, then the migration feature name.

## PR Title Guidance

When handing off to `pr-create`, use a short, plain description in this shape:
- `database and migration changes for <feature>`

Refine `<feature>` from the source branch PR title first. If no PR exists, derive it from the source branch slug. If that is still unclear, use the model feature itself.
Prefer concise phrasing such as:
- `database and migration changes for class audits`
- `database and migration changes for teacher leave logs`
- `database and migration changes for payout profile updates`

Strip ticket prefixes such as `CE-1234:` and keep only the feature phrase. Do not use vague placeholders such as `xxx`.

## Selection Rules

1. Keep the slice narrow.
2. Start from all changed migration files, then pull in the backend files that caused those migrations.
3. Include same-app `admin.py` by default when it changed alongside extracted model work.
4. Include same-app `enums.py` only when the changed model or migration directly references enums from that file.
5. Do not automatically pull `serializers.py`, `views.py`, or `forms.py` unless the user explicitly asks for a broader backend slice or a carried migration clearly depends on them.
6. Do not automatically pull unrelated frontend files, docs, Slack scripts, or release files.
7. If a migration was triggered by permission-enum or schema-state updates that support the extracted backend slice, carry both the migration file and the causing backend file.
8. If the migration cause is ambiguous, prefer the smallest backend set that still explains and supports the carried migration.

## Safety Rules

1. Never use destructive git commands such as `reset --hard`.
2. Never overwrite uncommitted work on the source branch.
3. Do not push the new branch manually; let `pr-create` own the commit, push, and PR creation flow.
4. Never create or apply Django migrations as part of this skill.

## Example Trigger Phrases

- `Create a new branch from master and move only the model changes there.`
- `Split the model and migration work into a clean branch.`
- `Pull all model-related changes from this branch into a fresh branch off master.`
- `Create the model-only branch and open the PR automatically.`
