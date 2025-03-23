#!/bin/bash

# Get the branch name
BRANCH=$(git symbolic-ref --short HEAD)

# Add all changes
git add .

# Commit with timestamp
git commit -m "Auto commit at $(date)"

# Push to remote
git push origin $BRANCH

echo "Checking for GitHub CLI availability..."
if command -v gh &> /dev/null; then
    echo "GitHub CLI found. Using it to manage PRs."
    
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
    echo "GitHub CLI not found. You'll need to manage PRs manually:"
    echo "1. Go to your repository on GitHub.com"
    echo "2. If there's an existing PR for branch '$BRANCH', close it"
    echo "3. Create a new PR from '$BRANCH' to 'main'"
    echo ""
    echo "To install GitHub CLI for future automation:"
    echo "- On Ubuntu/Debian: sudo apt install gh"
    echo "- On macOS: brew install gh"
    echo "- On Windows: winget install GitHub.cli"
    echo "Then authenticate with: gh auth login"
fi