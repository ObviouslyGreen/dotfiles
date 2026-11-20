# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal macOS dotfiles. See [README.md](README.md) for the install steps, the source-to-destination table, and the directory layout.

There are no build, lint, or test commands. This is a configuration-only repository.

## Conventions

- Files in the repo omit the leading `.`; `setup.sh` adds it when copying to `$HOME`.
- `setup.sh` copies files, it does not symlink. Make changes here, then re-run `./setup.sh`. Edits made directly in `~` are lost on the next run.
- Adding a new top-level dotfile requires a matching `copy_file` line in `setup.sh`. Anything under `config/`, `claude/agents/`, `claude/commands/`, `claude/skills/`, and `bin/` is picked up automatically.
- `claude/` is the user's global Claude Code config (installed to `~/.claude/`), separate from this project-level `CLAUDE.md`.
- Neovim uses `vim.pack` with lz.n for lazy loading; each plugin category is a separate file under `config/nvim/lua/plugins/`.
- Shell: zsh + oh-my-zsh + Powerlevel10k. `zprofile` holds `PATH`, aliases, and env vars; `zshrc` holds oh-my-zsh plugin config.

