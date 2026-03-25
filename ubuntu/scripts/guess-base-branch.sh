#!/usr/bin/env bash
set -euo pipefail

TARGET_BRANCH="${1:-HEAD}"
CANDIDATES=("develop" "main" "master")

exists_branch() {
  git rev-parse --verify --quiet "$1" >/dev/null
}

resolve_ref() {
  local ref="$1"

  if exists_branch "$ref"; then
    echo "$ref"
    return
  fi

  if exists_branch "origin/$ref"; then
    echo "origin/$ref"
    return
  fi

  return 1
}

best_branch=""
best_ts=0
best_base=""
best_method=""

for candidate in "${CANDIDATES[@]}"; do
  if ! resolved_candidate="$(resolve_ref "$candidate")"; then
    continue
  fi

  # Prefer fork-point, fall back to merge-base
  if base_commit="$(git merge-base --fork-point "$resolved_candidate" "$TARGET_BRANCH" 2>/dev/null)"; then
    method="fork-point"
  else
    base_commit="$(git merge-base "$resolved_candidate" "$TARGET_BRANCH")"
    method="merge-base"
  fi

  # Commit timestamp of the inferred split point
  ts="$(git show -s --format=%ct "$base_commit")"

  echo "Candidate: $resolved_candidate"
  echo "  Base commit: $base_commit"
  echo "  Method:      $method"
  echo "  Date:        $(git show -s --format=%ci "$base_commit")"
  echo

  if (( ts > best_ts )); then
    best_ts="$ts"
    best_branch="$resolved_candidate"
    best_base="$base_commit"
    best_method="$method"
  fi
done

if [[ -z "$best_branch" ]]; then
  echo "Could not determine a base branch from candidates: ${CANDIDATES[*]}" >&2
  exit 1
fi

echo "Best guess:"
echo "  Base branch: $best_branch"
echo "  Base commit: $best_base"
echo "  Method:      $best_method"
echo "  Date:        $(git show -s --format=%ci "$best_base")"
