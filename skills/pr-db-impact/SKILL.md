---
name: pr-db-impact
description: Analyze the current branch's PR (or working diff) for potential database performance side effects — load spikes, query latency, lock contention, or connection pressure after deployment. Use when the user asks "will this PR hurt the database", "check for DB side effects", "any query performance risk here", or invokes /pr-db-impact. Focuses on missing indexes, N+1 patterns, unbounded queries, blocking migrations, hot Celery/cron tasks, cache removal, long transactions, and unbatched bulk operations.
---

# PR Database Impact

Use this skill when the user wants to know whether the changes in the current PR or branch could cause database load spikes (CPU, query latency, connection pressure, lock contention) after deployment.

## Goal

Review the PR diff and answer two questions:

1. Which specific changes could degrade database performance in production, and how?
2. Is the PR safe to deploy from a database-load perspective?

## Workflow

1. Get the diff.
   Prefer the PR diff for the current branch: `gh pr diff`.
   If there is no open PR, fall back to `git diff master...HEAD` (or the repo's default base branch).
   If there are no changes at all, say so and stop.

2. Scope to DB-relevant changes.
   Prioritize files touching: models, migrations, ORM queries (views, serializers, services, managers), Celery tasks, cron/schedule definitions, management commands, caching layers, and raw SQL.
   Skip files with no data-access implications (pure frontend, docs, tests) unless a test change reveals intended query behavior.

3. Check each risk category against the diff.

   **Queries**
   - New or modified queries with no index supporting their filter/order columns — check the model's `Meta.indexes`, `db_index`, and unique constraints before flagging.
   - Full table scans: filters on unindexed columns of large tables, `__icontains`/`__iregex` on text columns, leading-wildcard patterns.
   - `SELECT *` equivalents where a narrow `.only()` / `.values()` would avoid wide-row reads on hot paths.
   - Unbounded result sets: `.all()` or wide filters materialized into lists without `LIMIT`, slicing, or iterator batching.

   **N+1 patterns**
   - Loops issuing queries per iteration, including implicit ones: attribute access on FK/related objects inside `for` loops, list comprehensions, serializer methods, or template rendering.
   - Missing `select_related` / `prefetch_related` on querysets whose related objects are accessed downstream.

   **Pagination**
   - New or modified list/fetch endpoints without pagination or an explicit `LIMIT`.
   - Pagination that exists but is bypassable (e.g., client-controlled page size with no cap).

   **Migrations**
   - Operations that take blocking locks on large tables: adding a column with a computed/non-null default, altering column types, adding constraints that validate existing rows.
   - Index builds on large tables without a concurrent strategy.
   - Data migrations that update many rows in a single transaction or without batching.
   - Multiple schema operations on the same large table in one migration (one long lock window).

   **Background work**
   - New or rescheduled Celery tasks / cron jobs that query or write at scale — estimate row counts touched per run and run frequency.
   - Tight schedules (every minute or less) hitting non-trivial queries.
   - Fan-out patterns: one task spawning per-row tasks that each open connections.

   **Caching**
   - Removed or shortened caches on read paths, cache keys made more granular (lower hit rate), or invalidation changes that increase DB reads.

   **Transactions and locking**
   - `transaction.atomic()` blocks wrapping slow work (external API calls, loops, sleeps) — locks and connections held for the duration.
   - `select_for_update` on hot rows or without `skip_locked` where contention is plausible.

   **Bulk operations**
   - `bulk_create` / `bulk_update` / `.update()` / `.delete()` over large row counts without `batch_size` or chunking.
   - Cascading deletes (`on_delete=CASCADE`) triggered on parents with many children.

4. Ground each finding in the code.
   Read the surrounding model definitions, existing indexes, and callers before flagging. Do not flag a missing index without checking the model's `Meta` and migrations for one that already covers the query.

5. Rate severity.
   - `P0`: likely to cause an incident at current production scale (blocking migration on a large table, unbounded scan on a hot endpoint, N+1 on a high-traffic path).
   - `P1`: real degradation risk that depends on data volume or traffic growth.
   - `P2`: inefficiency worth fixing but unlikely to page anyone.

## Review Rules

- Cite the file and line for every finding, explain the concrete failure mode (what spikes: CPU, latency, connections, locks), and suggest a specific mitigation.
- Prefer confirmed issues over speculative ones; when a risk depends on table size or traffic that cannot be verified from the code, say so and state the assumption.
- Table size matters: a full scan on a 500-row lookup table is not a finding. When the repo gives no size signal, flag it as volume-dependent rather than asserting an incident.
- Do not flag style or general code quality — only database load, latency, and locking behavior.
- If nothing raises a red flag, say so explicitly rather than inventing weak findings.

## Output Format

### Findings
- [severity] `file:line` — [risk and what it does to the DB]. Mitigation: [specific fix].

### Verdict
[1-3 sentences: safe to deploy from a DB-load perspective, or what must change first.]

### Assumptions
- [optional: table sizes, traffic levels, or schedules assumed when the code alone couldn't confirm]

## Notes

- For Django, common mitigations to suggest: `select_related`/`prefetch_related`, `.iterator(chunk_size=...)`, `Paginator`, `db_index=True` or `Meta.indexes`, `batch_size` on bulk ops, splitting migrations, `SeparateDatabaseAndState`, or moving heavy work out of `transaction.atomic()`.
- For blocking migrations, prefer the additive pattern: add nullable column → backfill in batches → add constraint.
- A removed cache line is easy to miss in a diff — check deletions, not just additions.
