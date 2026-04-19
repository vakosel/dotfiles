return {
  -- Keep your TokyoNight for backup
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  -- Add the Mariana theme (Sublime Text style)
  {
    "kaiuri/nvim-juliana",
    lazy = false,
    priority = 1000,
    -- We don't need a config function because the plugin is simple
    config = function()
      -- Apply transparency manually since we aren't using a setup function
      vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })

      vim.cmd("colorscheme juliana")
    end,
  },
}
