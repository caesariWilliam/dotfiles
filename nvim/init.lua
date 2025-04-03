-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.g.mapleader = " "

-- Use <leader>bn and <leader>bp to navigate buffers
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprev<CR>", { silent = true, desc = "Previous buffer" })

-- Optional: Close the current buffer with <leader>bd
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { silent = true, desc = "Close buffer" })

-- Rename reference
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Homescreen
vim.keymap.set("n", "<leader>H", function()
  require("snacks.dashboard").open()
end, { desc = "Go to LazyVim dashboard" })

-- d -> Delete without putting in register
vim.keymap.set("v", "d", '"_d', { noremap = true, silent = true })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })
