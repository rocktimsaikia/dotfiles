#!/bin/bash

# Self-check for bin/git-safe-restore. Run: bash tests/git-safe-restore.test.sh

set -eu

GSR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../bin" && pwd)/git-safe-restore"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

ok() { echo "  ok  $1"; }
fail() {
  echo "  FAIL  $1"
  exit 1
}
refcount() { git for-each-ref --format='%(refname)' refs/safe-restore | wc -l; }

cd "$TMP"
git init -q .
git config user.email t@t.t
git config user.name t
echo one >f
git add f
git commit -qm init

# 1. discard a tracked change -> file back to HEAD, snapshot ref created
echo two >>f
"$GSR" f >/dev/null
[ "$(cat f)" = "one" ] || fail "restore did not discard the change"
[ "$(refcount)" -eq 1 ] || fail "no snapshot ref created"
ok "discards change and snapshots it"

# 2. undo -> change is back
"$GSR" --undo >/dev/null
[ "$(cat f)" = "$(printf 'one\ntwo')" ] || fail "undo did not bring the change back"
ok "undo restores the discarded change"

# 3. clean worktree -> no new snapshot ref
git checkout -q -- f
"$GSR" f >/dev/null
[ "$(refcount)" -eq 1 ] || fail "snapshot created for a clean worktree"
ok "no snapshot when nothing to save"

# 4. prune drops old refs and keeps fresh ones
git update-ref refs/safe-restore/1-deadbee "$(git rev-parse HEAD)"
"$GSR" --prune 30
if git rev-parse --verify -q refs/safe-restore/1-deadbee >/dev/null; then fail "stale ref survived prune"; fi
[ "$(refcount)" -eq 1 ] || fail "prune ate a fresh ref"
ok "prune drops stale refs only"

# 5. undo with an empty namespace exits non-zero
git for-each-ref --format='%(refname)' refs/safe-restore |
  while read -r r; do git update-ref -d "$r"; done
if "$GSR" --undo >/dev/null 2>&1; then fail "--undo succeeded with no snapshots"; fi
ok "undo fails cleanly when there is nothing to undo"

# 6. the user's own stash stack is never touched
[ -z "$(git stash list)" ] || fail "git stash list was polluted"
ok "git stash list untouched"

echo OK
