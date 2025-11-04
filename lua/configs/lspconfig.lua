
-- Load NvChad defaults (capabilities, on_attach, etc.)
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")
local nvlsp = require("nvchad.configs.lspconfig")

-- Simple servers that don't need special config
local servers = { "html", "cssls", "bashls" }

for _, srv in ipairs(servers) do
  lspconfig[srv].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- -- ---- clangd (explicit config) ----
-- lspconfig.clangd.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
--   cmd = {
--     "clangd",
--     "--header-insertion=never",
--     "--background-index",
--     "--clang-tidy",
--     "--completion-style=detailed",
--     "--pch-storage=memory",
--     -- NB: Often better as a glob so clangd accepts multiple compilers:
--     -- "--query-driver=/usr/bin/clang++,/usr/bin/clang,/usr/bin/g++,/usr/bin/gcc,/usr/bin/*-g++,/usr/bin/*-gcc"
--     "--compile-commands-dir=build",
--   },
-- }

-- ---- clangd (explicit config) ----
lspconfig.clangd.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,

  -- IMPORTANT: these help clangd understand CUDA
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=never",
    "--pch-storage=memory",

    -- If you use CMake, point clangd at your compile_commands.json dir:
    "--compile-commands-dir=build",

    -- Point to your CUDA install (adjust if different)
    -- "--cuda-path=/usr/local/cuda",

    -- Let clangd parse args from common compilers (nvcc, gcc, clang)
    "--query-driver=/usr/bin/clang++,/usr/bin/clang,/usr/bin/g++,/usr/bin/gcc,/usr/bin/*-g++,/usr/bin/*-gcc,/usr/local/cuda/bin/nvcc",
  },

  -- Make clangd attach to CUDA buffers too
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
}


-- ---- Python: basedpyright (primary) ----
lspconfig.basedpyright.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic",      -- "standard" or "strict" if you want stricter checks
        useLibraryCodeForTypes = true,   -- KEY: read library code when stubs are missing
        autoImportCompletions = true,
        diagnosticMode = "openFilesOnly",
        -- stubPath = "typings",            -- optional
      },
    },
  },
}

-- -- ---- Ruff (lint/quickfix) ----
-- lspconfig.ruff.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

-- ---- Optional: Jedi for completion help on dynamic C-extensions ----
lspconfig.jedi_language_server.setup {
  on_attach = function(client, bufnr)
    -- turn off Jedi diagnostics to avoid dupes with basedpyright
    client.server_capabilities.diagnosticProvider = false
    if nvlsp.on_attach then nvlsp.on_attach(client, bufnr) end
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  single_file_support = true,
}
