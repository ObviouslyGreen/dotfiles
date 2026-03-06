# Neovim Config

Lua-based Neovim configuration using native `vim.pack` + [lz.n](https://github.com/lumen-oss/lz.n) for lazy loading.

## Requirements

- Neovim 0.12+
- Git
- [Nerd Font](https://www.nerdfonts.com/) (for file icons and statusline glyphs)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (for `:Rg`)
- [fzf](https://github.com/junegunn/fzf)
- Node.js (for Copilot)

## Structure

```
~/.config/nvim/
├── init.lua                  # Bootstrap lz.n, load core modules + plugins
├── lua/core/
│   ├── options.lua           # Editor settings (non-defaults only)
│   ├── keymaps.lua           # Global key mappings
│   └── autocmds.lua          # Autocommands
└── lua/plugins/
    ├── init.lua              # Collects all plugin specs → vim.pack.add
    ├── colorscheme.lua       # Colorscheme
    ├── ui.lua                # File explorer, statusline, indent detection
    ├── navigation.lua        # Fuzzy finding, motion
    ├── git.lua               # Git signs, fugitive
    ├── copilot.lua           # GitHub Copilot
    ├── lsp.lua               # LSP servers, completion
    └── lang.lua              # Language-specific plugins
```

## First Launch

1. Open `nvim`. lz.n bootstraps itself automatically.
2. Plugins are cloned by `vim.pack` on first use.
3. Mason auto-installs LSP servers (`:Mason` to check status).
4. Run `:Copilot setup` to authenticate GitHub Copilot.
