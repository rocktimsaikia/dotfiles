---
name: optimize-redash
description: >
  Make an EXISTING Redash query (Codingal, Python/Django ORM on data source 1)
  FASTER without changing its output. Use when the user says "optimize this redash
  query", "this redash query is slow", "speed up query #N", "why is this redash
  report timing out", or invokes /optimize-redash. Primary job: kill query-time
  cost — N+1 loops, missing select_related/prefetch_related, per-row DB calls,
  Python-side aggregation, and unbounded scans. Behavior-preserving. For a new query
  use create-redash; for a feature change use update-redash. Uses mcp__redash__*.
---

# Optimize Redash query (make it FAST, behavior-preserving)

Rocktim's Redash queries are **Python (Django ORM)** on **`data_source_id: 1`** that
print **tab-separated rows**. **This skill exists to make a query faster.** The whole
job is cutting query-time DB cost while keeping the **output identical** (same
columns, same order, same rows). If a fix would change the output, flag it and ask —
don't ship it silently.

**Where the time goes — measure first.** Slowness in these reports is almost always
**too many SQL round-trips**, not CPU. The single biggest win is collapsing a loop
that fires one query per row into a constant number of queries. Find the loop, count
how many DB hits it makes per iteration, and drive that to zero. When feasible,
`execute_query` the current version and note the runtime so you can prove the speedup.

## Tools

Load with one ToolSearch call:
`select:mcp__redash__get_query,mcp__redash__update_query,mcp__redash__get_my_queries,mcp__redash__execute_adhoc_query,mcp__redash__execute_query`

- `get_query` to read the current query (always first).
- `get_my_queries` to find by name (large result → saved to file, grep it).
- `execute_adhoc_query` / `execute_query` to compare output before vs after.
- `update_query` to save the optimized version.

## Performance checklist (in priority order)

1. **N+1 in the row loop** — the #1 culprit. Any `obj.relation` / `obj.relation.sub`
   touched inside `for ... in rows:` that isn't covered by `select_related`/
   `prefetch_related` fires one query per row. Add the relations to the queryset:
   - FK / one-to-one → `select_related("customer__student")`
   - reverse FK / M2M → `prefetch_related("payments")`
2. **Per-row ORM calls** — a `.objects.filter(...)`, `.count()`, `.get(...)`, or a
   model method that hits the DB *inside* the loop. Hoist it: pre-fetch in bulk
   before the loop into a dict keyed by id (`{x.id: x for x in ...}`), or fold it
   into an `.annotate(...)`.
3. **Aggregation in Python over a full scan** — summing/counting by iterating all
   rows. Replace with `.values(...).annotate(total=Sum(...))` (`Sum/Count/Max/Min/F`
   from `django.db.models`) so the DB does it.
4. **Unbounded scan** — no date/status filter, or `.all()` over a huge table. Push
   filters into `.filter(**kwargs)`; ensure the date-range param actually narrows it.
5. **Fetching more than you print** — `.only(...)`/`.values(...)` when only a few
   fields are emitted; drop `select_related` for relations the loop never touches.
6. **Repeated work** — recomputing a constant (e.g. `IST` lookups, exchange rates,
   a `set()` of ids) inside the loop. Hoist it out.

## Correctness (only if you spot it — don't go hunting)

Speed is the job. But if a real bug is staring at you while you rewrite, fix it: a
header ↔ row column-count mismatch, free text joined unsanitized (wrap with
`re.sub(r'[\n\t\r]', ' ', text)`), a date missing `IST.normalize(...)`, a non-`str(...)`
value, or `.id` where it should be `._id`. Don't expand scope chasing these — if the
query is correct and just slow, leave it alone and ship the speedup.

## Behavior-preserving guarantees

- Keep column **order, names, and count** exactly as-is unless the user asks otherwise.
- A perf rewrite (e.g. moving aggregation into `.annotate`) must produce the **same
  numbers**. When feasible, run `execute_query` before and `execute_adhoc_query`
  after and eyeball that the rows match.
- Don't add Django bootstrap lines (the runner already has Django context).
- If a slow query is slow because it genuinely returns a lot of data, say so — adding
  pagination/limits *changes output*, so that's a user decision, not a silent fix.

## Workflow

1. Get the query id (ask or `get_my_queries`); `get_query` to read it.
2. Walk the perf checklist top-down; note each issue found and the fix.
3. Walk the correctness checklist; fold in any real bugs.
4. Rewrite, preserving output. Confirm field/method names against the repo
   (`api/apps/<domain>/`) before relying on them.
5. Compare output before/after via `execute_query` / `execute_adhoc_query` if feasible.
6. `update_query` with the optimized version.
7. Report: query URL (`https://redash.codingal.com/queries/<id>`) + a short bullet
   list of what was changed and the expected speedup (e.g. "N+1 → 1 query: ~Nx fewer
   DB hits").
