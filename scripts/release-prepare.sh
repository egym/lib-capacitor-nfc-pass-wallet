#!/usr/bin/env bash

set -euo pipefail

BRANCH_NAME="chore/release-package"
COMMIT_MESSAGE="chore: version package"
PR_TITLE="chore: release package"
PR_BODY="Release PR generated from merged changesets on main."

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Working tree is not clean. Commit or stash your changes before preparing a release."
  exit 1
fi

git fetch origin main
git switch -C "$BRANCH_NAME" origin/main

has_pending_changesets="$(node --input-type=module <<'NODE'
import { readPreState } from "@changesets/pre";
import { readChangesets } from "@changesets/read";

const cwd = process.cwd();
const changesets = await readChangesets(cwd);
const preState = await readPreState(cwd);
console.log(changesets.length > 0 || preState?.mode === "exit");
NODE
)"

if [[ "$has_pending_changesets" == "false" ]]; then
  echo "No pending changesets to version."
  exit 0
fi

npm exec changeset version
npm install --package-lock-only --ignore-scripts
npm run verify:lockfile

if git diff --quiet; then
  echo "No pending changesets to version."
  exit 0
fi

git add -A
git commit -m "$COMMIT_MESSAGE"
git push --force-with-lease --set-upstream origin "$BRANCH_NAME"

if ! command -v gh >/dev/null 2>&1; then
  echo "Release branch pushed to origin/$BRANCH_NAME."
  echo "Open a PR manually or run:"
  echo "gh pr create --base main --head $BRANCH_NAME --title \"$PR_TITLE\" --body \"$PR_BODY\""
  exit 0
fi

existing_pr_url="$(gh pr list --head "$BRANCH_NAME" --base main --state open --json url --jq '.[0].url')"

if [[ -n "$existing_pr_url" && "$existing_pr_url" != "null" ]]; then
  echo "Release PR already exists: $existing_pr_url"
  exit 0
fi

gh pr create \
  --base main \
  --head "$BRANCH_NAME" \
  --title "$PR_TITLE" \
  --body "$PR_BODY"