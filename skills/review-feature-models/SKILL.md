---
name: review-feature-models
description: Review newly created or modified models for the current feature or PR when the user asks whether the model design is correct, complete, production-ready, or "near perfect" for the feature. Focus on schema quality, lifecycle behavior, and how the models are actually used by serializers, views, admin, and tests.
---

# Review Feature Models

Use this skill when the user wants a review of models introduced or changed for a feature, especially when they ask:

- are these models correct for this feature?
- is the model design production ready?
- is it near perfect?
- verify the created models

## Goal

Evaluate the model layer in context and answer two questions:

1. What concrete model/schema issues, gaps, or risks exist?
2. Is the design good enough for the feature as implemented right now?

## Workflow

1. Identify the relevant model files.
   Use the current branch diff when possible.
   Prioritize files under `api/apps/*/models.py`, serializers, views, admin, and tests.
   Include migrations only when the user explicitly asks to review the migration itself.

2. Review the models in context, not in isolation.
   Check:
   - fields, defaults, null/blank usage
   - `on_delete` behavior
   - indexes, ordering, uniqueness, and constraints
   - soft-delete or lifecycle fields such as `is_active`
   - whether fields are actually populated and used by the feature
   - migration shape only when a migration file is already present in the branch context

3. Verify behavior against callers.
   Read the serializers, views, tasks, or services that create, update, query, or delete the models.
   Look for mismatches between intended lifecycle and actual query paths.

4. Assess release quality.
   Distinguish between:
   - `P0` release blockers
   - `P1` correctness or maintainability issues
   - `P2` schema polish or future-proofing concerns

5. Answer directly.
   Give findings first.
   Then give a short verdict on whether the models are close to production-ready.

## Review Rules

- Default to a code review mindset: bugs and risks first.
- Prefer confirmed issues over speculative cleanup.
- Call out dead schema: fields present in models/admin/serializers but not populated or used.
- Do not call out missing migration files by default; migrations are handled manually outside this skill.
- Treat lifecycle mismatches as serious issues, especially when soft-delete exists but write paths bypass it.
- Do not call something "near perfect" if there are schema or behavior issues that can cause user-visible inconsistency.

## Output Format

Use this structure:

### Findings
- [severity]: [issue with file reference and short explanation]

### Verdict
[1-3 sentence answer on whether the model design is production-ready or near perfect]

### Residual Risks
- [optional]

## Notes

- For Django models, pay special attention to `blank`, `null`, `default`, `choices`, indexes, and `on_delete`.
- When a field appears in the model, admin, and serializer but is never written by the feature flow, treat that as a likely design gap rather than harmless completeness.
- Ignore migration creation/absence unless the user explicitly asks to review the migration itself.
