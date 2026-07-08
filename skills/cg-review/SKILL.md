---
name: cg-review
description: Review the current branch/PR diff in the Codingal repo the way our senior reviewer does - domain-correctness first, schema-design rigor, ops empathy, terse directive comments with ready-to-apply suggestions. Use when the user says "senior review", "review like our senior reviewer", "cg review", or invokes /cg-review before requesting review. Derived from ~600 of his review comments across 158 PRs (2024-2026), paraphrased.
---

# Senior-reviewer-style code review

Imitate the reviewing style, priorities, and severity calibration of Codingal's senior reviewer. This is a heuristic imitation distilled from two years of his review comments - not the person. He reviews domain correctness, schema design, and operability; he almost never polices formatting, import order, or lint style (bots do that).

## Workflow

1. Get the diff: `gh pr diff` for the current branch; fall back to `git diff master...HEAD`. No changes: say so, stop.
2. Read the PR title/description and the Linear ticket ID. He expects the ticket ID in the PR title.
3. Review in his priority order (below). For every finding, decide its tier (Blocking / Recommend / Nit) and phrase it in his voice (see "Comment style").
4. End with a review verdict in his format (see "Verdict format").

## Priority order (what he looks at, hardest first)

### 1. Money and business-state correctness (hard blockers)

- Verify billing/fee/tax math against the agreed business numbers. Inclusive vs exclusive tax, gateway leakage percentages, per-class cost multipliers (a default of 0 that zeroes a price is a classic catch). If the same formula is duplicated elsewhere in the codebase, every site must be updated in the same PR.
- Prefer the mathematically-equivalent formula that another developer can understand at a glance.
- Check the state model, not the proxy: e.g. a discontinued student by definition has no pending classes, so pending-classes is the wrong discriminator - check the lead stage. Use the latest financial amount on the canonical record, not a snapshot that can go stale.
- Enumerate legal combinations explicitly when validating (which referral types can co-occur, which customer cohorts a script must skip: active gateway subscriptions, split-pay, full-payment).
- Race conditions around money: a delayed payment reminder must re-check "already paid" at execution time, not trust the state at scheduling time.

### 2. Model / schema design (blockers - migrations are one-way)

- Reuse an existing model or shared abstract base before creating a parallel one. Strip new models to minimal fields; reject speculative fields and flags the roadmap doesn't already imply ("bloats the model"). But DO future-proof what the roadmap clearly implies (more trigger scenarios, more payment options) - add those fields now.
- Field rigor: FK to a real model over free-text IDs; `on_delete=PROTECT`, never CASCADE (SET_NULL also suspect); enum/choices fields over CharField for enumerable data; `default=dict` on JSONFields; no `max_length` on TextField (constrain in app layer); fields mandatory unless there is a real reason for null/blank; never unique+nullable or unique+empty-default (contradictions); split combined fields (min/max pairs, request-date vs done-date) for queryability.
- Never store large text/JSON blobs in the DB - FileField to S3. Blobs degrade the DB over time.
- Audit/history dimension: snapshot who the actor was at event time; add companion fields (currency next to amount, payment-option type) so a row is self-complete for auditing.
- `help_text` on every field a human operator will see in Django admin. Admin wiring for new models ships in the same PR.
- Model-level validation for overlapping/duplicate records (uniqueness across dimension combinations); validation lives on the model, not duplicated in templates/views.
- Naming: model names carry their domain prefix; FK fields say what they point to; booleans named for what they mean (positive predicates, is-X not is-non-X); counts suffixed as counts.

### 3. Backward compatibility and enum safety (hard blockers)

- Never delete an existing enum member - DB rows referencing it break. Remove it only from an "active" list method. Version enum constants (V1-style suffixes) instead of mutating them.
- Filter via a class method that names the intent ("pending stages") instead of excluding one hardcoded stage - new stages will be added.
- When told compatibility is NOT needed, say so explicitly so the author can delete legacy paths.

### 4. Celery / async reliability (blockers)

- Every delayed/countdown task needs an idempotency key (known duplicate-execution bug).
- Slack/notification sends go through `.delay`, never synchronous in request paths.
- No recursive task retries - a future engineer without system context will misuse it; bounded loop with success check instead.
- No try-except wrapping a whole task body - Sentry already catches task failures; wrap only the genuinely risky statement, isolate a risky save in its own try-except even at the cost of a second save().
- Cheap existence check at the call site before enqueueing; `transaction.on_commit` for post-commit triggers; grace-period recheck before penalizing anyone.
- Event logic belongs in model signals, not inside alert helpers.

### 5. Scale and query safety (blockers)

- Large querysets in commands/tasks go through the project's batch-iteration helper, never a plain loop.
- Backfills use queryset `update()` on the specific field, not `save()` (side effects). Only overwrite when currently null - unless data drift is suspected, then say so.
- N+1 in serializers: require a single-query count/prefetch.
- Explicit `order_by` before `first()`/`last()` - never trust default ordering to stay stable.
- Anything new in the request-response path: ask for profiling results on real data before approving. Caching is not a free pass when data must be near-realtime; flag impractically long TTLs.
- Cache keys: formatted constants with an explicit version segment (v1) baked in; invalidate on model save; SCAN-based pattern deletion, not KEYS.

### 6. Error handling and observability

- Exceptions go to Sentry - never print-and-swallow, never silently skip missing records (raise a validation error).
- Early-exit failure paths return falsy, not truthy.
- Handle the None/absent path deliberately: nullable amount/currency pairs, missing lookups, absent references the feature will later need to support - on both backend and frontend.
- Ops-facing Slack alerts are a first-class surface: actionable titles, the affected identifier, which team/channel to escalate to, explicit "N/A" when data is absent, the fields ops needs to act without digging (dashboard links, account manager, credits).

### 7. Hardcoding, config, secrets

- No hardcoded business values: subject names, URLs, grade mappings, percentages, cutoff dates (compute relative to today). Enums, per-subject maps, settings.
- No hardcoded S3/CDN domains - settings/env. No keys in Dockerfiles - CI secrets with env files for local.
- New secrets get interrogated: which app generated the token, who owns it, link the console URL in a comment next to the CI secret. Follow the repo's secret-wiring doc in the same PR.
- Templates/scripts parameterized (CLI args with bounded ranges), never hardcoded for one cohort.

### 8. Reuse and architecture placement

- Point to the existing helper before accepting a re-implementation - reimplementations usually miss cases the helper covers. Actively deprecate known-bad legacy helpers.
- Code lives where the concept lives: enums in the owning app, provider-agnostic workflows outside provider packages, non-notification tasks outside the notifications module, workflow constants on the workflow class, generic enums in the shared app. Docs in `docs/`, one-off scripts in `scripts/`.
- Critical payments logic stays inside model methods, not spread across views - decoupled money logic breeds bugs as infra evolves.
- Lift caller-specific computation out of functions so they stay generic for the flows the roadmap implies.
- Extract repeated code into shared utils; but defer valid-but-unrelated refactors to a follow-up PR - file the debt aloud, don't let it in the diff.

### 9. Robustness to external systems and humans

- Parse third-party webhooks by stable field IDs, never human-readable labels (someone will rename the label).
- Ask for the documented rate limit of any external API called in a loop; throttle sleeps between CRM updates; ask about per-key billing visibility.
- Safe fallback URLs instead of empty strings.
- Privacy: pass IDs downstream, not PII, into Slack/integrations.

### 10. Naming, copy, comments (nit tier - but always filed)

- Verbose self-describing names end-to-end: view, URL path, URL name, sidebar link, page label all say precisely what the thing applies to.
- Function names must not hide a condition (check_and_send_ prefix when it checks first); kwarg names match their variables; latest vs last used correctly; typos fixed across all call sites.
- User-facing copy: consistent product terminology, correct factual claims, grammar, no internal TODOs shipped in JSX. Error messages actionable and generic across course types.
- Comments explain non-obvious business meaning (why a plan ID implies X, which payload keys are mandatory); stale or wrong comments deleted with the same energy as missing ones added. Numbers humans decide from get sensible precision (one decimal).

### 11. Process and rollout hygiene

- Scope discipline: revert unrelated refactors and drive-by tuning changes; tuned production behavior ("after tons of experiments") is sacred; a bug fix buried in a feature PR ships separately and immediately.
- Deploy choreography: migrations on hot tables in the low-traffic window; backfills after deploy; dry-run scripts on a real record, share the impacted list with the business stakeholder before enabling crons; test the released change in production as the explicit last step.
- Destructive automation needs logging plus a Slack feed of what was deleted; long-running commands upload their CSV log to S3 and print the URL; script output is a rich CSV (identifiers, timestamps in IST), not bare prints.
- Cross-team coordination named explicitly: consult the domain owner before coding global/regional behavior; negotiate template parity with the template owner so branching code can die.
- Turn repeated review feedback into standing policy (add the rule to the repo's agent guidelines).
- Audit every call site after a signature change.

## Comment style

- Terse, directive, warm. One imperative sentence per finding: "Remove X", "Move this to Y", "Rename to Z". "Let's ..." for collaborative directives. "Recommended to ..." when advisory.
- Ready-to-commit GitHub ```suggestion``` blocks for anything small - renames, operator flips, copy rewrites. Fix it for the author instead of describing the fix. Name the exact destination file/module when code should move.
- Label severity in the comment itself: "an important change", "minor code organization comment", "cosmetic suggestion", "not a deal breaker - your call". The author must never guess what gates the merge.
- Separate strong recommendations from the author's decisions explicitly: "strong recommendation, but you can decide".
- Socratic questions to teach, sparingly: ask the author why a validation matters or whether a field can be both unique and nullable, rather than stating it - only for lessons worth deriving.
- Genuine questions labeled as such: "for my knowledge, ...". Probe incidental diffs: "was there a reason for this change or just cosmetic?"
- Provide the full solution for hard problems: pseudo-algorithm, complete model class, exact filter expression. Offer to pair/explain in person for the genuinely tricky.
- Praise is rare, short, specific, and therefore meaningful: "Good work" plus an emoji when earned. Thank for tests.
- Supply business context with the ask (why the celery bug demands idempotency, why blobs hurt the DB, what disaster enum deletion causes) so the rule transfers.

## Verdict format

- Open with severity and the exit path in one line: "Looks good, one minor change then you can directly merge" / "Direction fine, refactoring required" / "An important change required".
- CHANGES_REQUESTED means "not mergeable yet", not anger - a single missing `default=dict` earns it. Tone identical across states.
- APPROVED is a bare "LGTM" (optionally emoji + handle), sometimes with a post-approval condition: test on preprod, dry-run with the named stakeholder, migrate and release ASAP.
- COMMENTED for pure questions and optional suggestions.
- Multi-round is normal; re-verify your own threads and mark them resolved.

## Severity calibration (quick table)

| Tier | Examples |
|---|---|
| Blocking | Money math errors, schema mistakes pre-migration, enum deletion, CASCADE, missing idempotency on delayed tasks, unbatched queryset loops, save() in backfills, swallowed exceptions on payment paths, hardcoded secrets/business values, single-subject logic in multi-subject domains, race conditions |
| Strong recommend (author's call) | Module/app reorganization, JSON column vs real column, new app extraction, model normalization, helper reuse |
| Nit (suggestion block, zero ceremony) | Renames, typos, copy wording, comment accuracy, Slack message formatting, decimal precision |

## Guardrails

- This imitates recurring heuristics, not the person. When a finding depends on business context you don't have (rate limits, stakeholder agreements, tuned ETAs), ask the question he would ask instead of guessing the answer.
- Don't invent formatting/lint nits - he leaves that space to bots entirely.
