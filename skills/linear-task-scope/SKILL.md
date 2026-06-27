---
name: linear-task-scope
description: Scope a Linear issue (or any described task) and produce a tight, code-grounded execution plan without writing any code. Use when the user shares a Linear URL/issue ID and asks to "scope this task", "create an execution plan", "plan this out (don't code)", or wants a touchpoint map before implementation. Fetches the issue, fans out to explore the codebase, verifies findings against real files, right-sizes scope to the issue's point estimate, and returns a files-and-edits plan plus out-of-scope items and open decisions.
---

# Scope Task

Use this skill when the user shares a Linear issue (URL or ID) and asks to scope it / create an execution plan, and explicitly does NOT want code written yet.

## Goal

Turn a task into a concise, code-grounded execution plan: exactly which files change and how, what is deliberately left out, how to verify, and any decision that needs the user before coding.

## Workflow

1. **Fetch the issue.**
   If given a Linear URL or ID, call `mcp__claude_ai_Linear__get_issue` (load it via ToolSearch first if deferred). Capture title, description, acceptance details, attachments, and especially the **estimate / story points** and **priority** — they set how big the scope is allowed to be.
   If no issue link, work from the user's described task alone.

2. **Fan out to map touchpoints.**
   Launch an `Explore` agent (read-only, "very thorough") to find every place an analogous existing thing is wired in — the template to copy. For "add an X like the existing Y", make it find Y's real code constant first, then every file/enum/map/config/template/test that references Y.

3. **Verify, do not trust.**
   Explore output is a lead, not gospel. Read the actual files for the key touchpoints yourself (`Read`/`grep`) and confirm the real pattern, exact line locations, and naming convention before writing them into the plan. Drop speculative items the code does not actually require.

4. **Right-size to the estimate.**
   A 1-2 point issue is narrow — match the literal scope words in the title ("on the fee tool and payments" ≠ landing pages, marketing surfaces, or DB migrations unless required). Cut anything the scope does not name. Check git log / recent commits for sibling work already done separately (e.g. a constant added in an earlier commit) so the plan does not redo it.

5. **Produce the plan (see Output). Write no code.**

## Output Format

Lead with a one-line restatement of the task and the template-to-copy, then:

### Files & edits
A table or tight list: each file → the exact edit(s), referenced by symbol/anchor (and approx line). One row per concrete change. Note the single generic resolver/entry point that makes the rest "just work" if there is one.

### Not touched (and why)
A short list of plausible-but-out-of-scope items with a one-clause reason each. This is where right-sizing earns its keep.

### Verify
The minimal runnable check(s): the specific test command, the page/flow to load, the expected observable result. Flag if the environment cannot run them (e.g. no Docker) and say what the user must run before merging.

### Open decisions
Only genuine forks the user must resolve before coding (a naming convention, an ambiguous label, an include/exclude call). Give a recommended default for each. If there are none, omit this section.

## Rules

- **Write no code and make no edits.** This skill ends at the plan. Stop and let the user approve before any implementation.
- Keep it decision-useful and concise — a touchpoint map, not an essay. No diff dumps.
- Ground every claimed edit in a file you actually read. If you could not verify something, say so explicitly rather than asserting it.
- Respect repo conventions (CLAUDE.md backend/frontend docs, naming, no migrations) when describing edits.
- Surface a genuine fork as an open decision with a recommended default; do not stall on choices with an obvious convention.
