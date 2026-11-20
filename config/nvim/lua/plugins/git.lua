local gitsigns = {
  src = "https://github.com/lewis6991/gitsigns.nvim",
  spec = {
    "gitsigns.nvim",
    lazy = false,
    after = function()
      require("gitsigns").setup()
    end,
  },
}

local fugitive = {
  src = "https://github.com/tpope/vim-fugitive",
  spec = { "vim-fugitive", lazy = false },
}

local rhubarb = {
  src = "https://github.com/tpope/vim-rhubarb",
  spec = { "vim-rhubarb", lazy = false },
}

return { gitsigns, fugitive, rhubarb }
