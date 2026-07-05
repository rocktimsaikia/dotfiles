---
name: linear-cycle-scope
description: Fan out scoping of the current Linear cycle. Fetches all of Rocktim's active-cycle Product Engineering issues that have no linked GitHub PR, creates an isolated git worktree per issue, and opens a parallel Claude Code session per issue in its own tmux window running `/linear-task-scope <ISSUE-ID>`. Use when the user says "scope my cycle", "scope all my current cycle tasks", "spin up sessions for my cycle", or invokes /linear-cycle-scope.
---

# Linear Cycle Scope

Fan out one Claude scoping session per unscoped active-cycle task, each in its own git worktree and tmux window.

## Constants

- Team: `Product Engineering`
- Assignee: `me`
- Repo: `~/codingal/main`, base branch `master`
- Worktrees: `~/codingal/worktrees/<branch>`

## Workflow

1. **Fetch candidates.**
   Load `mcp__claude_ai_Linear__list_issues` and `mcp__claude_ai_Linear__get_issue` via ToolSearch if deferred. Call `list_issues` with team `Product Engineering`, assignee `me`, cycle set to the current active cycle. Keep only issues in state `Todo` or `In Progress` (drop In Review, Done, Canceled, Duplicate, Backlog, Triage).

2. **Drop issues that already have a PR.**
   For each candidate, call `get_issue` and inspect its attachments/links. If any attachment URL matches `github.com/.../pull/...`, skip the issue and record it as "PR linked".
   Do NOT skip an issue because its description is thin — the `/linear-task-scope` session handles that by marking it blocked and waiting for context.

3. **Create a worktree per remaining issue.**
   Branch name: use Linear's `gitBranchName` if the issue provides one, else `ce-<number>-<short-slug>` (lowercase hyphen-case slug from the title, matching linear-task-create convention). Then, idempotently:
   ```bash
   git -C ~/codingal/main worktree add ~/codingal/worktrees/<branch> -b <branch> master
   ```
   - Branch already exists → same command without `-b`.
   - Worktree path already registered (check `git -C ~/codingal/main worktree list`) → reuse it as-is, run nothing.

4. **Open one tmux window per issue.**
   Each window starts an interactive Claude session pre-loaded with the scope command:
   ```bash
   tmux new-window -n <CE-XXXX> -c ~/codingal/worktrees/<branch> "claude '/linear-task-scope <CE-XXXX>'"
   ```
   If not running inside tmux (`$TMUX` empty), first create a detached session and target it:
   ```bash
   tmux new-session -d -s cycle-scope
   tmux new-window -t cycle-scope -n <CE-XXXX> -c ~/codingal/worktrees/<branch> "claude '/linear-task-scope <CE-XXXX>'"
   ```
   then tell the user to run `tmux attach -t cycle-scope`.

5. **Summarize.**
   End with a short table: issue ID → title → what happened (window spawned + worktree path | skipped, PR linked | failed, reason). Report worktree or tmux failures explicitly; do not silently drop an issue.

## Rules

- No cap on issue count — a cycle is small; spawn a session for every qualifying issue.
- Never write code or edit the codingal repo from this skill; it only creates worktrees and tmux windows. Scoping happens in the spawned sessions.
- Idempotent re-runs: existing worktrees are reused, issues that gained a PR since last run get skipped. Don't spawn a duplicate window if one named after the issue ID already exists in the target session (`tmux list-windows`).
