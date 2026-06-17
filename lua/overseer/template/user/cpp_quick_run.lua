---@type overseer.TemplateFileDefinition
return {
	name = "Quick run: cpp",
	builder = function()
		local file = vim.fn.expand("%:p")
		local filename = vim.fn.expand("%:t:r")
		local cwd = vim.fn.getcwd()
		local out_dir = cwd .. "/.output"
		local exe = out_dir .. "/" .. filename

		return {
			cmd = {
				"bash",
				"-c",
				"mkdir -p '"
					.. out_dir
					.. "' && g++ '"
					.. file
					.. "' -std=c++23 -o '"
					.. exe
					.. "' && '"
					.. exe
					.. "'",
			},
			components = {
				{
					"open_output",
					direction = "float",
					focus = true,
					on_start = "always",
					on_complete = "never",
				},
				"on_exit_set_status",
				"on_complete_dispose",
			},
		}
	end,
	condition = {
		filetype = { "cpp" },
	},
}
