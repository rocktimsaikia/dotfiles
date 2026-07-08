---
name: cg-commit
description: Commit and push changes in the Codingal repo - stage tracked changes, run pre-commit with tests skipped, commit, and push. Conventional commit format, no AI attribution.
---

# cg-commit

Commit and push changes in the Codingal repo.

## Steps

1. Stage tracked changes: `git add -u`. Do not stage untracked files unless asked.
2. Activate the venv: if a local `.venv/` exists, `source .venv/bin/activate`, else `source ~/.pyenv/versions/codingal/bin/activate`.
3. Run `SKIP=tests pre-commit`. If hooks modify files, `git add -u` and rerun until clean.
4. Commit: `git commit -n -m "<message>"`.
5. Push: `git push`.

## Commit message

- Conventional commit format: `type(scope): description`.
- If the branch name is a Linear task ID (e.g. `CE-1234`), prefix the message with it.
- No AI attribution.
