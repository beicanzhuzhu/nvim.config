local function build_library()
	local library = vim.api.nvim_get_runtime_file("", true)
	if not vim.tbl_contains(library, vim.env.VIMRUNTIME) then
		table.insert(library, vim.env.VIMRUNTIME)
	end
	return library
end

return {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
			runtime = {
				version = "LuaJIT",
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			workspace = {
				checkThirdParty = false,
				library = build_library(),
				-- vim.env.VIMRUNTIME,
				-- Depending on the usage, you might want to add additional paths
				-- here.
				-- '${3rd}/luv/library'
				-- '${3rd}/busted/library'
				-- Or pull in all of 'runtimepath'.

				-- NOTE: this is a lot slower and will cause issues when working on
				-- your own configuration.
				-- See https://github.com/neovim/nvim-lspconfig/issues/3189
				-- library = {
				--   vim.api.nvim_get_runtime_file('', true),
				-- }
			},
		})
	end,
	settings = {
		Lua = {
			workspace = {
				library = build_library(),
			},
		},
	},
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
}
