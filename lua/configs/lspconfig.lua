-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls", "bashls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configuring clangd explicitly
lspconfig.clangd.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { 
    "clangd",
    "--header-insertion=never",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--pch-storage=memory",
    "--query-driver=/usr/bin/g++", -- Ensure this is the correct path to g++
    "--compile-commands-dir=build", -- Adjust if your compile_commands.json is in another location
    -- "--std=c++17" -- Use C++17 or change to C++20 if needed
  }
}

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
