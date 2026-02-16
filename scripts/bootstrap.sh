#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ ! -f "$ROOT_DIR/backend/Gemfile" ]; then
  echo "[bootstrap] generating Rails API in backend/ ..."
  (cd "$ROOT_DIR" && rails new backend --api --skip-test --skip-jbuilder --skip-action-mailbox --skip-action-text --skip-active-storage --skip-action-cable)
else
  echo "[bootstrap] backend already exists (Gemfile found). skip."
fi

if [ ! -f "$ROOT_DIR/frontend/package.json" ]; then
  echo "[bootstrap] generating Nuxt in frontend/ ..."
  (cd "$ROOT_DIR" && npx nuxi@latest init frontend)
else
  echo "[bootstrap] frontend already exists (package.json found). skip."
fi

echo "[bootstrap] done."
