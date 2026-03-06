local fzf = {
  src = "https://github.com/junegunn/fzf",
  spec = { "fzf", lazy = false },
}

local fzf_vim = {
  src = "https://github.com/junegunn/fzf.vim",
  spec = {
    "fzf.vim",
    lazy = false,
    after = function()
      vim.keymap.set("n", "<C-p>", "<cmd>FZF<CR>", { desc = "Fuzzy find files" })
      vim.keymap.set("n", "<leader>f", "<cmd>Rg<CR>", { desc = "Ripgrep search" })
    end,
  },
}

local sneak = {
  src = "https://github.com/justinmk/vim-sneak",
  spec = {
    "vim-sneak",
    lazy = false,
    after = function()
      vim.keymap.set("", "f", "<Plug>Sneak_f", { desc = "Sneak f (1-char forward)" })
      vim.keymap.set("", "F", "<Plug>Sneak_F", { desc = "Sneak F (1-char backward)" })
    end,
  },
}

return { fzf, fzf_vim, sneak }
