-- Mason for installing LSP servers
local ok_mason, mason = pcall(require, "mason")
if ok_mason then mason.setup() end

local ok_mlsp, mason_lspconfig = pcall(require, "mason-lspconfig")
if ok_mlsp then
  mason_lspconfig.setup({
    ensure_installed = { "pyright" },
    automatic_installation = { exclude = { "rust_analyzer" } },
    handlers = {},  -- Empty handlers prevents automatic server setup
  })
end

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
  map("n", "gd", function() require('telescope.builtin').lsp_definitions() end)
  map("n", "gr", function() require('telescope.builtin').lsp_references() end)
  map("n", "<leader>gd", function() require('telescope.builtin').lsp_definitions() end)
  map("n", "<leader>cd", function()
    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    vim.lsp.buf.code_action({
      context = {
        only = { "quickfix" },
        diagnostics = vim.diagnostic.get(bufnr, { lnum = lnum }),
      },
    })
  end)
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
  vim.wo.signcolumn = "yes"
end

-- Set COQ to auto-start before loading
vim.g.coq_settings = { auto_start = "shut-up" }

-- Get coq capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_coq, coq = pcall(require, "coq")
if ok_coq then
  capabilities = coq.lsp_ensure_capabilities(capabilities)
end

-- Neovim 0.11+ LSP configuration using vim.lsp.config
vim.lsp.config('pyright', {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
  capabilities = capabilities,
  on_attach = on_attach,
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

vim.lsp.config('rust_analyzer', {
  cmd = { "/opt/homebrew/bin/rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json" },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      check = { command = "clippy" },
    },
  },
})

-- Enable the LSP servers
vim.lsp.enable('pyright')
vim.lsp.enable('rust_analyzer')
