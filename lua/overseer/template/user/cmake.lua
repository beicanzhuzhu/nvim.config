---@type overseer.TemplateFileProvider
return {
	cache_key = function(opts)
		return vim.fs.find("CMakeLists.txt", {
			upward = true,
			type = "file",
			path = opts.dir,
		})[1]
	end,

	generator = function(search)
		local cmake_file = vim.fs.find("CMakeLists.txt", {
			upward = true,
			type = "file",
			path = search.dir,
		})[1]

		if not cmake_file then
			return {}
		end

		local TAG = require("overseer").TAG

		local function command_proxy(name, command, tags)
			return {
				name = name,
				tags = tags,
				cmake_tools_command = command,
				builder = function()
					return {
						cmd = { "true" },
					}
				end,
			}
		end

		return {
			command_proxy("cmake-tools generate", "CMakeGenerate"),
			command_proxy("cmake-tools generate clean", "CMakeGenerate!", { TAG.CLEAN }),
			command_proxy("cmake-tools build", "CMakeBuild", { TAG.BUILD }),
			command_proxy("cmake-tools build clean first", "CMakeBuild!", { TAG.BUILD, TAG.CLEAN }),
			command_proxy("cmake-tools run", "CMakeRun", { TAG.RUN }),
			command_proxy("cmake-tools run current file", "CMakeRunCurrentFile", { TAG.RUN }),
			command_proxy("cmake-tools build current file", "CMakeBuildCurrentFile", { TAG.BUILD }),
			command_proxy("cmake-tools test", "CMakeRunTest --output-on-failure", { TAG.TEST }),
			command_proxy("cmake-tools clean", "CMakeClean", { TAG.CLEAN }),
			command_proxy("cmake-tools install", "CMakeInstall"),
			command_proxy("cmake-tools select build target", "CMakeSelectBuildTarget"),
			command_proxy("cmake-tools select launch target", "CMakeSelectLaunchTarget"),
			command_proxy("cmake-tools select configure preset", "CMakeSelectConfigurePreset"),
			command_proxy("cmake-tools select build preset", "CMakeSelectBuildPreset"),
			command_proxy("cmake-tools select kit", "CMakeSelectKit"),
			command_proxy("cmake-tools select build type", "CMakeSelectBuildType"),
		}
	end,
}
