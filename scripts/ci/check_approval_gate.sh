#!/usr/bin/env bash
set -euo pipefail

BASE_REF="${1:-origin/${GITHUB_BASE_REF:-main}}"
HEAD_REF="${2:-HEAD}"

if [ ! -f "docs/approval.md" ]; then
  echo "::error file=docs/approval.md::docs/approval.md not found"
  exit 1
fi

# Extract "status: pending|approved" (allow inline comments)
STATUS_LINE="$(grep -E '^status:' docs/approval.md | head -n 1 || true)"
STATUS="$(echo "${STATUS_LINE}" | sed -E 's/^status:[[:space:]]*//; s/[[:space:]]+#.*$//; s/[[:space:]]*$//')"

if [ -z "${STATUS}" ]; then
  echo "::error file=docs/approval.md::Could not parse status. Expected: status: pending|approved"
  exit 1
fi

echo "approval.status=${STATUS}"

CHANGED="$(git diff --name-only "${BASE_REF}...${HEAD_REF}" || true)"
echo "changed.files:"
echo "${CHANGED}"

if echo "${CHANGED}" | grep -qE '^(backend|frontend)/'; then
  if [ "${STATUS}" != "approved" ]; then
    echo "::error::Approval gate blocked: backend/frontend changes require docs/approval.md status: approved (current: ${STATUS})"
    exit 1
  fi
fi

echo "Approval gate: OK"
