#!/bin/bash
# Atomic commits hook — nudges when diff is getting large
# Runs as a PostToolUse hook after Edit/Write operations

# Only run in git repos
git rev-parse --is-inside-work-tree > /dev/null 2>&1 || exit 0

# Find default branch
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
if [ -z "$DEFAULT_BRANCH" ]; then
  DEFAULT_BRANCH=$(git branch -r 2>/dev/null | grep -E 'origin/(main|master)' | head -1 | sed 's@.*origin/@@' | tr -d ' ')
fi
DEFAULT_BRANCH=${DEFAULT_BRANCH:-main}

# Count uncommitted changes (staged + unstaged, excluding untracked)
UNCOMMITTED=$(git diff HEAD --stat 2>/dev/null | tail -1 | grep -oE '[0-9]+ insertion|[0-9]+ deletion' | grep -oE '[0-9]+' | paste -sd+ - | bc 2>/dev/null)
UNCOMMITTED=${UNCOMMITTED:-0}

# Count total branch diff vs default branch (or committed changes on default branch)
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)
BRANCH_DIFF=0
if [ -n "$CURRENT_BRANCH" ] && [ "$CURRENT_BRANCH" != "$DEFAULT_BRANCH" ]; then
  MERGE_BASE=$(git merge-base "origin/$DEFAULT_BRANCH" HEAD 2>/dev/null)
  if [ -n "$MERGE_BASE" ]; then
    BRANCH_DIFF=$(git diff "$MERGE_BASE" HEAD --stat 2>/dev/null | tail -1 | grep -oE '[0-9]+ insertion|[0-9]+ deletion' | grep -oE '[0-9]+' | paste -sd+ - | bc 2>/dev/null)
    BRANCH_DIFF=${BRANCH_DIFF:-0}
  fi
fi

# On the default branch, use uncommitted changes as total (they should be on a branch)
ON_DEFAULT=0
if [ "$CURRENT_BRANCH" = "$DEFAULT_BRANCH" ]; then
  ON_DEFAULT=1
fi

# Total = branch diff + uncommitted
TOTAL=$((BRANCH_DIFF + UNCOMMITTED))

# Nudge thresholds
if [ "$UNCOMMITTED" -ge 80 ]; then
  echo "<atomic-commits-nudge>"
  echo "Your uncommitted diff is ~${UNCOMMITTED} lines. Consider whether you have a complete atomic unit to commit:"
  echo "- Does it pass CI on its own?"
  echo "- Is it deployable?"
  echo "- Does it introduce dead code?"
  echo "If yes to the first two and no to the third, commit it now before continuing."
  echo "</atomic-commits-nudge>"
elif [ "$TOTAL" -ge 200 ]; then
  echo "<atomic-commits-nudge>"
  if [ "$ON_DEFAULT" -eq 1 ]; then
    echo "You have ~${UNCOMMITTED} uncommitted lines on ${DEFAULT_BRANCH}. You should be working on a feature branch."
    echo "Consider creating a branch, committing your work there, and opening a PR."
  else
    echo "Your total branch diff is ~${TOTAL} lines (${BRANCH_DIFF} committed + ${UNCOMMITTED} uncommitted), approaching the ~200 line PR threshold."
    echo "Consider whether this is a natural point to open a PR and continue remaining work in a follow-up."
  fi
  echo "</atomic-commits-nudge>"
fi
