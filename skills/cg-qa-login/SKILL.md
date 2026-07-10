---
name: cg-qa-login
description: Authenticate a headless browse session for QA of Codingal blackops admin pages (onboarding board, etc.). Use before QA-ing any /blackops/ or onboarding page that returns "You must be logged in to access onboarding features". Prompts for credentials at runtime - none are stored.
---

# cg-qa-login (Codingal blackops QA login)

No credentials are stored in this file. When fired, **prompt the user for the
username and password** (use AskUserQuestion, or ask in plain text), then run the
login flow below with what they provide.

## When to use

Before driving any `/blackops/...` admin page (e.g. the onboarding "Manage Group"
board) with the `/browse` skill. Symptom that you need this: navigating to the
page redirects to `/blackops/` with the flash **"You must be logged in to access
onboarding features."** The blackops session needs a real Django user with
onboarding access.

## Step 1: get credentials from the user

Ask the user for:
- blackops username
- blackops password
- (if not already known) the preview/dev host under test, e.g.
  `https://<hex>.codingal.com`

Dev/preview envs only. Never use against production.

## Step 2: log in (Django admin form sets the shared session cookie)

The frontend `/login/` is phone/OTP and does NOT accept these creds. Use the
Django admin login instead - it sets the session cookie that blackops shares.
Substitute `$USERNAME` / `$PASSWORD` with what the user gave you.

```bash
B="$HOME/.claude/skills/gstack/browse/dist/browse"
HOST="https://<preview-host>.codingal.com"   # the env under test

$B goto "$HOST/api/admin/login/?next=/api/admin/" >/dev/null
$B fill "#id_username" "$USERNAME" >/dev/null
$B fill "#id_password" "$PASSWORD" >/dev/null
$B click "input[type=submit]" >/dev/null
# verify: url is now /api/admin/ and page text contains "Welcome, <username>."
$B url
```

Then navigate to the page under test, e.g. the onboarding groups board:

```bash
$B goto "$HOST/blackops/onboarding/groups/" >/dev/null
$B url   # should stay on /blackops/onboarding/groups/, not redirect to /blackops/
```

## Gotchas

- The Django Debug Toolbar is injected on these pages and floods `snapshot -i`.
  To find real form fields, query the DOM directly and skip `#djDebug`, e.g.
  `$B js "JSON.stringify(Array.from(document.querySelectorAll('input')).map(e=>({name:e.name,id:e.id})))"`.
- The admin login path is `/api/admin/login/` (note the `/api` prefix), not
  `/admin/login/` or `/blackops/login/` - those render empty / no form.
- Session persists across browse commands (cookies kept), so log in once per
  browse daemon lifetime.
- Clean up any test data you create (delete test groups via `deleteGroup(id)`
  after `dialog-accept`).
