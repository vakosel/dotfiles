return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  build = ":TSUpdate",
  lazy = false,

  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      init = function()
        local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
        local opts = require("lazy.core.plugin").values(plugin, "opts", false)
        local enabled = false

        if opts.textobjects then
          for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
            if opts.textobjects[mod] and opts.textobjects[mod].enable then
              enabled = true
              break
            end
          end
        end

        if not enabled then
          require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
        end
      end,
    },
  },

  keys = {
    { "<c-space>", desc = "Increment selection" },
    { "<bs>", desc = "Decrement selection", mode = "x" },
  },

  opts = {
    ensure_installed = {
      "bash",
      "c",
      "html",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    },

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },

    indent = {
      enable = true,
      -- disable = { "python", "yaml" }, -- optional if you see indent issues
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },

    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },

    auto_install = true,
  },

  config = function(_, opts)
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      return
    end

    -- remove duplicates in ensure_installed
    if type(opts.ensure_installed) == "table" then
      local seen = {}
      opts.ensure_installed = vim.tbl_filter(function(lang)
        if seen[lang] then
          return false
        end
        seen[lang] = true
        return true
      end, opts.ensure_installed)
    end

    configs.setup(opts)
  end,
}
