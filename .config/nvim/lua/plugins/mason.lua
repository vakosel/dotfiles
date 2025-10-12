return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "pyright",
        "lua-language-server",
        "ruff",
        "debugpy",
        "black",
        "isort",
      },
    },
  },
}
