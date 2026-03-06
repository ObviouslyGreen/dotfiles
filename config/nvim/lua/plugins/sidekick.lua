local sidekick = {
  src = "https://github.com/folke/sidekick.nvim",
  spec = {
    "sidekick.nvim",
    lazy = false,
    after = function()
      require("sidekick").setup({
        cli = {
          mux = { enabled = false },
        },
      })
    end,
  },
}

return { sidekick }
