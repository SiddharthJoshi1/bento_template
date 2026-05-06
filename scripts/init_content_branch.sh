#!/usr/bin/env bash
# init_content_branch.sh
# Creates the content branch used for live portfolio updates.
#
# What this script does:
#   1. Reads assets/data/content.json directly from your main branch (no temp files)
#   2. Creates an orphan branch called `content` — a branch with no shared history
#   3. Wipes the working tree so the branch contains only what the app needs to fetch
#   4. Reconstructs the required folder path and drops content.json into it
#   5. Makes the initial commit and pushes to origin
#   6. Returns you to main
#
# Run from the root of your repo:
#   bash scripts/init_content_branch.sh

set -e

BRANCH="content"
CONTENT_PATH="assets/data/content.json"

echo "→ Checking you're on main..."
CURRENT=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT" != "main" ]; then
  echo "Error: run this script from the main branch (currently on '$CURRENT')"
  exit 1
fi

echo "→ Checking if content branch already exists on origin..."
if git ls-remote --exit-code --heads origin content > /dev/null 2>&1; then
  echo "Error: origin/content already exists. Nothing to do."
  echo "To update content, edit assets/data/content.json and push to the content branch directly."
  exit 1
fi

echo "→ Reading $CONTENT_PATH from main..."
# Pull the file content directly from git's object store — no temp files, no manual copying
CONTENT=$(git show main:"$CONTENT_PATH")

echo "→ Creating orphan branch '$BRANCH'..."
git checkout --orphan "$BRANCH"

echo "→ Clearing working tree..."
git rm -rf . --quiet

echo "→ Restoring $CONTENT_PATH..."
mkdir -p "$(dirname "$CONTENT_PATH")"
echo "$CONTENT" > "$CONTENT_PATH"

echo "→ Committing..."
git add "$CONTENT_PATH"
git commit -m "init: content branch"

echo "→ Pushing to origin..."
git push origin "$BRANCH"

echo "→ Returning to main..."
git checkout main

echo ""
echo "Done. Your content branch is live."
echo "Set CONTENT_BASE_URL to: https://raw.githubusercontent.com/<your-username>/<your-repo>/content/"
