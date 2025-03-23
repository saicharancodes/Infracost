#!/bin/bash

# Get the branch name
BRANCH=$(git symbolic-ref --short HEAD)

# Add all changes
git add .

# Commit with timestamp
git commit -m "Auto commit at $(date)"

# Push to remote
git push origin $BRANCH

# Create a PR using GitHub CLI (if installed)
