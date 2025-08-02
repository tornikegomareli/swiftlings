#!/bin/bash

# Documentation:
# This script creates a new release by tagging the current commit
# and pushing it to trigger the GitHub Actions release workflow.
#
# Usage:
# ./release.sh <version>
# e.g. ./release.sh 0.1.0
# e.g. ./release.sh v0.1.0

set -e

# Check if version argument is provided
if [ $# -eq 0 ]; then
    echo "Error: Version number required"
    echo "Usage: $0 <version>"
    echo "Example: $0 0.1.0"
    exit 1
fi

VERSION=$1

# Remove 'v' prefix if present for validation
VERSION_CHECK=$(echo "$VERSION" | sed 's/^v//')

# Validate semantic version format
if ! [[ "$VERSION_CHECK" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Invalid version format. Please use semantic versioning (e.g., 0.1.0)"
    exit 1
fi

# Ensure version starts with 'v' for consistency
if [[ ! "$VERSION" =~ ^v ]]; then
    VERSION="v$VERSION"
fi

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Check if there are uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "Error: You have uncommitted changes. Please commit or stash them first."
    exit 1
fi

# Fetch latest tags
echo "Fetching latest tags..."
git fetch --tags

# Check if tag already exists
if git rev-parse "$VERSION" >/dev/null 2>&1; then
    echo "Error: Tag $VERSION already exists"
    exit 1
fi

# Update version in Swiftlings.swift
echo "Updating version in code..."
VERSION_WITHOUT_V=$(echo "$VERSION" | sed 's/^v//')
sed -i '' "s/version: \"[^\"]*\"/version: \"$VERSION_WITHOUT_V\"/" Sources/Swiftlings/Swiftlings.swift

# Check if version was updated
if git diff --quiet Sources/Swiftlings/Swiftlings.swift; then
    echo "Version in code is already up to date"
else
    # Commit version change
    git add Sources/Swiftlings/Swiftlings.swift
    git commit -m "chore: bump version to $VERSION"
    echo "Committed version change"
fi

# Create annotated tag
echo "Creating tag $VERSION..."
git tag -a "$VERSION" -m "Release $VERSION"

# Push commits and tag
echo "Pushing to remote..."
git push
git push origin "$VERSION"

echo ""
echo "✅ Release $VERSION created successfully!"
echo ""
echo "The GitHub Actions workflow will automatically:"
echo "  - Build the release binary"
echo "  - Create a GitHub release with the binary"
echo "  - Generate release notes from commits"
echo ""
echo "Check the Actions tab on GitHub to monitor the release progress."