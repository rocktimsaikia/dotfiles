---
name: sync-with-master
description: Update master branch from remote and merge it into the current branch
---

# Sync with Master

Use this skill when the user wants to bring in the latest changes from master into their current feature branch.

## Workflow

1. Get the current branch name
2. Fetch the latest master from remote
3. Checkout master locally
4. Fast-forward master to match origin/master
5. Return to the original branch
6. Merge master into the current branch
7. Push changes to remote
8. Report success or any merge conflicts

## Usage

Run `/sync-with-master` or use the alias `sm` from the command line.

## What It Does

- Fetches latest changes from origin/master
- Merges master into your current branch
- Prevents accidental runs on master/main branches
- Handles merge conflicts if they occur
