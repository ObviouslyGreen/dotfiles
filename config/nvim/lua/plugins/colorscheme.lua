local gruvbox = {
  src = "https://github.com/ellisonleao/gruvbox.nvim",
  spec = {
    "gruvbox.nvim",
    lazy = false,
    priority = 1000,
    after = function()
      require("gruvbox").setup()
      vim.cmd.colorscheme("gruvbox")
    end,
  },
}

return { gruvbox }
