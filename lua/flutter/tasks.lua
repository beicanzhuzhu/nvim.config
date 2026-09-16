--- Flutter / Dart 工程任务.
---
--- 在含有 pubspec.yaml 的目录下, 这些任务会自动出现在 <leader>ot 的列表里.
---
--- 由 lua/overseer/template/user/flutter.lua 代理返回。不用
--- overseer.register_template 是因为它不会让 provider 缓存失效
--- (template.lua 的 last_rtp 不重置), 先开过一次任务列表再进 Flutter 工程
--- 就看不到这些任务了; 走运行时路径扫描则没有这个问题。

---@class FlutterTasks
local M = {}

---@return overseer.TemplateFileProvider
function M.provider()
	return {
		cache_key = function(opts)
			return vim.fs.find("pubspec.yaml", {
				upward = true,
				type = "file",
				path = opts.dir,
			})[1]
		end,

		generator = function(search)
			local pubspec = vim.fs.find("pubspec.yaml", {
				upward = true,
				type = "file",
				path = search.dir,
			})[1]

			if not pubspec then
				return {}
			end

			local root = vim.fs.dirname(pubspec)
			local TAG = require("overseer").TAG

			local is_flutter = require("flutter.project").is_flutter(pubspec)

			--- cmd 可以是函数, 在 builder 里才求值.
			--- 模板列表按 pubspec.yaml 缓存, 所以任何依赖"当前文件"的参数都不能在
			--- generator 阶段算出来, 否则会被缓存成第一次打开的那个文件.
			---@param name string
			---@param cmd string[]|fun(): string[]
			---@param tags? string[]
			local function task(name, cmd, tags)
				return {
					name = name,
					tags = tags,
					builder = function()
						return {
							cmd = type(cmd) == "function" and cmd() or cmd,
							cwd = root,
							components = {
								{
									"open_output",
									direction = "dock",
									focus = false,
									on_start = "always",
									on_complete = "never",
								},
								"on_exit_set_status",
								"on_output_summarize",
							},
						}
					end,
				}
			end

			--- 代理条目: 运行/调试走 DAP (lua/plugins/dap/flutter.lua), 这样
			--- `flutter run` 和断点调试是同一个会话, 热重载才有地方下发.
			--- 选中后由 <leader>ot 的 picker 直接执行对应命令, 不真的起一个 task.
			---@param name string
			---@param command string
			---@param tags? string[]
			local function proxy(name, command, tags)
				return {
					name = name,
					tags = tags,
					proxy_command = command,
					builder = function()
						return { cmd = { "true" } }
					end,
				}
			end

			local templates = {
				task("dart: build_runner build", {
					"dart",
					"run",
					"build_runner",
					"build",
					"--delete-conflicting-outputs",
				}, { TAG.BUILD }),
				task("dart: build_runner watch", {
					"dart",
					"run",
					"build_runner",
					"watch",
					"--delete-conflicting-outputs",
				}),
			}

			local tool = is_flutter and "flutter" or "dart"

			table.insert(templates, 1, task(tool .. ": pub get", { tool, "pub", "get" }))
			table.insert(templates, 2, task(tool .. ": pub upgrade", { tool, "pub", "upgrade" }))
			table.insert(templates, 3, task(tool .. ": analyze", { tool, "analyze" }, { TAG.BUILD }))
			table.insert(templates, 4, task(tool .. ": test", { tool, "test" }, { TAG.TEST }))
			table.insert(
				templates,
				5,
				task(tool .. ": test current file", function()
					return { tool, "test", vim.fn.expand("%:p") }
				end, { TAG.TEST })
			)
			table.insert(templates, 6, task(tool .. ": format", { "dart", "format", "." }))

			if is_flutter then
				-- picker 按名字排序, 所以这里的顺序无所谓
				vim.list_extend(templates, {
					proxy("flutter: run (debug)", "FlutterRun", { TAG.RUN }),
					proxy("flutter: hot reload", "FlutterReload", { TAG.RUN }),
					proxy("flutter: hot restart", "FlutterRestart", { TAG.RUN }),
					proxy("flutter: stop", "FlutterQuit"),
					proxy("flutter: select device", "FlutterDevices"),
					proxy("flutter: launch emulator", "FlutterEmulators"),
				})

				vim.list_extend(templates, {
					task("flutter: clean", { "flutter", "clean" }, { TAG.CLEAN }),
					task("flutter: gen-l10n", { "flutter", "gen-l10n" }, { TAG.BUILD }),
					task("flutter: pub outdated", { "flutter", "pub", "outdated" }),
					task("flutter: build apk (debug)", { "flutter", "build", "apk", "--debug" }, { TAG.BUILD }),
					task("flutter: build apk (release)", { "flutter", "build", "apk", "--release" }, { TAG.BUILD }),
					task("flutter: build linux", { "flutter", "build", "linux" }, { TAG.BUILD }),
					task("flutter: doctor", { "flutter", "doctor", "-v" }),
				})
			end

			return templates
		end,
	}
end

return M
