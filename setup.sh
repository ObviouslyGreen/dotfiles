#!/bin/bash

# setup.sh - Dotfiles setup script

set -e  # Exit on error

echo "Starting dotfiles setup..."

# Get the absolute path to the dotfiles directory
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Dotfiles directory: $DOTFILES_DIR"

# --- Helper Functions ---

backup_file() {
    local file="$1"
    if [ -f "$file" ] || [ -d "$file" ]; then
        if [ ! -L "$file" ]; then  # Check if it's NOT a symlink
            echo "Backing up $file to $file.backup..."
            mv "$file" "${file}.backup"
        else
            echo "Removing existing symlink $file..."
            rm "$file"
        fi
    fi
}

copy_file() {
    local src="$1"
    local dest="$2"
    backup_file "$dest"
    echo "Copying $src -> $dest"
    cp -R "$src" "$dest"
}

# --- Home Directory Dotfiles ---

echo "Setting up home directory dotfiles..."
copy_file "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
copy_file "$DOTFILES_DIR/zprofile" "$HOME/.zprofile"
copy_file "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"
copy_file "$DOTFILES_DIR/gitignore_global" "$HOME/.gitignore_global"
copy_file "$DOTFILES_DIR/ssh_config" "$HOME/.ssh/config"
copy_file "$DOTFILES_DIR/vimrc" "$HOME/.vimrc"
copy_file "$DOTFILES_DIR/p10k.zsh" "$HOME/.p10k.zsh"
copy_file "$DOTFILES_DIR/Brewfile" "$HOME/.Brewfile"

# --- Configuration Directories ---

echo "Setting up .config directories..."
mkdir -p "$HOME/.config"

# Copy directories inside config/ to ~/.config/
for config_dir in "$DOTFILES_DIR/config"/*; do
    dirname=$(basename "$config_dir")
    copy_file "$config_dir" "$HOME/.config/$dirname"
done

# --- Cursor Setup ---

echo "Setting up Cursor..."
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
mkdir -p "$CURSOR_USER_DIR"
copy_file "$DOTFILES_DIR/cursor/settings.json" "$CURSOR_USER_DIR/settings.json"
copy_file "$DOTFILES_DIR/cursor/keybindings.json" "$CURSOR_USER_DIR/keybindings.json"

if command -v cursor >/dev/null 2>&1; then
    echo "Installing Cursor extensions..."
    cat "$DOTFILES_DIR/cursor/extensions.txt" | while read -r extension; do
        cursor --install-extension "$extension" --force
    done
else
    echo "Cursor command not found. Skipping extension installation."
fi

# --- Claude Code Setup ---

echo "Setting up Claude Code..."
mkdir -p "$HOME/.claude"
copy_file "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
copy_file "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
copy_file "$DOTFILES_DIR/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
chmod +x "$HOME/.claude/statusline-command.sh"
mkdir -p "$HOME/.claude/agents"
for agent_file in "$DOTFILES_DIR/claude/agents"/*.md; do
    copy_file "$agent_file" "$HOME/.claude/agents/$(basename "$agent_file")"
done
mkdir -p "$HOME/.claude/commands"
for cmd_file in "$DOTFILES_DIR/claude/commands"/*.md; do
    copy_file "$cmd_file" "$HOME/.claude/commands/$(basename "$cmd_file")"
done
mkdir -p "$HOME/.claude/skills"
for skill_dir in "$DOTFILES_DIR/claude/skills"/*/; do
    skill_name=$(basename "$skill_dir")
    copy_file "${skill_dir%/}" "$HOME/.claude/skills/$skill_name"
done

# --- Local bin scripts ---

echo "Setting up ~/bin scripts..."
mkdir -p "$HOME/bin"
for bin_file in "$DOTFILES_DIR/bin"/*; do
    [ -e "$bin_file" ] || continue
    dest="$HOME/bin/$(basename "$bin_file")"
    copy_file "$bin_file" "$dest"
    chmod +x "$dest"
done

# --- Rex Setup ---

# Re-run after the copies above: they replace ~/.ssh/config and ~/.config/rex,
# which drops the ssh guard that keeps xterm-rex from reaching remote hosts.
REX_BIN="/Applications/Rex Beta.app/Contents/Helpers/Rex Server.rex/Contents/MacOS/rex"
if [ -x "$REX_BIN" ]; then
    echo "Setting up Rex terminfo and agent skill..."
    "$REX_BIN" terminfo setup
    "$REX_BIN" skill setup
else
    echo "Rex not found. Skipping Rex setup."
fi

# --- Homebrew Setup ---

if command -v brew >/dev/null 2>&1; then
    echo "Restoring Homebrew bundle..."
    brew bundle --global
else
    echo "Homebrew not found. Please install Homebrew first."
fi

echo "Setup complete! Please restart your shell."

