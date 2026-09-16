--- Flutter 相关的 UI 接线.

local device = require("flutter.device")

---@class FlutterUi
local M = {}

--- Dart 工程里应该忽略的路径 —— 生成物和构建缓存.
--- 只在进入 Flutter 工程后才追加, 所以对其它工程没有影响.
local IGNORE_PATTERNS = {
	"%.dart_tool/",
	"%.symlinks/",
	"%.g%.dart$",
	"%.freezed%.dart$",
}

--- 把 Dart 的忽略规则并进 telescope 的默认值.
--- telescope 的 picker 每次都是现读 config.values, 所以 setup 之后改也有效.
local function extend_telescope_ignores()
	local ok, conf = pcall(require, "telescope.config")
	if not ok then
		return
	end

	conf.values.file_ignore_patterns = conf.values.file_ignore_patterns or {}

	for _, pattern in ipairs(IGNORE_PATTERNS) do
		if not vim.tbl_contains(conf.values.file_ignore_patterns, pattern) then
			table.insert(conf.values.file_ignore_patterns, pattern)
		end
	end
end

--- NvChad statusline 的 flutter 模块.
--- 由 lua/chadrc.lua 在模块未加载时直接返回空串, 所以这里不必再判断加载状态.
---@return string
function M.statusline()
	local name = device.current_name()
	if not name then
		return ""
	end
	return "%#St_Lsp# 󰄛 " .. name .. " "
end

function M.setup()
	extend_telescope_ignores()
end

return M
