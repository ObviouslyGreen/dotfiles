local map = vim.keymap.set

-- Split navigation
map("n", "<C-J>", "<C-W><C-J>", { desc = "Move to split below" })
map("n", "<C-K>", "<C-W><C-K>", { desc = "Move to split above" })
map("n", "<C-L>", "<C-W><C-L>", { desc = "Move to split right" })
map("n", "<C-H>", "<C-W><C-H>", { desc = "Move to split left" })

-- Split resizing
map("n", "<C-S-Left>", "<cmd>vertical resize +1<CR>", { silent = true, desc = "Widen split" })
map("n", "<C-S-Right>", "<cmd>vertical resize -1<CR>", { silent = true, desc = "Narrow split" })
map("n", "<C-S-Up>", "<cmd>horizontal resize +1<CR>", { silent = true, desc = "Grow split" })
map("n", "<C-S-Down>", "<cmd>horizontal resize -1<CR>", { silent = true, desc = "Shrink split" })

-- Toggle copy/paste mode (hide line numbers + whitespace chars for clean terminal selection)
map("n", "<F3>", function()
  vim.o.number = not vim.o.number
  vim.o.list = not vim.o.list
end, { desc = "Toggle copy/paste mode" })

-- Quickfix: open entry in vertical split
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("QuickfixKeymaps", { clear = true }),
  pattern = "qf",
  callback = function()
    map("n", "<leader><CR>", "<C-w><CR><C-w>L", { buffer = true, desc = "Open in vertical split" })
  end,
})
