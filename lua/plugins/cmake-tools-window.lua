local M = {}

function M.setup()
	if vim.fn.exists("##BufModifiedSet") == 1 then
		return
	end

	-- Neovim 0.13 removed BufModifiedSet; cmake-tools still registers it directly.
	local popup = require("plenary.popup")
	local window = require("cmake-tools.window")

	window.open = function()
		local width = 80
		local height = 20
		local bufnr = vim.api.nvim_create_buf(false, false)
		local win_id = popup.create(bufnr, {
			title = window.title,
			line = math.floor(((vim.o.lines - height) / 2) - 1),
			col = math.floor((vim.o.columns - width) / 2),
			minwidth = width,
			minheight = height,
			borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		})

		window.win_id = win_id
		window.bufh = bufnr

		vim.wo[win_id].number = true
		vim.api.nvim_buf_set_name(bufnr, "cmake-tools.env-config")
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, window.content)
		vim.bo[bufnr].filetype = "lua"
		vim.bo[bufnr].buftype = "acwrite"
		vim.bo[bufnr].bufhidden = "delete"

		vim.keymap.set("n", "q", window.toggle_window, { silent = true, buffer = bufnr })
		vim.keymap.set("n", "<Esc>", window.toggle_window, { silent = true, buffer = bufnr })

		local group = vim.api.nvim_create_augroup("CMakeToolsSettings" .. bufnr, { clear = true })
		vim.api.nvim_create_autocmd("BufWriteCmd", {
			group = group,
			buffer = bufnr,
			callback = window.save,
		})
		vim.api.nvim_create_autocmd("BufLeave", {
			group = group,
			buffer = bufnr,
			callback = window.exit,
		})
		vim.api.nvim_create_autocmd("OptionSet", {
			group = group,
			pattern = "modified",
			callback = function(args)
				if args.buf ~= bufnr or not vim.api.nvim_buf_is_valid(bufnr) or not vim.bo[bufnr].modified then
					return
				end
				window.save()
				vim.bo[bufnr].modified = false
			end,
		})

		vim.bo[bufnr].modified = false
	end
end

return M
