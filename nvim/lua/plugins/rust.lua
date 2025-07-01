return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
              },
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
              },
              diagnostics = {
                enable = false,
                disabled = {
                  "unused-imports",
                  "unused-variables",
                  "dead-code",
                },
              },
            },
          },
        },
      },
    },
  },
}
