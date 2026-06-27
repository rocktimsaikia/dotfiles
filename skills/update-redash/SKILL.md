---
name: update-redash
description: >
  Update an EXISTING Redash query in Rocktim's Codingal style — Python (Django
  ORM) queries on data source 1 that print tab-separated rows. Use when the user
  says "update a redash query", "add a column to query #N", "change the filter on
  this redash report", "edit redash query ...", or invokes /update-redash. Always
  reads the current query first and preserves the author's column order/naming.
  For a brand-new query use create-redash; for speeding one up use optimize-redash.
  Uses the mcp__redash__* tools.
---

# Update Redash query (Codingal, Python style)

Rocktim's Redash queries are **Python (Django ORM)** queries on **`data_source_id: 1`**
that emit **tab-separated rows** (one header line, then one line per record).
The Redash Python runner already runs inside a configured Django context — **never**
add `import django` / `django.setup()` / `os.environ` / settings bootstrap. There is
no `result`/`add_result_row` API.

**Golden rule for updates: read before you write.** `get_query` first, understand
the existing SQL/columns/params, then make the smallest change that satisfies the
request. **Preserve the author's existing column order and naming** unless asked to
change them. A new column goes where the user asks (default: appended), and its
header is added to the header list at the same position.

## Tools

Load with one ToolSearch call, then use directly:
`select:mcp__redash__get_query,mcp__redash__update_query,mcp__redash__get_my_queries,mcp__redash__update_query_parameters,mcp__redash__execute_adhoc_query,mcp__redash__execute_query`

- **Read current**: `get_query` (by id) — always do this first.
- **Find by name**: `get_my_queries` (paginate; large results are saved to a file — grep it for the name/id).
- **Write**: `update_query` (SQL/name), `update_query_parameters` (params).
- **Test before saving** when possible: `execute_adhoc_query` / `execute_query`.

## Updating safely

- **Don't reformat what you aren't changing.** Keep whitespace, variable names, and untouched columns byte-identical so the diff is reviewable.
- **Header ↔ row invariant**: if you add/remove a column, update BOTH the `print("\t".join([...]))` header AND every data row so the field counts still match.
- **Adding a column**: confirm the field/method exists on the model (read the repo), `str(...)` it, give it a Title Case header with units in parens, and place it where requested.
- **Changing a filter/param**: update the `kwargs`/`Q(...)` logic AND the matching `options.parameters` entry via `update_query_parameters`. Keep the sentinel convention (`"-"`).
- **Removing a column**: drop it from the header and every row; remove now-unused `select_related`/imports if nothing else uses them.

## Hard rules (must still hold after the edit)

- **Output**: `print("\t".join([...]))`. Header printed once; header column count == every row's field count.
- **Stringify everything**: `str(...)` non-strings; missing values → `"N/A"` / `"-"`.
- **IDs**: `student._id` / `teacher._id` (NOT `.id`, NOT `f"s{id}"`).
- **Grade**: bare `student.grade` (already includes "Grade").
- **Dates**: `IST.normalize(dt).strftime(DT_FORMAT_N)` — the `IST.normalize(...)` wrapper is mandatory; use a named constant from `common.constants`.
- **No Django bootstrap lines.**
- **Sanitize free text** before joining: `re.sub(r'[\n\t\r]', ' ', text)`.

## Params

Redash injects params as string placeholders `"{{ Param Name }}"`, sentinel-guarded:

- **text**: default `"-"`; skip the filter when value is `"-"`.
- **enum**: sentinel `"-"` / `"All"` / `"Both"`; `"Yes"`/`"No"` → bool. `enumOptions` newline-delimited.
- **date** / **date-range** (`{{ Name.start }}` + `{{ Name.end }}`): parse `"%Y-%m-%d"`, IST-localize, `+ timedelta(days=1)` on the end.
- **multi-value enum**: `"{{course}}".split(",")`.

`options.parameters` entry shape (pass to `update_query_parameters`):

```json
{"name": "Subject", "title": "Subject", "type": "enum", "value": "-",
 "enumOptions": "-\ncoding\nmath\nela", "global": false, "locals": []}
```

## Formatting conventions

- **Currency**: `f"{p.currency} {float(p.amount)}"`; USD via `round(float(p.amount * p.usd_exchange_rate), 2)`.
- **Phone**: `user.phone.as_e164`. **Country**: `user.country.name`.
- **HTML link columns** (Redash renders HTML), usually `<small>`-wrapped:
  ```python
  f'<small><a href="{p.url}" target="_blank">{p.uuid}</a></small>'
  f'<small><a href="{user.auto_login_url()}" target="_blank">{user.name}</a></small>'
  ```
  Admin link: `f"https://www.codingal.com/api/admin/billing/paymentpage/{id}/change/"`.
- **Column headers**: Title Case, units/subject in parens — `"Created At (IST)"`.

Always read the actual model/helper signature in the repo (`api/apps/<domain>/`) before relying on a field or method — don't assume.

## Workflow

1. Identify the query id (ask, or find via `get_my_queries`).
2. `get_query` to read the current SQL, columns, and params.
3. Confirm any new field/method names against the repo.
4. Make the smallest change; keep header ↔ row counts and all hard rules intact.
5. Test with `execute_adhoc_query` / `execute_query` if feasible.
6. `update_query` (and `update_query_parameters` if params changed).
7. Report the query URL back: `https://redash.codingal.com/queries/<id>`.
