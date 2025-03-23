#!/bin/bash

# Get the branch name
BRANCH=$(git symbolic-ref --short HEAD)

# Add all changes
git add .

# Commit with timestamp
git commit -m "Auto commit at $(date)"

# Push to remote
git push origin $BRANCH

echo "Pushed changes to $BRANCH"

# Try to use full path to gh if it exists
GH_PATH=$(which gh 2>/dev/null)

if [ -x "$GH_PATH" ]; then
    echo "Using GitHub CLI at $GH_PATH"
    
    # Find and close any existing PRs from this branch
    EXISTING_PR=$("$GH_PATH" pr list --head "$BRANCH" --json number --jq '.[0].number' 2>/dev/null)
    
    if [ ! -z "$EXISTING_PR" ]; then
        echo "Closing existing PR #$EXISTING_PR"
        "$GH_PATH" pr close $EXISTING_PR --delete-branch=false
    fi
    
    # Create a new PR to main
    echo "Creating new PR from $BRANCH to main"
    "$GH_PATH" pr create --base main --head "$BRANCH" --title "Updated PR from $BRANCH" --body "This PR replaces any previous PR and contains the latest changes."
else
    echo "GitHub CLI not available or not in PATH. Changes have been pushed to branch: $BRANCH"
    echo "Please manage pull requests manually through the GitHub web interface."
fi