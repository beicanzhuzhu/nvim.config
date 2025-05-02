-- set some setting
vim.g.py_exec = "python3"
vim.g.cpp_c = "clang++"
vim.g.c_c = "clang"

if vim.uv.os_uname().sysname == "Windows_NT" then
    vim.g.py_exec = "python"
end

-- set for AI
-- Use openAI model
-- You need to set LLM_KEY
vim.g.AI_URL = "https://chataiapi.com/v1/chat/completions"
vim.g.AI_MODEL = "deepseek-v3"

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
