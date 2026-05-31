-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

local uv = vim.uv
local start_ns = uv.hrtime()

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		vim.g.nvim_loaded_ms = math.floor(((uv.hrtime() - start_ns) / 1e6) * 100 + 0.5) / 100
	end,
})

M.base46 = {
	theme = "tokyodark",
	transparency = false,
	integrations = {
		"blink",
		"blink-pair",
		"dap",
		"render-markdown",
		"flash",
		"telescope",
		"tiny-inline-diagnostic",
		"todo",
		"lsp",
	},

	hl_add = {
		TinyCmdlineNormal = { link = "NormalFloat" },
		TinyCmdlineBorder = { link = "FloatBorder" },
	},

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

M.colorify = {
	enabled = true,

	mode = "virtual", -- fg, bg, virtual
	virt_text = "󱓻 ",
	highlight = { hex = true, lspvars = true },
}

-- M.nvdash = { load_on_startup = true }
M.ui = {
	tabufline = {
		enabled = false,
		lazyload = false,
	},

	telescope = { style = "borderless" },

	statusline = {
		enabled = true,
		theme = "default", -- default/vscode/vscode_colored/minimal
		-- default/round/block/arrow separators work only for default statusline theme
		-- round and block will work for minimal theme only
		separator_style = "arrow",
		order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "cursor" },
		modules = nil,	
	},
}

M.nvdash = {
	load_on_startup = true,

	header = {
		"██████╗  ██████╗██╗   ██╗███████╗",
		"██╔══██╗██╔════╝╚██╗ ██╔╝╚══███╔╝",
		"██████╔╝██║      ╚████╔╝   ███╔╝ ",
		"██╔══██╗██║       ╚██╔╝   ███╔╝  ",
		"██████╔╝╚██████╗   ██║   ███████╗",
		"╚═════╝  ╚═════╝   ╚═╝   ╚══════╝",
		"",
	},

	buttons = {

		{ txt = "", hl = "NvDashFooter", no_gap = true, rep = true },

		{ txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
		{ txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
		{ txt = "  Git Status", keys = "gh", cmd = "Telescope git_status" },
		{ txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
		{ txt = "󰚰  Update", keys = "up", cmd = ":lua vim.pack.update()" },
		{ txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },

		{ txt = "", hl = "NvDashFooter", no_gap = true, rep = true },

		{
			txt = function()
				local ms = vim.g.nvim_loaded_ms

				if not ms and vim.g.nvim_start_ns then
					ms = math.floor(((vim.uv.hrtime() - vim.g.nvim_start_ns) / 1e6) * 100 + 0.5) / 100
				elseif not ms then
					ms = "unknown"
				end

				return "⚡ Neovim loaded in " .. ms .. " ms"
			end,
			hl = "NvDashFooter",
			no_gap = true,
			content = "fit",
		},
	},
}

M.lsp = {
	signature = false,
}

M.term = {
	startinsert = true,
	base46_colors = true,
	winopts = { number = false, relativenumber = false, signcolumn = "no", foldcolumn = "0" },
	sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
	float = {
		relative = "editor",
		row = 0.1,
		col = 0.1,
		width = 0.8,
		height = 0.7,
		border = "single",
	},
}

return M
