return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
  },
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
    rust_analyzer = {
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
          },
          cargo = {
            allFeatures = true,
            target = true,
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
}
