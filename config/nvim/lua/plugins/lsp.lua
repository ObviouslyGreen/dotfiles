local mason = {
  src = "https://github.com/williamboman/mason.nvim",
  spec = { "mason.nvim", lazy = false },
}

local mason_lspconfig = {
  src = "https://github.com/williamboman/mason-lspconfig.nvim",
  spec = { "mason-lspconfig.nvim", lazy = false },
}

local nvim_lspconfig = {
  src = "https://github.com/neovim/nvim-lspconfig",
  spec = { "nvim-lspconfig", lazy = false },
}

local cmp_nvim_lsp = {
  src = "https://github.com/hrsh7th/cmp-nvim-lsp",
  spec = { "cmp-nvim-lsp", lazy = false },
}

local cmp_buffer = {
  src = "https://github.com/hrsh7th/cmp-buffer",
  spec = { "cmp-buffer", lazy = false },
}

local nvim_cmp = {
  src = "https://github.com/hrsh7th/nvim-cmp",
  spec = {
    "nvim-cmp",
    lazy = false,
    priority = 40,
    after = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "gopls", "pyright", "jsonls", "html", "ruff" },
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("pyright", {
        settings = { pyright = { disableOrganizeImports = true } },
      })
      vim.lsp.config("ruff", {
        init_options = { settings = { organizeImports = true } },
      })

      vim.lsp.enable({ "gopls", "pyright", "jsonls", "html", "ruff", "copilot" })

      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif vim.snippet.active({ direction = 1 }) then
              vim.snippet.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.snippet.active({ direction = -1 }) then
              vim.snippet.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources(
          { { name = "nvim_lsp" } },
          { { name = "buffer" } }
        ),
      })

      -- gd → definition (overrides vim's "go to local declaration")
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
        callback = function(ev)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
            buffer = ev.buf, silent = true, desc = "LSP: Definition",
          })
        end,
      })

      -- Python: sort imports on save via ruff
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("RuffOrganizeImports", { clear = true }),
        pattern = "*.py",
        callback = function(args)
          local clients = vim.lsp.get_clients({ bufnr = args.buf, name = "ruff" })
          if #clients == 0 then return end
          vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports.ruff" }, diagnostics = {} },
            apply = true,
          })
        end,
      })
    end,
  },
}

return { mason, mason_lspconfig, nvim_lspconfig, cmp_nvim_lsp, cmp_buffer, nvim_cmp }
