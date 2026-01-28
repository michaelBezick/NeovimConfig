-- NvChad LSP config (Neovim 0.11+)
-- Replaces legacy `require("lspconfig").X.setup{...}` with `vim.lsp.config()` + `vim.lsp.enable()`
-- to avoid the nvim-lspconfig "framework is deprecated" warning.

local ok = (vim.lsp ~= nil) and (vim.lsp.config ~= nil) and (vim.lsp.enable ~= nil)
if not ok then
  vim.notify(
    "This LSP config expects Neovim 0.11+. Update Neovim (or keep the legacy lspconfig setup).",
    vim.log.levels.ERROR
  )
  return
end

-- Pull NvChad defaults (capabilities, on_attach, on_init, etc.)
local nvlsp = require("nvchad.configs.lspconfig")

local base = {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

local function with_base(opts)
  return vim.tbl_deep_extend("force", {}, base, opts or {})
end

-- -----------------------------
-- Simple servers
local servers = { "html", "cssls", "bashls" }
for _, srv in ipairs(servers) do
  vim.lsp.config(srv, with_base({}))
end

-- -----------------------------
-- clangd (explicit config, CUDA-friendly)
vim.lsp.config("clangd", with_base({
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=never",
    "--pch-storage=memory",
    "--compile-commands-dir=build",
    "--query-driver=/usr/bin/clang++,/usr/bin/clang,/usr/bin/g++,/usr/bin/gcc,/usr/bin/*-g++,/usr/bin/*-gcc,/usr/local/cuda/bin/nvcc",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
}))

-- -----------------------------
-- Python: basedpyright (primary)
vim.lsp.config("basedpyright", with_base({
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic",
        useLibraryCodeForTypes = true,
        autoImportCompletions = true,
        diagnosticMode = "openFilesOnly",
        -- stubPath = "typings",
      },
    },
  },
}))

-- -----------------------------
-- Optional: Jedi (completion help on dynamic C-extensions)
vim.lsp.config("jedi_language_server", with_base({
  on_attach = function(client, bufnr)
    -- disable Jedi diagnostics to avoid duplicates with basedpyright
    client.server_capabilities.diagnosticProvider = nil
    client.handlers["textDocument/publishDiagnostics"] = function() end

    if base.on_attach then
      base.on_attach(client, bufnr)
    end
  end,
  single_file_support = true,
}))

-- -----------------------------
-- Enable the servers
vim.lsp.enable({
  "html",
  "cssls",
  "bashls",
  "clangd",
  "basedpyright",
  "jedi_language_server",
})

