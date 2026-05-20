require("dadbod-grip").setup({
	limit = 100, -- default row limit for SELECT queries
	max_col_width = 40, -- max display width per column
	timeout = 30000, -- query timeout in ms (default: 10000; raise for slow tunnels)
	completion = true, -- set false to use blink.cmp/nvim-cmp instead
	connections_path = nil, -- absolute path to a shared connections.json file
	border = "single",
	picker = "telescope", -- "builtin", "telescope", or "snacks"
	ai = { enabled = false },
})
