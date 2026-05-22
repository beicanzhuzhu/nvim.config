---@type overseer.TemplateFileProvider
return {
	generator = function(search)
		local cmake = vim.fs.find("CMakeLists.txt", {
			upward = true,
			type = "file",
			path = search.dir,
		})[1]

		if not cmake then
			return {}
		end

		local root = vim.fs.dirname(cmake)

		---@type overseer.TemplateFileDefinition[]
		return {
			{
				name = "CMake: configure release",
				builder = function()
					return {
						cmd = { "cmake" },
						args = {
							"-S",
							".",
							"-B",
							"build",
							"-G",
							"Ninja",
							"-DCMAKE_BUILD_TYPE=Release",
						},
						cwd = root,
						components = {
							{ "on_output_quickfix", open = true },
							"default",
						},
					}
				end,
			},
			{
				name = "CMake: build",
				builder = function()
					return {
						cmd = { "cmake" },
						args = { "--build", "build" },
						cwd = root,
						components = {
							{ "on_output_quickfix", open = true },
							"default",
						},
					}
				end,
			},
		}
	end,
}
