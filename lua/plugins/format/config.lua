require("conform").setup({
  -- Map of filetype to formatters


  formatters = {
    clang_format = {
      prepend_args = { "--style=Microsoft" },
    }
  },

  formatters_by_ft = {

    c = { "clang_format" },

    cpp = { "clang_format" },

    lua = { "stylua" },

    html = { "prettier" },

    css = { "prettier" },

    javascript = { "prettier" },

    json = { "clang_format" },
    -- Conform will run multiple formatters sequentially
    go = { "goimports", "gofmt" },
    -- You can also customize some of the format options for the filetype
    rust = { "rustfmt", lsp_format = "fallback" },
    -- You can use a function here to determine the formatters dynamically
    python = function(bufnr)
      if require("conform").get_formatter_info("ruff_format", bufnr).available then
        return { "ruff_format" }
      else
        return { "isort", "black" }
      end
    end,
    -- Use the "*" filetype to run formatters on all filetypes.
    ["*"] = { "codespell" },
    -- Use the "_" filetype to run formatters on filetypes that don't
    -- have other formatters configured.
    ["_"] = { "trim_whitespace" },
  },
})
