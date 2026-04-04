---@type overseer.ComponentFileDefinition
return {
	desc = "Enter terminal input mode after opening focused task output",
	editable = false,
	serializable = false,
	constructor = function()
		return {
			on_start = function(self, task)
				vim.schedule(function()
					local bufnr = task:get_bufnr()
					if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
						return
					end

					local winid = vim.api.nvim_get_current_win()
					if vim.api.nvim_win_get_buf(winid) ~= bufnr then
						return
					end

					if vim.bo[bufnr].buftype ~= "terminal" then
						return
					end

					vim.cmd("startinsert")
				end)
			end,
		}
	end,
}
