return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      basedpyright = {
        settings = {
          basedpyright = {
            lineLength = 100,
            analysis = {
              typeCheckingMode = "standard",
            },
          },
        },
      },
      ruff_lsp = {
        settings = {
          ruff = {
            lineLength = 100,
          },
        },
      },
    },
  },
}
