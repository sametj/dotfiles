# dotfiles

Personal development environment for macOS and Linux/WSL. Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's included

| App | Config location |
|-----|----------------|
| zsh | `~/.zshrc`, `~/.config/zsh/conf.d/` |
| neovim | `~/.config/nvim/` |
| tmux | `~/.tmux.conf`, `~/.config/tmux/` |
| git | `~/.gitconfig`, `~/.config/git/gitignore_global` |
| ghostty | `~/.config/ghostty/config` |
| starship | `~/.config/starship.toml` |
| bin | `~/.local/bin/` — brain-* scripts and other utilities |

## Quick start

### macOS

```bash
# 1. Run bootstrap (installs Xcode CLI tools, Homebrew, Ghostty, all tools, then stows configs)
git clone https://github.com/sametj/dotfiles-2026.git ~/.dotfiles
~/.dotfiles/bootstrap.sh
```

### Windows (WSL)

```powershell
# 1. Open PowerShell as Administrator
.\bootstrap.ps1
```

```bash
# 2. After Ubuntu finishes first-run setup, inside the Ubuntu terminal
git clone https://github.com/sametj/dotfiles-2026.git ~/.dotfiles
~/.dotfiles/bootstrap/install.sh
```

### Existing machine (git + zsh already installed)

```bash
git clone https://github.com/sametj/dotfiles-2026.git ~/.dotfiles
~/.dotfiles/bootstrap/install.sh
```

## After install

```bash
exec zsh                  # reload shell
tmux                      # start tmux
# prefix + I              # install tmux plugins (TPM)
nvim                      # lazy.nvim installs plugins on first launch
```

Set your private git email — this file is gitignored and never pushed:

```bash
cat > ~/.gitconfig.local << 'EOF'
[user]
    email = you@example.com
EOF
```

## Repo layout

```
.
├── apps/                     # one folder per app
│   ├── bin/files/            # ~/.local/bin scripts (brain-*, etc.)
│   ├── git/files/            # mirrors $HOME — stowed directly
│   ├── ghostty/files/
│   ├── nvim/files/
│   ├── starship/files/
│   ├── tmux/files/
│   └── zsh/files/
├── bootstrap/
│   ├── install.sh            # task runner — loops tasks/*.sh in order
│   ├── lib.sh                # shared helpers (stow_app, pkg_install, etc.)
│   └── tasks/                # numbered install scripts
│       ├── 00_locale.sh
│       ├── 01_packages.sh
│       ├── 02_git.sh
│       ├── 03_ssh.sh
│       ├── 04_ghostty.sh
│       ├── 05_yazi.sh
│       ├── 10_tmux.sh
│       ├── 15_zsh.sh
│       ├── 20_nvim.sh
│       ├── 25_nvm.sh
│       ├── 30_python_cli.sh
│       ├── 35_dotnet.sh
│       ├── 40_netcoredbg.sh
│       └── 50_brain.sh
├── bootstrap.sh              # macOS entry point
├── bootstrap.ps1             # Windows entry point
└── .stowrc                   # --target=$HOME --dotfiles
```

## How symlinks work

Each `apps/<app>/files/` directory mirrors the final layout under `$HOME`. Stow reads `.stowrc` for `--target` and `--dotfiles`, so files prefixed with `dot-` become dotfiles on link:

```
apps/zsh/files/dot-zshrc          → ~/.zshrc
apps/git/files/dot-gitconfig      → ~/.gitconfig
apps/nvim/files/.config/nvim/     → ~/.config/nvim/
apps/ghostty/files/.config/ghostty/config → ~/.config/ghostty/config
```

## Adding a new app

```bash
# 1. Create the app scaffold
mkdir -p ~/.dotfiles/apps/myapp/files/.config/myapp

# 2. Move the existing config in
mv ~/.config/myapp/config ~/.dotfiles/apps/myapp/files/.config/myapp/config

# 3. Stow it
source ~/.dotfiles/bootstrap/lib.sh && detect_platform && stow_app myapp

# 4. Optionally add a task script for installation
cat > ~/.dotfiles/bootstrap/tasks/50_myapp.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../lib.sh"
myapp_task() {
  ensure_supported_platform
  case "${PLATFORM:-}" in
    macos)     pkg_install myapp ;;
    linux|wsl) pkg_install myapp ;;
  esac
  stow_app "myapp"
}
myapp_task "$@"
EOF
chmod +x ~/.dotfiles/bootstrap/tasks/50_myapp.sh

# 5. Commit
git -C ~/.dotfiles add .
git -C ~/.dotfiles commit -m "feat: add myapp"
git -C ~/.dotfiles push
```

## Day-to-day workflow

Edits to any config are live immediately since everything is a symlink. Just commit and push:

```bash
# edit something
nvim ~/.dotfiles/apps/zsh/files/.config/zsh/conf.d/30-aliases.zsh

# changes are instantly live — reload to test
exec zsh

# commit
git -C ~/.dotfiles add .
git -C ~/.dotfiles commit -m "fix: update aliases"
git -C ~/.dotfiles push
```

On another machine, pull and re-stow:

```bash
git -C ~/.dotfiles pull
~/.dotfiles/bootstrap/install.sh
```

## Uninstalling an app

```bash
source ~/.dotfiles/bootstrap/lib.sh && detect_platform && unstow_app myapp
```

This only removes symlinks — your dotfiles repo is untouched.

## Brain / second-brain system

The `brain-project` command scaffolds a new project under `~/brain/projects/`:

```bash
brain-project my-project
# creates ~/brain/projects/my-project/{index,tasks,design,bugs,ideas,decisions}.md
# then cd's into the directory and opens index.md in nvim
```

Each project gets a standard set of markdown files (`index.md`, `tasks.md`, `design.md`, `bugs.md`, `ideas.md`, `decisions.md`) ready for use with Obsidian or any markdown editor.

## Tools installed

| Tool | Purpose |
|------|---------|
| zsh + starship | shell + prompt |
| neovim | editor |
| tmux + catppuccin | terminal multiplexer |
| eza | modern `ls` |
| bat | modern `cat` |
| fd | modern `find` |
| ripgrep | fast grep |
| fzf | fuzzy finder |
| zoxide | smart `cd` |
| lazygit | git TUI |
| yazi | file manager |
| nvm | Node version manager |
| delta | git diff pager |
| .NET SDK | C# development |
| netcoredbg | .NET debugger |
