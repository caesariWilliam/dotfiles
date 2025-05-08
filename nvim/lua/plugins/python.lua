return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      basedpyright = {
        settings = {
          basedpyright = {
            lineLength = 120,
            analysis = {
              typeCheckingMode = "standard",
            },
          },
        },
      },
      ruff = {
        settings = {
          ruff = {
            lineLength = 120,
          },
        },
      },
    },
  },
}
