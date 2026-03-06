local specs = {}
local sources = {}

local categories = {
  "plugins.colorscheme",
  "plugins.ui",
  "plugins.navigation",
  "plugins.git",
  "plugins.sidekick",
  "plugins.lsp",
  "plugins.lang",
}

for _, mod in ipairs(categories) do
  local category = require(mod)
  for _, plugin in ipairs(category) do
    -- Collect source URLs for vim.pack (install/update)
    sources[#sources + 1] = plugin.src
    -- Collect lz.n specs for lazy-loading (name + triggers + hooks)
    specs[#specs + 1] = plugin.spec
  end
end

-- vim.pack handles git cloning/updating
-- load callback prevents vim.pack from adding plugins to rtp; lz.n handles loading
vim.pack.add(sources, { load = function() end })

-- lz.n handles lazy-loading with full function support
require("lz.n").load(specs)
