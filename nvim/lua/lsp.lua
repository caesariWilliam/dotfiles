-- Mason core
local ok_mason, mason = pcall(require, "mason")
if ok_mason then mason.setup() end

-- LSP + mason-lspconfig
local ok_mlsp, mason_lspconfig = pcall(require, "mason-lspconfig")
local ok_lspc, lspconfig = pcall(require, "lspconfig")
if not (ok_mlsp and ok_lspc) then return end

-- Servers you want
local servers = { "pyright", "rust_analyzer" }
mason_lspconfig.setup({ ensure_installed = servers })

-- Diagnostics config
vim.diagnostic.config({
  virtual_text = false,
  float = { border = "rounded", max_width = 80 },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.o.updatetime = 300
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function() vim.diagnostic.open_float(nil, { focus = false }) end,
})

-- Common attach
local on_attach = function(_, bufnr)
  local map = function(m, lhs, rhs) vim.keymap.set(m, lhs, rhs, { buffer = bufnr, silent = true }) end
  map("n", "K",  vim.lsp.buf.hover)
  map("n", "gd", vim.lsp.buf.definition)
  map("n", "gr", vim.lsp.buf.references)
  map("n", "<leader>gd", vim.lsp.buf.definition)
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
  vim.wo.signcolumn = "yes"
end

-- Get coq capabilities (this is the key change for coq compatibility)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_coq, coq = pcall(require, "coq")
if ok_coq then
  capabilities = coq.lsp_ensure_capabilities(capabilities)
end

-- Setup each server (works on all versions)
for _, server in ipairs(servers) do
  local opts = { on_attach = on_attach, capabilities = capabilities }
  if server == "rust_analyzer" then
    opts.settings = { 
      ["rust-analyzer"] = { 
        cargo = { allFeatures = true }, 
        check = { command = "clippy" } 
      } 
    }
  end
  lspconfig[server].setup(opts)
end

vim.g.coq_settings = { auto_start = true }
