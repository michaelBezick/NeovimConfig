-- file: lua/configs/conform.lua  (or wherever you return opts for conform.nvim)
local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    cpp = { "clang_format" },
    c = { "clang_format" },
    cc = { "clang_format" },
    h = { "clang_format" },
    hpp = { "clang_format" },

    -- CUDA files use the 'cuda' filetype for both .cu and .cuh
    cuda = { "clang_format" },

    python = { "isort", "black" },
    yaml = { "yamlfmt" },  -- <-- comma here
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  -- Optional: turn this on if you want auto-format on save
  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
