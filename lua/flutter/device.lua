--- Flutter 设备 / 模拟器选择.
---
--- `flutter devices --machine` 输出 JSON; `flutter emulators` 在当前 Flutter
--- 版本上不支持 --machine, 只能解析 `•` 分隔的文本表格.

---@class FlutterDevice
---@field id string
---@field name string
---@field platform string
---@field emulator boolean

---@class FlutterDeviceModule
local M = {}

--- 当前选中的设备, nil 表示交给 flutter 自己决定.
---@type FlutterDevice|nil
local selected = nil

---@return string|nil
function M.current()
	return selected and selected.id or nil
end

---@return string|nil
function M.current_name()
	return selected and selected.name or nil
end

---@param device FlutterDevice|nil
function M.set(device)
	selected = device
	if device then
		vim.notify(("Flutter 设备: %s (%s)"):format(device.name, device.id))
	else
		vim.notify("Flutter 设备: 自动")
	end
end

--- flutter 偶尔会在 JSON 前面打印升级横幅, 所以从第一个 `[` 开始截取.
---@param stdout string
---@return table[]
local function decode_devices(stdout)
	local start = stdout:find("[", 1, true)
	if not start then
		return {}
	end

	local ok, decoded = pcall(vim.json.decode, stdout:sub(start))
	if not ok or type(decoded) ~= "table" then
		return {}
	end

	return decoded
end

--- 异步列出已连接设备.
---@param callback fun(devices: FlutterDevice[])
function M.list(callback)
	vim.system({ "flutter", "devices", "--machine" }, { text = true }, function(res)
		local devices = {}

		if res.code == 0 then
			for _, raw in ipairs(decode_devices(res.stdout or "")) do
				if raw.id then
					table.insert(devices, {
						id = raw.id,
						name = raw.name or raw.id,
						platform = raw.targetPlatform or "?",
						emulator = raw.emulator == true,
					})
				end
			end
		end

		vim.schedule(function()
			if res.code ~= 0 then
				vim.notify("flutter devices 失败:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
			end
			callback(devices)
		end)
	end)
end

--- 异步列出可用模拟器.
---@param callback fun(emulators: { id: string, name: string, platform: string }[])
function M.list_emulators(callback)
	vim.system({ "flutter", "emulators" }, { text = true }, function(res)
		local emulators = {}

		for line in (res.stdout or ""):gmatch("[^\r\n]+") do
			-- Id • Name • Manufacturer • Platform
			local id, name, _, platform = line:match("^(%S+)%s*•%s*(.-)%s*•%s*(.-)%s*•%s*(%S+)%s*$")
			if id and id ~= "Id" then
				table.insert(emulators, { id = id, name = name, platform = platform })
			end
		end

		vim.schedule(function()
			callback(emulators)
		end)
	end)
end

--- 通用 telescope 单选框.
---@param title string
---@param entries table[]
---@param display fun(entry: table): string
---@param on_select fun(entry: table)
local function pick(title, entries, display, on_select)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	pickers
		.new({}, {
			prompt_title = title,
			finder = finders.new_table({
				results = entries,
				entry_maker = function(entry)
					local text = display(entry)
					return { value = entry, display = text, ordinal = text }
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local sel = action_state.get_selected_entry()
					if sel then
						vim.schedule(function()
							on_select(sel.value)
						end)
					end
				end)
				return true
			end,
		})
		:find()
end

--- 选择运行目标设备.
function M.select_device()
	vim.notify("正在枚举 Flutter 设备...")

	M.list(function(devices)
		if vim.tbl_isempty(devices) then
			vim.notify("没有可用设备, 可以用 :FlutterEmulators 启动一个模拟器", vim.log.levels.WARN)
			return
		end

		pick("Flutter 设备", devices, function(device)
			return ("%s  [%s]  %s"):format(device.name, device.platform, device.id)
		end, M.set)
	end)
end

--- 选择并启动模拟器.
function M.select_emulator()
	vim.notify("正在枚举 Flutter 模拟器...")

	M.list_emulators(function(emulators)
		if vim.tbl_isempty(emulators) then
			vim.notify("没有已创建的模拟器, 参考 flutter emulators --create", vim.log.levels.WARN)
			return
		end

		pick("Flutter 模拟器", emulators, function(emulator)
			return ("%s  [%s]  %s"):format(emulator.name, emulator.platform, emulator.id)
		end, function(emulator)
			vim.notify(("正在启动模拟器 %s..."):format(emulator.name))
			vim.system({ "flutter", "emulators", "--launch", emulator.id }, { text = true }, function(res)
				vim.schedule(function()
					if res.code == 0 then
						vim.notify(("模拟器 %s 已启动"):format(emulator.name))
					else
						vim.notify("启动模拟器失败:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
					end
				end)
			end)
		end)
	end)
end

return M
