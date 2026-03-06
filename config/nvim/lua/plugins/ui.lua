local sleuth = {
  src = "https://github.com/tpope/vim-sleuth",
  spec = { "vim-sleuth", lazy = false },
}

local undotree = {
  src = "https://github.com/mbbill/undotree",
  spec = {
    "undotree",
    lazy = false,
    after = function()
      vim.keymap.set("n", "<F6>", "<cmd>UndotreeToggle<CR>", { desc = "Toggle Undotree" })
    end,
  },
}

local devicons = {
  src = "https://github.com/nvim-tree/nvim-web-devicons",
  spec = { "nvim-web-devicons", lazy = false },
}

local nvim_tree = {
  src = "https://github.com/nvim-tree/nvim-tree.lua",
  spec = {
    "nvim-tree.lua",
    lazy = false,
    before = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    after = function()
      require("nvim-tree").setup()

      vim.keymap.set("n", "<F2>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
      vim.keymap.set("n", "<F4>", "<cmd>NvimTreeFindFile<CR>", { desc = "Reveal file in tree" })
      vim.keymap.set("n", "<F5>", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file tree" })

      -- Auto-close: nvim-tree has no built-in setting for this
      vim.api.nvim_create_autocmd("QuitPre", {
        group = vim.api.nvim_create_augroup("NvimTreeAutoClose", { clear = true }),
        callback = function()
          local wins = vim.api.nvim_list_wins()
          local tree_wins = {}
          local floating_wins = {}
          for _, w in ipairs(wins) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
            if bufname:match("NvimTree_") then
              table.insert(tree_wins, w)
            end
            if vim.api.nvim_win_get_config(w).relative ~= "" then
              table.insert(floating_wins, w)
            end
          end
          if #wins - #floating_wins - #tree_wins == 1 then
            for _, w in ipairs(tree_wins) do
              vim.api.nvim_win_close(w, true)
            end
          end
        end,
      })
    end,
  },
}

local lualine = {
  src = "https://github.com/nvim-lualine/lualine.nvim",
  spec = {
    "lualine.nvim",
    lazy = false,
    after = function()
      require("lualine").setup()
    end,
  },
}

return { sleuth, undotree, devicons, nvim_tree, lualine }
