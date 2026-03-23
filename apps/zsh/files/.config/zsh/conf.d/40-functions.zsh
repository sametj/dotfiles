# ------------------------------
# Functions
# ------------------------------
nr() {
  if [[ -z "${1:-}" ]]; then
    echo "Usage: nr <npm-script> [args...]"
    return 1
  fi
  local script="$1"
  shift
  npm run "$script" -- "$@" && clear
}

brain-project() {
  if [[ -z "${1:-}" ]]; then
    echo "Usage: brain-project <project-name>"
    return 1
  fi

  local title="$1"
  local slug="${title:l}"
  slug="${slug// /-}"
  local dir="$HOME/brain/projects/$slug"

  if [[ -d "$dir" ]]; then
    echo "Project already exists: $dir"
    cd "$dir" && nvim index.md
    return 0
  fi

  mkdir -p "$dir"

  # index.md
  cat > "$dir/index.md" << EOF
# ${title}

## Goal
-

## Current Focus
-

## Links
- [[tasks]]
- [[design]]
- [[bugs]]
- [[ideas]]
- [[decisions]]
EOF

  # tasks.md
  cat > "$dir/tasks.md" << EOF
# Tasks

## Todo
- [ ] 

## Doing
- [ ] 

## Done
EOF

  # design.md
  cat > "$dir/design.md" << EOF
# Design

## Overview
-

## Notes
-
EOF

  # bugs.md
  cat > "$dir/bugs.md" << EOF
# Bugs

-
EOF

  # ideas.md
  cat > "$dir/ideas.md" << EOF
# Ideas

-
EOF

  # decisions.md
  cat > "$dir/decisions.md" << EOF
# Decisions

## Template
### Decision title
Reason:
EOF

  echo "✓ Project created: $dir"
  cd "$dir" && nvim index.md
}
