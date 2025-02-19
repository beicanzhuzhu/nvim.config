vim.keymap.set("i", "<C-q>", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-q>", ":q!<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-z>", ":undo<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-x>", "dd<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-z>", ":undo<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-c>", "Y<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-v>", "p<CR>", { noremap = true, silent = true })


vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })

require("which-key").add({

  { "<leader>r", "<cmd>Autorun<CR>",        desc = "Run your code" },
  { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Explorer" },
  { "<leader>R", "<cmd>Autodap<CR>",        desc = "Dap your cpp code" },
  { "<leader>f", "<cmd>Format<CR>",         desc = "Format your code" }
})
