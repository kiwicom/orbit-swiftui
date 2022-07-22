#!/usr/bin/env bash
set -euo pipefail

PR_LABEL=$1

PR_COUNT=$(gh pr list --json id --label "$PR_LABEL" --jq length -s open)

if [[ $PR_COUNT -ne 0 ]]; then
  echo "Design Tokens Icons Update pull-request is already created."
  exit 1
fi

git config --local user.email "mobile.automation@kiwi.com"
git config --local user.name "Mobile Automation"

./Automation/update_icons.py Sources/Orbit/Foundation/Icons
git add --all || true
git commit -m "tokens: update icons on $TODAY" || true
