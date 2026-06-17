-- Blink.cmp(autocompletion)

local cmp = require("blink.cmp")

cmp.build():pwait(60000)

local function filter_snippets_by_prefix(ctx, items)
	local keyword = ctx.get_keyword()

	if keyword == "" then
		return items
	end

	keyword = keyword:lower()

	return vim.tbl_filter(function(item)
		local label = item.filterText or item.label or item.insertText or ""
		return label:lower():sub(1, #keyword) == keyword
	end, items)
end

cmp.setup({
	enabled = function()
		-- :set buftype?
		-- :set filetype?
		local ft = vim.bo.filetype
		local bt = vim.bo.buftype

		-- disable for dapui
		if ft:match("^dap%-") then
			return false
		end

		-- 所有 nofile 都不开启
		if bt ~= "" and ft ~= "sql" then
			return false
		end

		return true
	end,
	keymap = {
		preset = "enter",
		["<C-h>"] = { "show", "show_documentation", "hide_documentation" },
		["<CR>"] = { "accept", "fallback" },
		["<C-l>"] = { "accept", "fallback" },
		["<C-Down>"] = { "scroll_documentation_down", "fallback" },
		["<C-Up>"] = { "scroll_documentation_up", "fallback" },
		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<Up>"] = {},
		["<Down>"] = {},
		-- ["<C-n>"] = { "select_next", "fallback" },
		-- ["<C-p>"] = { "select_prev", "fallback" },
		["<C-e>"] = { "hide", "fallback" },
	},

	fuzzy = {
		implementation = "prefer_rust_with_warning",
		sorts = { "exact", "score", "sort_text" },
	},

	snippets = { preset = "default" },

	completion = {
		documentation = {
			auto_show = false,
			auto_show_delay_ms = 800,
		},
		ghost_text = { enabled = true },
		menu = {
			border = nil,
			auto_show = true,
		},
	},

	cmdline = {
		enabled = true,
		completion = { menu = { auto_show = false } },
		sources = {
			default = { "cmdline" },
		},
		keymap = {
			-- ["<Tab>"] = {},
			-- ["<S-Tab>"] = {},

			["<C-l>"] = { "accept", "fallback" },
			["<CR>"] = { "accept_and_enter", "fallback" },

			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
		},
	},

	term = {
		enabled = false,
	},

	sources = {

		default = { "lsp", "dadbod_grip", "snippets", "path", "buffer" },

		providers = {

			snippets = {
				score_offset = 60,
				transform_items = filter_snippets_by_prefix,
				should_show_items = function(ctx)
					local line = ctx.get_line()
					local before_cursor = line:sub(1, ctx.cursor[2])

					return not (
						before_cursor:match("%.$")
						or before_cursor:match("::$")
						or before_cursor:match("%-%>$")
					)
				end,
			},

			lsp = { score_offset = 90 },

			path = { score_offset = 30 },

			buffer = {
				score_offset = 20,
				min_keyword_length = 2,
				max_items = 4,
			},

			dadbod_grip = {
				score_offset = 80,
				name = "Grip SQL",
				module = "dadbod-grip.completion.blink",
			},
		},
	},

	-- Experimental signature help support
	signature = { enabled = true },
})
