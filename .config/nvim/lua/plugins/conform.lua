return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  opts = {
    default_format_opts = {
      timeout_ms = 3000,
      async = false,
      quiet = false,
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      lua = { "stylua" },
      sh = { "shfmt" },
      -- 🌟 sequential formatting: runs isort first, then black
      python = { "isort", "black" },
    },
    formatters = {
      injected = { options = { ignore_errors = true } },

      black = {
        prepend_args = {
          "--fast",
          "--line-length", -- 🌟 FIXED: Changed underscore (_) to a dash (-)
          "80",
        },
      },
      isort = {
        prepend_args = {
          "--profile",
          "black",
          "--line-ending=auto",
        },
      },
    },
    -- 🌟 This explicitly triggers the layout adjustments when saving the buffer
    format_on_save = {
      timeout_ms = 3000,
      lsp_format = "fallback",
    },
  },
}
