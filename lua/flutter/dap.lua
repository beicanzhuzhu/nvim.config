--- Flutter / Dart 调试.
---
--- 直接使用 SDK 自带的 DAP server (`flutter debug_adapter` / `dart debug_adapter`),
--- 因此 `flutter run` 和断点调试是同一个会话, 热重载通过 DAP 自定义请求
--- `hotReload` / `hotRestart` 下发.

local dap = require("dap")
local device = require("flutter.device")
local project = require("flutter.project")

---@class FlutterDap
local M = {}

dap.adapters.flutter = {
	type = "executable",
	command = "flutter",
	args = { "debug_adapter" },
	options = {
		detach = false,
		initialize_timeout_sec = 30,
	},
}

dap.adapters.dart = {
	type = "executable",
	command = "dart",
	args = { "debug_adapter" },
	options = {
		detach = false,
		initialize_timeout_sec = 30,
	},
}

---@return string
local function cwd()
	return project.root() or vim.fn.getcwd()
end

---@return string
local function entrypoint()
	local root = project.root()
	local main = project.entrypoint(root)

	if not main then
		vim.notify("找不到 lib/main.dart, 回退到当前文件", vim.log.levels.WARN)
		return vim.fn.expand("%:p")
	end

	return main
end

--- flutter run 的工具参数, 带上已选中的设备.
---@param extra? string[]
---@return fun(): string[]
local function tool_args(extra)
	return function()
		local args = vim.list_extend({}, extra or {})
		local id = device.current()
		if id then
			table.insert(args, "-d")
			table.insert(args, id)
		end
		return args
	end
end

dap.configurations.dart = {
	{
		name = "Flutter: run (debug)",
		type = "flutter",
		request = "launch",
		program = entrypoint,
		cwd = cwd,
		toolArgs = tool_args(),
	},
	{
		name = "Flutter: run (profile)",
		type = "flutter",
		request = "launch",
		program = entrypoint,
		cwd = cwd,
		toolArgs = tool_args({ "--profile" }),
	},
	{
		name = "Flutter: attach",
		type = "flutter",
		request = "attach",
		cwd = cwd,
	},
	{
		name = "Dart: run current file",
		type = "dart",
		request = "launch",
		program = "${file}",
		cwd = cwd,
	},
}

--- Flutter/Dart 的 DAP server 不发 runInTerminal 反向请求, 所有输出(flutter run
--- 的日志和 print) 都走 output 事件, 被 nvim-dap 写进 REPL buffer
--- (dap/session.lua: repl.append). 于是 dap-view 的 Console 分栏拿不到 term_buf,
--- 永远显示 "No terminal for the current session".
---
--- 所以这类会话一起来就把 dap-view 切到 REPL —— 输出真正在的地方.
--- 用 show_view 而不是 jump_to_view: 后者会 nvim_set_current_win 抢走焦点.
dap.listeners.after.event_initialized["flutter-use-repl"] = function(session)
	local kind = session.config.type
	if kind ~= "flutter" and kind ~= "dart" then
		return
	end

	vim.schedule(function()
		local ok_state, state = pcall(require, "dap-view.state")
		-- current_section 已经是 repl 时 show_view 会转调 jump_to_view 抢焦点
		if not ok_state or state.current_section == "repl" then
			return
		end
		pcall(function()
			require("dap-view").show_view("repl")
		end)
	end)
end

--- 包装一个 DAP 自定义请求.
---
--- 注意 arguments 必须是 JSON object: Flutter 的 DAP server 会把它 cast 成
--- `Map<String, Object?>` 去取 `reason`. Lua 的空表 `{}` 会被编码成 `[]`,
--- 直接触发 "List<dynamic> is not a subtype of Map<String, Object?>".
---@param command string
---@param label string
---@return fun(reason?: string)
local function custom_request(command, label)
	return function(reason)
		local session = dap.session()
		if not session then
			vim.notify("没有运行中的 Flutter 会话, 先按 <F5> 启动", vim.log.levels.WARN)
			return
		end

		session:request(command, { reason = reason or "manual" }, function(err)
			if err then
				vim.notify(("%s 失败: %s"):format(label, err.message or vim.inspect(err)), vim.log.levels.ERROR)
			else
				vim.notify(label .. " 完成")
			end
		end)
	end
end

M.hot_reload = custom_request("hotReload", "Hot reload")
M.hot_restart = custom_request("hotRestart", "Hot restart")

--- 直接以 debug 模式启动, 跳过配置选择.
function M.run()
	if dap.session() then
		vim.notify("已有运行中的会话, 先 <leader>dq 终止", vim.log.levels.WARN)
		return
	end
	dap.run(dap.configurations.dart[1])
end

function M.stop()
	dap.terminate()
end

return M
