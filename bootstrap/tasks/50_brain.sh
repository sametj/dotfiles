#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/../lib.sh"

brain_task() {
  log "[brain] Setting up second brain..."

  # stow bin scripts
  stow_app "bin"

  # create vault structure if missing
  mkdir -p "$HOME/brain/"{inbox,daily,projects,areas/fitness/{workout-plans,templates},resources,archive,templates}

  # create default daily template if missing
  local daily_tmpl="$HOME/brain/templates/daily.md"
  if [[ ! -f "$daily_tmpl" ]]; then
    cat >"$daily_tmpl" <<'EOF'
# {{date}}

## 🎯 Focus (1–3 things max)
-

## 📋 Tasks
- [ ]

## 🧠 Notes
-

## 🏋️ Health
- Gym:
- Volleyball:

## 💰 Finance
- Spent:
- Notes:

## 🔥 Wins
-

## 🧱 Problems
-
EOF
    log "[brain] Daily template created."
  fi

  log "[brain] Done."
}

brain_task "$@"
