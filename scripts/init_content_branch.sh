#!/usr/bin/env bash
# init_content_branch.sh
# Creates the content branch used for live portfolio updates.
#
# What this script does:
#   1. Reads a content.json from your local working tree (defaults to assets/data/content.json)
#   2. Creates an orphan branch called `content` — a branch with no shared history
#   3. Wipes the working tree so the branch contains only what the app needs to fetch
#   4. Reconstructs the required folder path and drops content.json into it
#   5. Makes the initial commit and pushes to origin
#   6. Returns you to main
#
# Run from the root of your repo:
#   bash scripts/init_content_branch.sh
#
# To bootstrap from one of the starter configs in examples/:
#   bash scripts/init_content_branch.sh examples/developer.json
#   bash scripts/init_content_branch.sh examples/designer.json
#   bash scripts/init_content_branch.sh examples/minimal.json

set -e

BRANCH="content"
CONTENT_PATH="assets/data/content.json"
SOURCE_FILE="${1:-$CONTENT_PATH}"

echo "→ Checking you're on main..."
CURRENT=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT" != "main" ]; then
  echo "Error: run this script from the main branch (currently on '$CURRENT')"
  exit 1
fi

if [ ! -f "$SOURCE_FILE" ]; then
  echo "Error: source file not found: $SOURCE_FILE"
  exit 1
fi

echo "→ Checking if content branch already exists on origin..."
if git ls-remote --exit-code --heads origin content > /dev/null 2>&1; then
  echo "Error: origin/content already exists. Nothing to do."
  echo "To update content, edit assets/data/content.json and push to the content branch directly."
  exit 1
fi

if [ "$SOURCE_FILE" != "$CONTENT_PATH" ]; then
  echo "→ Using $SOURCE_FILE as content source..."
else
  echo "→ Using $CONTENT_PATH as content source..."
fi
CONTENT=$(cat "$SOURCE_FILE")

echo "→ Creating orphan branch '$BRANCH'..."
git checkout --orphan "$BRANCH"

echo "→ Clearing working tree..."
git rm -rf . --quiet
git clean -fdx --quiet

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
