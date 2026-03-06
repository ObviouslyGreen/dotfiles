local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Strip trailing whitespace on save
augroup("StripTrailingWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = "StripTrailingWhitespace",
  pattern = { "*.txt", "*.js", "*.py", "*.sh", "*.go", "*.lua" },
  callback = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local old_query = vim.fn.getreg("/")
    vim.cmd([[silent! %s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, cursor)
    vim.fn.setreg("/", old_query)
  end,
})
