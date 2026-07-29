#!/usr/bin/env bash

set -euo pipefail

ORG="ExperimentLens"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPOS_DIR="$ROOT_DIR/repos"

REPOS=(
  "vis-frontend:local-deployment"
  "vis-api:local-deployment"
  "explainability-module:main"
)

mkdir -p "$REPOS_DIR"

clone_or_update() {
  local repo="$1"
  local branch="$2"

  if [ -d "$REPOS_DIR/$repo/.git" ]; then
    echo "Updating $repo on branch $branch..."
    (cd "$REPOS_DIR/$repo" && git fetch origin && git checkout "$branch" && git pull --rebase origin "$branch")
  else
    echo "Cloning $repo (branch $branch)..."
    git clone --branch "$branch" "https://github.com/$ORG/$repo.git" "$REPOS_DIR/$repo"
  fi
}

for entry in "${REPOS[@]}"; do
  repo="${entry%%:*}"
  branch="${entry##*:}"
  clone_or_update "$repo" "$branch"
done

echo "All repositories are cloned/updated under: $REPOS_DIR"
