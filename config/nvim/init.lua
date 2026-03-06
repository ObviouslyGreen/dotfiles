-- Bootstrap lz.n if not installed
local lz_path = vim.fn.stdpath("data") .. "/site/pack/lz.n/start/lz.n"
if not vim.uv.fs_stat(lz_path) then
  vim.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/lumen-oss/lz.n",
    lz_path,
  }):wait()
  vim.cmd.packadd("lz.n")
end

require("core.options")
require("core.keymaps")
require("core.autocmds")
require("plugins")
