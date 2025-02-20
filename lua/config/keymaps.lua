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

require("which-key").add({

  { "<leader>r", "<cmd>Autorun<CR>",                                   desc = "Run your code" },
  { "<leader>e", "<cmd>Neotree toggle<CR>",                            desc = "Explorer" },
  { "<leader>R", "<cmd>Autodap<CR>",                                   desc = "Dap your cpp code" },
  { "<leader>f", "<cmd>Format<CR>",                                    desc = "Format your code" },
  { "<leader>t", "<cmd>lua require'dap'.toggle_breakpoint()<cr>",      desc = "Dap Toggle Breakpoint" },
  { "<leader>b", "<cmd>lua require'dap'.step_back()<cr>",              desc = "Dap Step Back" },
  { "<leader>c", "<cmd>lua require'dap'.continue()<cr>",               desc = "Dap Continue" },
  { "<leader>o", "<cmd>lua require'dap'.step_over()<cr>",              desc = "Dap Step Over" },
  { "<leader>p", "<cmd>lua require'dap'.pause()<cr>",                  desc = "Dap Pause" },
  { "<leader>U", "<cmd>lua require'dapui'.toggle({reset = true})<cr>", desc = "Dap Toggle UI" },
})
