#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "🔄 Fetching and pruning remote references..."
git fetch --prune

echo "🔍 Finding local branches that no longer exist on remote..."
# Get branches marked [gone], extract their names
GONE_BRANCHES=$(git branch -vv | awk '/: gone]/ {print $1}' | sed 's/*//g')

if [ -z "$GONE_BRANCHES" ]; then
    echo "✨ Your local repository is already clean! No gone branches found."
    exit 0
fi

echo "⚠️  The following local branches will be deleted:"
echo "$GONE_BRANCHES"
echo "----------------------------------------"

# Read through the list and delete each branch safely
echo "$GONE_BRANCHES" | while read -r branch; do
    if [ -n "$branch" ]; then
        # -d is safe deletion. Change to -D if you want to force delete unmerged work
        git branch -d "$branch"
    fi
done

echo "🎉 Done! Gone branches cleared successfully."
