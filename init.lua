-- 测量全局启动时间
vim.g.nvim_start_ns = vim.uv.hrtime()

vim.loader.enable()

-- 这个是配置的入口文件
require("config")
require("plugins")

-- change theme in lua/chadrc.lua
