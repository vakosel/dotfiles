
return {
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    -- ⬇️ this line disables LuaRocks build attempt
    build = false,
    config = function()
      -- Path to debugpy installed by Mason
      local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(mason_path)
    end,
  },
}
