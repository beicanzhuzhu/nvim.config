-- load lazy.nvim plugins mamager
require("config.lazy")

-- load my basic neovim config
require("config.keymaps")
require("config.options")
require("config.autocmds")

-- check if run in neovide
if vim.g.neovide then
    print("Config for neovide")
    require("config.neovide")
end
