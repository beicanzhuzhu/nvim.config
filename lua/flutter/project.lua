--- Dart / Flutter 工程探测.
---
--- 这个模块不依赖任何插件, 会在启动阶段的门控里被 require, 因此必须保持轻量.

---@class FlutterProject
local M = {}

--- 取当前 buffer 所在目录, buffer 无名或是特殊 buffer 时回退到 cwd.
---@return string|nil
local function buffer_dir()
	local path = vim.api.nvim_buf_get_name(0)

	if path == "" or path:find("://", 1, true) then
		return vim.uv.cwd()
	end

	local stat = vim.uv.fs_stat(path)
	if not stat or stat.type ~= "directory" then
		return vim.fs.dirname(path)
	end

	return path
end

--- 向上查找最近的 pubspec.yaml, 返回它所在的目录.
---@return string|nil root
---@return string|nil pubspec
function M.root()
	local dir = buffer_dir()
	if not dir then
		return nil, nil
	end

	local pubspec = vim.fs.find("pubspec.yaml", { path = dir, upward = true, type = "file" })[1]
	if not pubspec then
		return nil, nil
	end

	return vim.fs.dirname(pubspec), pubspec
end

--- 判断是否是 Flutter 工程 (而不是纯 Dart 包).
--- Flutter 工程的 pubspec.yaml 必然含有 `sdk: flutter`.
---@param pubspec? string pubspec.yaml 路径, 省略则自动探测
---@return boolean
function M.is_flutter(pubspec)
	if not pubspec then
		_, pubspec = M.root()
	end
	if not pubspec then
		return false
	end

	local fd = io.open(pubspec, "r")
	if not fd then
		return false
	end

	local content = fd:read("*a")
	fd:close()

	return content ~= nil and content:find("sdk:%s*flutter") ~= nil
end

--- 入口文件路径, 不存在时返回 nil.
---@param root? string
---@return string|nil
function M.entrypoint(root)
	root = root or M.root()
	if not root then
		return nil
	end

	local main = vim.fs.joinpath(root, "lib", "main.dart")
	return vim.uv.fs_stat(main) and main or nil
end

return M
