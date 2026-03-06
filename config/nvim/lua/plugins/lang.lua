local vim_go = {
  src = "https://github.com/fatih/vim-go",
  spec = {
    "vim-go",
    ft = "go",
    -- Must be set before load (read at source time)
    before = function()
      local g = vim.g
      g.go_fmt_command = "goimports"
      g.go_imports_mode = "goimports"
      g.go_highlight_types = 1
      g.go_highlight_fields = 1
      g.go_highlight_functions = 1
      g.go_highlight_methods = 1
      g.go_highlight_operators = 1
      g.go_highlight_extra_types = 1
      g.go_highlight_build_constraints = 1
      g.go_doc_popup_window = 1
      g.go_def_mode = "gopls"
      g.go_info_mode = "gopls"
      g.go_referrers_mode = "gopls"
      g.go_debug_address = "localhost:2345"
      g.go_debug_windows = {
        vars = "rightbelow 50vnew",
        stack = "rightbelow 10new",
      }
      g.go_debug_mappings = {
        ["(go-debug-continue)"] = { key = "c", arguments = "<nowait>" },
        ["(go-debug-next)"] = { key = "n", arguments = "<nowait>" },
        ["(go-debug-step)"] = { key = "s" },
        ["(go-debug-print)"] = { key = "p" },
        ["(go-debug-breakpoint)"] = { key = "b" },
      }
    end,
    after = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("VimGoKeymaps", { clear = true }),
        pattern = "go",
        callback = function()
          vim.keymap.set("n", "<leader>gd", "<Plug>(go-def-vertical)", {
            buffer = true, silent = true, desc = "Go: Def vertical",
          })
        end,
      })
    end,
  },
}

local gotests = {
  src = "https://github.com/buoto/gotests-vim",
  spec = {
    "gotests-vim",
    ft = "go",
    before = function()
      vim.g.gotests_template = ""
    end,
  },
}

local pydocstring = {
  src = "https://github.com/heavenshell/vim-pydocstring",
  spec = {
    "vim-pydocstring",
    ft = "python",
    -- Must be set before load (checked once at ftplugin source time)
    before = function()
      vim.g.pydocstring_enable_mapping = 0
      vim.g.pydocstring_formatter = "google"
    end,
  },
}

return { vim_go, gotests, pydocstring }
