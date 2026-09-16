--- dartls 配置.
---
--- 由 after/lsp/dartls.lua 代理返回 —— Neovim 的 LSP 配置解析走运行时路径
--- (`lsp/` 与 `after/lsp/`), 那个位置无法省略, 但逻辑全部留在这里.
---
--- dartls 通过自身可执行文件的位置推断 Flutter SDK, 因此必须使用 Flutter 自带的
--- `dart` (<flutter>/bin/dart), 而不是独立安装的 dart.

---@class FlutterLsp
local M = {}

--- Flutter SDK 根目录, 未安装 Flutter 时为 nil.
---@return string|nil
local function sdk_root()
	local exe = vim.fn.exepath("flutter")
	if exe == "" then
		return nil
	end
	local real = vim.uv.fs_realpath(exe) or exe
	-- <root>/bin/flutter -> <root>
	return vim.fs.dirname(vim.fs.dirname(real))
end

--- 排除掉不需要索引的目录, 大项目下对内存和 CPU 影响显著.
---@param root string|nil
---@return string[]
local function excluded_folders(root)
	local folders = { vim.fn.expand("~/.pub-cache") }
	if root then
		table.insert(folders, vim.fs.joinpath(root, "packages"))
		table.insert(folders, vim.fs.joinpath(root, ".pub-cache"))
		table.insert(folders, vim.fs.joinpath(root, "bin", "cache"))
	end
	return folders
end

local closing_labels_ns = vim.api.nvim_create_namespace("dart/closing-labels")

--- dartls 的私有通知: 在 Widget 树每个闭合括号后给出对应的构造器名.
--- 用 extmark 渲染成行尾虚拟文本, 效果等同 VSCode 的 closing labels.
---@param result table
local function publish_closing_labels(_, result)
	if not result or not result.uri then
		return
	end

	local buf = vim.uri_to_bufnr(result.uri)
	if not vim.api.nvim_buf_is_loaded(buf) then
		return
	end

	vim.api.nvim_buf_clear_namespace(buf, closing_labels_ns, 0, -1)

	local line_count = vim.api.nvim_buf_line_count(buf)
	for _, label in ipairs(result.labels or {}) do
		local line = label.range["end"].line
		if line < line_count then
			pcall(vim.api.nvim_buf_set_extmark, buf, closing_labels_ns, line, 0, {
				virt_text = { { " // " .. label.label, "Comment" } },
				virt_text_pos = "eol",
				hl_mode = "combine",
			})
		end
	end
end

--- 每次调用返回新表, 避免 Neovim 解析/合并配置时改到同一份缓存.
---@return vim.lsp.Config
function M.config()
	local root = sdk_root()

	return {
		cmd = {
			root and vim.fs.joinpath(root, "bin", "dart") or "dart",
			"language-server",
			"--protocol=lsp",
		},
		filetypes = { "dart" },
		root_markers = { "pubspec.yaml", ".git" },

		init_options = {
			onlyAnalyzeProjectsWithOpenFiles = true,
			suggestFromUnimportedLibraries = true,
			closingLabels = true,
			-- outline / flutterOutline 目前没有消费方, 关掉可以省下两条持续推送的通知
			outline = false,
			flutterOutline = false,
		},

		settings = {
			dart = {
				autoImportCompletions = true,
				-- blink.cmp 自己补全括号, 让 LSP 再补一次会打架
				completeFunctionCalls = false,
				showTodos = true,
				enableSnippets = true,
				updateImportsOnRename = true,
				renameFilesWithClasses = "prompt",
				lineLength = 100,
				analysisExcludedFolders = excluded_folders(root),
			},
		},

		handlers = {
			["dart/textDocument/publishClosingLabels"] = publish_closing_labels,
		},
	}
end

return M
