local opt = vim.opt

opt.number = true
opt.splitright = true
opt.ignorecase = true
opt.smartcase = true
opt.undofile = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.completeopt = { "menu", "menuone", "noselect" }
opt.scrolloff = 8
opt.clipboard = "unnamedplus"
opt.foldmethod = "indent"
opt.foldenable = false

opt.listchars = {
  tab = "» ",
  extends = "›",
  precedes = "‹",
  nbsp = "·",
  trail = "·",
  space = "·",
}
opt.list = true
