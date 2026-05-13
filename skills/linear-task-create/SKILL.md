---
name: linear-task-create
description: Create a Linear task in the Product Engineering team for Rocktim Saikia, assign it to him by default, place it in the current active cycle, set status to Todo, ask for priority and story points before creating the task, switch to a local git branch named from the created Linear task ID, and then run the `pr-create` skill automatically.
---

# Linear Task Create

Use this skill when the user asks to create a Linear task or issue.

## Defaults

1. Assign the task to `Rocktim Saikia`.
2. Always use the `Product Engineering` team.
3. Put the task in the current active cycle for `Product Engineering`.
4. Always set the status to `Todo`.
5. Keep the description concise and easy for anyone to understand.
6. After creating the task, switch to a new local git branch using the created Linear task ID.
7. After switching branches, run the `pr-create` skill automatically.

## Required Questions

Before creating the task, ask the user for:

1. Priority
2. Story points

Ask this in one concise message if the user has not already provided both values.

**Never ask the user for a title or description.** Always auto-generate both:

- The title comes from the user's described task.
- The description is derived from the current staged git changes (`git status`, `git diff --staged --stat`, `git diff --staged`) combined with the user's request context. If there are no staged changes, fall back to the user's request context alone.

## Workflow

1. Use the `Product Engineering` team.
2. Resolve `Rocktim Saikia` as the assignee.
3. Fetch the current active cycle for `Product Engineering`.
4. Ask for priority and story points if missing.
5. Create the Linear issue with:
   - an auto-generated, clear, concise title (never ask the user for it)
   - an auto-generated description that is short, plain-English, and easy for a non-engineer to understand (see "Description Rules")
   - team set to `Product Engineering`
   - assignee set to `Rocktim Saikia`
   - cycle set to the current active cycle
   - status set to `Todo`
   - priority set from the user's answer
   - estimate/story points set from the user's answer
6. After the issue is created, create and switch to a new local git branch using the Linear task ID.
   - Use a branch name that starts with the task ID, for example `CE-1234-short-slug`.
   - Derive the short slug from the issue title in lowercase hyphen-case.
   - Use a non-interactive git command that creates and checks out the branch in one step.
7. After switching to the new branch, immediately run the `pr-create` skill.
   - Use the current task context to give `pr-create` the title and fix summary it needs.
   - Do not stop after branch creation unless `pr-create` is blocked by missing staged changes, missing commit context, or missing GitHub permissions.
   - If `pr-create` cannot complete, report the exact blocker.

## Description Rules

The description goes into the Linear task itself — keep it short and easy for anyone (including non-engineers) to understand.

1. Aim for 2–4 short sentences or bullets. No walls of text.
2. Plain English. Skip code, file paths, function names, diff snippets, framework jargon, and internal shorthand unless the title already uses it.
3. Cover only:
   - what is changing (in user-facing terms)
   - why it matters / expected behavior after the change
4. Source material:
   - if there are staged changes, read them with `git status`, `git diff --staged --stat`, and `git diff --staged`, then translate them into plain language — do not paste the diff
   - if nothing is staged, use the user's request context alone

## Fallbacks

1. Ignore team hints from context unless the user explicitly asks to override the skill behavior.
2. If no active cycle exists for `Product Engineering`, tell the user and create the task without a cycle only if they want that.
