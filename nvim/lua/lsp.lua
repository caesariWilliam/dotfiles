-- Mason core
local ok_mason, mason = pcall(require, "mason")
if ok_mason then mason.setup() end

-- LSP + mason-lspconfig
local ok_mlsp, mason_lspconfig = pcall(require, "mason-lspconfig")
local ok_lspc, lspconfig = pcall(require, "lspconfig")
if not (ok_mlsp and ok_lspc) then return end

-- Completely disable mason-lspconfig auto-setup
mason_lspconfig.setup({
  ensure_installed = { "pyright", "rust_analyzer" },
  automatic_installation = true,
  automatic_setup = false
})

-- Diagnostics config
vim.diagnostic.config({
  virtual_text = {
    severity = { min = vim.diagnostic.severity.HINT },
    format = function(diagnostic)
      return string.format("%s", diagnostic.message)
    end,
  },
  float = { border = "rounded", max_width = 80 },
  signs = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
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

-- Set COQ to auto-start before loading
vim.g.coq_settings = { auto_start = "shut-up" }

-- Get coq capabilities (this is the key change for coq compatibility)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_coq, coq = pcall(require, "coq")
if ok_coq then
  capabilities = coq.lsp_ensure_capabilities(capabilities)
end

-- Stop any existing pyright clients first
for _, client in ipairs(vim.lsp.get_clients({ name = "pyright" })) do
  client.stop()
end

-- Setup pyright only (Mason handles the binary)
mason_lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "strict",
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly"
      }
    }
  }
})

-- Setup rust_analyzer
mason_lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = { 
    ["rust-analyzer"] = { 
      cargo = { allFeatures = true }, 
      check = { command = "clippy" } 
      -- diagnostics = { disabled = "unlinked-file" }
    } 
  }
})
