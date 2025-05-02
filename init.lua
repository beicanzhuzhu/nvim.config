-- set some setting
vim.g.py_exec = "python3"
vim.g.cpp_c = "clang++"
vim.g.c_c = "clang"

-- set for AI
vim.g.AI_URL = "https://api.deepseek.com/chat/completions"
vim.g.AI_MODEL = "deepseek-chat"

if vim.uv.os_uname().sysname == "Windows_NT" then
    vim.g.py_exec = "python"
end

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
