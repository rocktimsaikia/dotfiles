---
name: commit
description: Stage current tracked changes, run pre-commit with tests skipped, create a git commit, and push with branch-aware commit message formatting and no AI attribution.
---

# Commit Only

Use this skill when the user asks to commit and push changes.

## Rules

1. Inspect the current repository state with `git status --short`.
2. Stage current tracked changes with `git add -u`.
3. Do not stage untracked files unless the user explicitly asks.
4. Activate the project virtual environment with `source ~/.pyenv/versions/codingal/bin/activate`.
5. Run `SKIP=tests pre-commit` before committing.
6. If pre-commit changes files through formatting/import hooks, stage tracked changes again with `git add -u` and rerun `SKIP=tests pre-commit`.
7. If pre-commit reports a non-formatting failure, fix the issue, stage tracked changes with `git add -u`, and rerun `SKIP=tests pre-commit`.
8. Use `git commit -n -m "<message>"` for the commit.
9. Push after commit with `git push`.
10. Do not add any AI attribution/credits in commit messages.
11. Commit message format:
   - If current branch name is a valid Linear task ID (for example `CE-1234`), prefix the commit message with that branch name.
   - If current branch is `master`, use conventional commit format.
   - If current branch is not `master` and is not a valid Linear task ID, also use conventional commit format.

## Examples

Simple commit:
`docs: correct spelling of CHANGELOG`

With scope:
`feat(lang): add Polish language`

With breaking change:
`feat!: send an email to the customer when a product is shipped`

With scope + breaking change:
`feat(api)!: send an email to the customer when a product is shipped`

With body/footer:
`feat: allow provided config object to extend other configs`

`BREAKING CHANGE: extends key in config file is now used for extending other config files`
