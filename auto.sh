#!/bin/bash

# Get the branch name
BRANCH=$(git symbolic-ref --short HEAD)

# Add all changes
git add .

# Commit with timestamp
git commit -m "Auto commit at $(date)"

# Push to remote
git push origin $BRANCH

# Check if GitHub CLI is installed
if command -v gh &> /dev/null; then
    # Find and close any existing PRs from this branch
    EXISTING_PR=$(gh pr list --head "$BRANCH" --json number --jq '.[0].number')
    
    if [ ! -z "$EXISTING_PR" ]; then
        echo "Closing existing PR #$EXISTING_PR"
        gh pr close $EXISTING_PR --delete-branch=false
    fi
    
    # Create a new PR to main
    echo "Creating new PR from $BRANCH to main"
    gh pr create --base main --head "$BRANCH" --title "Updated PR from $BRANCH" --body "This PR replaces any previous PR and contains the latest changes."
else
    echo "GitHub CLI not found. Install it to automate PR management: https://cli.github.com/"
fi