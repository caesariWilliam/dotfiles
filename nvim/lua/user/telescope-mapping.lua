local status, telescope_builtin = pcall(require, "telescope.builtin")
if not status then
  print("Telescope not loaded!")
  return
end

vim.keymap.set("n", "<leader>fG", telescope_builtin.live_grep, { desc = "Live Grep (search file content)" })
