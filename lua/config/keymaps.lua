vim.keymap.set("i", "<C-q>", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-q>", ":q!<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-z>", ":undo<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-x>", "dd", { noremap = true, silent = true })
vim.keymap.set("n", "<C-z>", ":undo<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-c>", "Y", { noremap = true, silent = true })
vim.keymap.set("n", "<C-v>", "p", { noremap = true, silent = true })

vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })

vim.keymap.set("n", "<S-j>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-k>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-c>", ":bp <BAR> bd #<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })

require("which-key").add({

  { "<leader>r",  group = "Autorun" },
  { "<leader>rr", "<cmd>Autorun<CR>",     desc = "Run your code" },
  { "<leader>rd", "<cmd>Autogdb<CR>",     desc = "Use cgdb to debug your cpp code" },
  { "<leader>ra", "<cmd>Autoaddtest<CR>", desc = "Add running test" },
  { "<leader>rt", "<cmd>Autoruntest<CR>", desc = "Run your code using test" },
  { "<leader>rx", "<cmd>Autodeltest<CR>", desc = "Del all json test" },
  {
    "<leader>e",
    "<cmd>Neotree toggle<CR>",
    desc = "Explorer",
  },
  {
    "<leader>f",
    "<cmd>Format<CR>",
    desc = "Format your code",
  },
  {
    "<leader>t",
    "<cmd>:ToggleTerm direction=float<CR>",
    desc = "Open float term",
  },
  { mode = { "v" }, { "<leader>/", "<Plug>(comment_toggle_linewise_visual)", desc = "Comment line" } },
  { mode = { "n" }, { "<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Comment line" } },

})
