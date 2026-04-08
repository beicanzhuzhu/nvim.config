require("cph").setup({
	compile = {
		cpp = {
			compiler = "g++",
		},
		c = {
			compiler = "clang",
		},
	},
	run = {
		time_limit = 1991,
	},
	window = {
		width = 40,
		dir = "floating"
	}
})

-- Toggle cph
vim.keymap.set("n", "<leader>x", "<cmd>ToggleCPH<CR>")
