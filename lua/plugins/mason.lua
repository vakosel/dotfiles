return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "lua-language-server",
        "basedpyright",
        "ruff",
        "debugpy",
        "black",
        "isort",
      },
    },
  },
}
