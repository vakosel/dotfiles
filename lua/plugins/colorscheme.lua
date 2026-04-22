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
    config = function()
      vim.cmd.colorscheme("juliana")

      local function transparent()
        local groups = {
          "Normal",
          "NormalNC",
          "NormalFloat",
          "FloatBorder",
          "SignColumn",
          "EndOfBuffer",
          "VertSplit",
        }

        for _, group in ipairs(groups) do
          vim.api.nvim_set_hl(0, group, { bg = "none" })
        end
      end

      -- apply immediately
      transparent()

      -- re-apply every time a colorscheme is loaded (IMPORTANT)
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = transparent,
      })
    end,
  },
  -- {
  --   "kaiuri/nvim-juliana",
  --   lazy = false,
  --   priority = 1000,
  --   -- We don't need a config function because the plugin is simple
  --   config = function()
  --     -- Apply transparency manually since we aren't using a setup function
  --     vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
  --     vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
  --
  --     vim.cmd("colorscheme juliana")
  --   end,
  -- },
}
