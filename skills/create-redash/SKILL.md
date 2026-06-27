---
name: create-redash
description: >
  Create a NEW Redash query in Rocktim's Codingal style — Python (Django ORM)
  queries on data source 1 that print tab-separated rows. Use when the user says
  "create a redash query", "new redash report", "make a redash query for ...", or
  invokes /create-redash. Knows the author's conventions: print("\t".join(...))
  output, IST date formatting, "-" param sentinels, ._id IDs, HTML link columns.
  For editing an existing query use update-redash; for speeding one up use
  optimize-redash. Uses the mcp__redash__* tools.
---

# Create Redash query (Codingal, Python style)

Rocktim's Redash queries are **Python (Django ORM)** queries on **`data_source_id: 1`**.
The Redash Python runner already runs inside a configured Django context — **never**
add `import django` / `django.setup()` / `os.environ` / settings bootstrap.

Output is emitted by **printing tab-separated rows**: one header line, then one
line per record. There is no `result`/`add_result_row` API in this codebase.

## Tools

Load with one ToolSearch call, then use directly:
`select:mcp__redash__create_query,mcp__redash__update_query_parameters,mcp__redash__execute_adhoc_query,mcp__redash__execute_query`

- **Create**: `create_query` (set `data_source_id: 1`, `query`, `name`; add `options.parameters` if parameterized).
- **Test before saving** when possible: `execute_adhoc_query` (ds 1).

## The skeleton

```python
# 1. Imports — model(s) first, then helpers. NO django bootstrap.
from billing.models import PaymentPage
from common.constants import IST, DT_FORMAT_10
from datetime import datetime, timedelta
from collections import defaultdict

# 2. Params — string placeholders, sentinel-guarded (see Params below)
some_filter = "{{Some Param}}"
DT_FORMAT = "%Y-%m-%d"
start = IST.localize(datetime.strptime("{{date.start}}", DT_FORMAT))
end = IST.localize(datetime.strptime("{{date.end}}", DT_FORMAT)) + timedelta(days=1)

# 3. Build kwargs conditionally
kwargs = {"created_at__range": [start, end]}
if some_filter != "-":
    kwargs["some_field"] = some_filter

# 4. Header row — field count MUST match every data row below
print("\t".join(["Student ID", "Name", "Amount (USD)", "Created At (IST)"]))

# 5. Query: select_related + filter(**kwargs) + order_by("-created_at")
rows = PaymentPage.objects.select_related("customer__student").filter(**kwargs).order_by("-created_at")

# 6. Emit one tab-joined row per record; str()/"N/A" everything; IST.normalize dates
for p in rows:
    student = p.customer.student
    usd = round(float(p.amount * p.usd_exchange_rate), 2) if p.usd_exchange_rate else "N/A"
    print("\t".join([
        student._id,                                   # prefer ._id over f"s{id}"
        p.customer.name,
        str(usd),
        IST.normalize(p.created_at).strftime(DT_FORMAT_10),
    ]))
```

## Hard rules (must follow)

- **Output**: always `print("\t".join([...]))`. Header printed once, then one row per record. Header column count == every row's field count.
- **Stringify everything**: wrap non-strings in `str(...)`, or use `print("\t".join(map(str, row)))`. Missing values → literal `"N/A"` (or `"-"`).
- **IDs**: use `student._id` / `teacher._id` (NOT `.id`, NOT `f"s{id}"`).
- **Grade**: emit bare `student.grade` — it already includes "Grade", don't prefix.
- **Dates**: `IST.normalize(dt).strftime(DT_FORMAT_N)` using a named constant from `common.constants`. The `IST.normalize(...)` wrapper is mandatory.
- **No Django bootstrap lines.** Start the file with model imports.
- **Sanitize free text** before joining so it can't break columns: `re.sub(r'[\n\t\r]', ' ', text)`.
- **Use `select_related`/`prefetch_related`** for any relation you touch in the loop — don't ship an N+1.

## Params

Redash injects params as string placeholders `"{{ Param Name }}"`. Assign to a
variable, then guard:

- **text**: default `"-"`; skip the filter when value is `"-"`.
- **enum**: sentinel `"-"` / `"All"` / `"Both"`; `"Yes"`/`"No"` → bool (`True if x == "Yes" else False`). `enumOptions` is newline-delimited.
- **date** (single) / **date-range** (`{{ Name.start }}` + `{{ Name.end }}`): parse with `"%Y-%m-%d"`, IST-localize, add `timedelta(days=1)` to the end.
- **multi-value enum**: read as `"{{course}}".split(",")`.

`options.parameters` entry shape (pass to `create_query`):

```json
{"name": "Subject", "title": "Subject", "type": "enum", "value": "-",
 "enumOptions": "-\ncoding\nmath\nela", "global": false, "locals": []}
```
date-range default `value` is often `"d_this_month"` / `"d_last_month"`.

## Common idioms

- **Conditional kwargs**: build a `kwargs = {}` dict, add keys only when a param != sentinel, then `.filter(**kwargs)`.
- **Rollups**: aggregate into `defaultdict(lambda: {...})` while iterating, then print the map. Or ORM `.values(...).annotate(total=Sum(...))` with `Sum/Max/Min/F` from `django.db.models`.
- **OR filters**: `Q(...) | Q(...)`. Enum status filters: `end_reason__in=ClassEndReason.successful_reasons()`, `is_cancelled=False`.
- **Skip rows**: `continue` inside the loop to filter (expired, dummy phone, etc.).

## Formatting conventions

- **Currency**: `f"{p.currency} {float(p.amount)}"`; USD via `round(float(p.amount * p.usd_exchange_rate), 2)`.
- **Phone**: `user.phone.as_e164`. **Country**: `user.country.name`.
- **HTML link columns** (Redash renders HTML), usually wrapped in `<small>`:
  ```python
  f'<small><a href="{p.url}" target="_blank">{p.uuid}</a></small>'
  f'<small><a href="{user.auto_login_url()}" target="_blank">{user.name}</a></small>'
  ```
  Admin link: `f"https://www.codingal.com/api/admin/billing/paymentpage/{id}/change/"`.
- **Column headers**: human-readable Title Case, unit/subject in parens — `"Total Paid Amount (USD)"`, `"Created At (IST)"`.
- **Naming**: query names are friendly, often emoji-prefixed (👑 VIPs, 💳 Custom Credits Log).

## Frequently used imports

```python
from common.constants import IST, DT_FORMAT_10      # + DT_FORMAT_2/5/7/8/9/13/14/15
from billing.models import PaymentPage, CourseEnrolment, RefundLog, Payment
from billing.enums import PaymentGateway, BusinessEntity, PaymentOptionType, SalesTeams
from human.models import Student
from human.utils import get_all_paid_students, get_all_active_paid_students
from batch.models import Classroom, ClassroomStudentAttendance, BatchStudent, Batch
from batch.enums import ClassEndReason, ClassroomEventLogActions
from curriculum.enums import Subject
from django.db.models import Q, Sum, Max, Min, F
from common.utils import is_dummy_phone, get_float_or_none, get_country_info_from_code
from datetime import datetime, timedelta
from collections import defaultdict
```

Always read the actual model/helper signature in the repo (`api/apps/<domain>/`) before relying on a field or method — don't assume.

## Workflow

1. Clarify the report goal, the primary model, columns, and any filters/params.
2. Confirm field/method names against the repo (`api/apps/<domain>/models.py`, enums, utils).
3. Write the Python following the skeleton + hard rules.
4. Test with `execute_adhoc_query` (ds 1) if feasible.
5. `create_query` (set `data_source_id: 1`); wire `options.parameters` for any params.
6. Report the query id/URL back: `https://redash.codingal.com/queries/<id>`.
