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
		time_limit = 5991,
	},
	window = {
		width = 40,
		dir = "left",
	}
})

-- Toggle cph
vim.keymap.set("n", "<leader>x", "<cmd>ToggleCPH<CR>")
