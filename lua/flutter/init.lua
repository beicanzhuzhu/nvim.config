--- Flutter 支持入口。
---
--- 这个目录是自成一体的:  所有逻辑都在 lua/flutter/ 下, 外部只有几处必要的接线
--- (见 README 的 Dart / Flutter 一节)。整体可以原样搬成一个独立插件。
---
---   project.lua  工程探测 (无插件依赖, 门控阶段就会 require)
---   lsp.lua      dartls 配置      <- after/lsp/dartls.lua 代理
---   tasks.lua    overseer 模板    <- lua/overseer/template/user/flutter.lua 代理
---   dap.lua      调试 / 热重载
---   device.lua   设备与模拟器
---   ui.lua       statusline / telescope 忽略规则
---
--- setup() 由 lua/plugins/init.lua 的门控在探测到 pubspec.yaml 后调用一次,
--- 调用前需保证 overseer 和 nvim-dap 已经加载。

---@class FlutterModule
local M = {}

local did_setup = false

--- 保存 dart 文件后自动热重载, 用 :FlutterReloadOnSave 切换.
vim.g.flutter_reload_on_save = vim.g.flutter_reload_on_save ~= false

---@param dap_flutter FlutterDap
local function create_commands(device, dap_flutter)
	local command = vim.api.nvim_create_user_command

	-- 注意都要包一层: user command 会把 opts 表作为第一个参数传进来
	local actions = {
		FlutterDevices = { device.select_device, "选择目标设备" },
		FlutterEmulators = { device.select_emulator, "启动模拟器" },
		FlutterRun = { dap_flutter.run, "以 debug 模式运行" },
		FlutterQuit = { dap_flutter.stop, "终止当前会话" },
		FlutterReload = { dap_flutter.hot_reload, "热重载" },
		FlutterRestart = { dap_flutter.hot_restart, "热重启" },
	}

	for name, action in pairs(actions) do
		command(name, function()
			action[1]()
		end, { desc = "Flutter: " .. action[2] })
	end

	command("FlutterReloadOnSave", function()
		vim.g.flutter_reload_on_save = not vim.g.flutter_reload_on_save
		vim.notify("保存自动热重载: " .. (vim.g.flutter_reload_on_save and "开" or "关"))
	end, { desc = "Flutter: 切换保存时自动热重载" })
end

---@param dap_flutter FlutterDap
local function create_keymaps(device, dap_flutter)
	-- <leader>f 已经被 telescope find_files 占用(单键), 再挂 <leader>fx 会引入
	-- 等待延迟, 所以热路径统一走功能键, 与已有的 <F5> 保持一致.
	--
	-- <F4> 选择设备 / <F5> 启动(dap) / <F6> 热重载 / <F7> 热重启 / <leader>dq 终止
	local map = vim.keymap.set

	map("n", "<F4>", device.select_device, { silent = true, desc = "Flutter: 选择设备" })
	map("n", "<F6>", dap_flutter.hot_reload, { silent = true, desc = "Flutter: 热重载" })
	map("n", "<F7>", dap_flutter.hot_restart, { silent = true, desc = "Flutter: 热重启" })
end

local function create_autocmds()
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = vim.api.nvim_create_augroup("FlutterReloadOnSave", { clear = true }),
		pattern = "*.dart",
		callback = function()
			if not vim.g.flutter_reload_on_save then
				return
			end

			local session = require("dap").session()
			if not session or session.config.type ~= "flutter" then
				return
			end

			-- 保存触发的热重载不弹通知, 只在失败时提示
			session:request("hotReload", { reason = "save" }, function(err)
				if err then
					vim.notify("Hot reload 失败: " .. (err.message or vim.inspect(err)), vim.log.levels.ERROR)
				end
			end)
		end,
	})
end

function M.setup()
	if did_setup then
		return
	end
	did_setup = true

	local device = require("flutter.device")
	local dap_flutter = require("flutter.dap")

	create_commands(device, dap_flutter)
	create_keymaps(device, dap_flutter)
	create_autocmds()

	require("flutter.ui").setup()
end

return M
