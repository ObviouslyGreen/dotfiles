# dotfiles

macOS development environment: zsh, Neovim, WezTerm, Rex, editors, Claude Code, and Homebrew packages.

## Install

Requires [Homebrew](https://brew.sh) for the package step.

```bash
git clone git@github.com:ObviouslyGreen/dotfiles.git
cd dotfiles
./setup.sh
```

Re-run `./setup.sh` after pulling changes. It copies files (no symlinks), so edits made directly in `~` are overwritten on the next run. Any existing regular file at a destination is first moved to `<file>.backup`.

## What `setup.sh` installs

| Source | Destination |
| --- | --- |
| `zshrc`, `zprofile`, `gitconfig`, `gitignore_global`, `vimrc`, `p10k.zsh`, `Brewfile` | `~/.<name>` |
| `ssh_config` | `~/.ssh/config` |
| `config/*` | `~/.config/*` |
| `cursor/settings.json`, `cursor/keybindings.json` | `~/Library/Application Support/Cursor/User/` |
| `cursor/extensions.txt` | installed via `cursor --install-extension` (if the CLI is on `PATH`) |
| `claude/CLAUDE.md`, `settings.json`, `statusline-command.sh`, `agents/`, `commands/`, `skills/` | `~/.claude/` |
| `bin/*` | `~/bin/` |
| Rex terminfo, ssh guard, agent skill | `rex terminfo setup` and `rex skill setup` (if Rex is installed) |
| `Brewfile` | installed via `brew bundle --global` |

## Layout

- **Shell**: zsh with oh-my-zsh and Powerlevel10k. `zprofile` holds `PATH`, aliases, and env vars; `zshrc` holds oh-my-zsh plugin config.
- **`config/nvim/`**: Lua Neovim config using `vim.pack` and lz.n for lazy loading. See [`config/nvim/README.md`](config/nvim/README.md).
- **`config/wezterm/`**: WezTerm with GruvboxDark, FiraCode, and tmux-style keybindings (leader `CTRL+A`).
- **`config/zed/`**, **`config/coc/`**: Zed settings and Vim CoC (Pyright) settings.
- **`cursor/`**: Cursor settings, keybindings, and extension list.
- **`config/rex/`**: Rex keybindings (leader `CTRL+A`, resize mode) in `keys.lua`. `themes/gruvbox-dark-wezterm` matches the WezTerm colors; import it with Rex's Import Theme File. Run `rex config reload` after `./setup.sh`.
- **`claude/`**: global Claude Code instructions, settings, status line, subagents, slash commands, and skills.
- **`bin/`**: helper scripts. `claude-notify.sh` and `claude-focus-pane.sh` back the Claude Code notification hook (macOS banner that focuses the Rex or WezTerm pane on click; silent in Rex, which plays its own sound).
- **`yasb/`**, **`profile`**, **`gruvbox_idea.icls`**: Windows status bar (YASB) config, a bash profile, and a Gruvbox IntelliJ color scheme. Not installed by `setup.sh`.

