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
vim.lsp.config(
	"clangd",
	with_base({
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
	})
)

-- -----------------------------
-- Python: ty
local ty_cmd = { "ty", "server" }
if vim.env.VIRTUAL_ENV and vim.fn.isdirectory(vim.env.VIRTUAL_ENV) == 0 then
	-- A deleted activated environment makes ty fail before it can discover Python.
	-- Only sanitize the server process; leave Neovim's environment unchanged.
	ty_cmd = { "env", "-u", "VIRTUAL_ENV", "ty", "server" }
end

vim.lsp.config(
	"ty",
	with_base({
		cmd = ty_cmd,
		root_dir = function(bufnr, on_dir)
			local root = vim.fs.root(bufnr, {
				"ty.toml",
				"pyproject.toml",
				"setup.py",
				"setup.cfg",
				"requirements.txt",
				"Pipfile",
				".git",
			})
			local home = vim.fs.normalize(vim.uv.os_homedir())
			-- A home-level .git must not make all personal files a Python workspace.
			if not root or root == home or root == "/" then
				root = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
			end
			if root and root ~= home and root ~= "/" then
				on_dir(root)
			end
		end,
		settings = {
			ty = {
				diagnosticMode = "openFilesOnly",
			},
		},
	})
)

-- -----------------------------
-- MATLAB: official MathWorks language server
--
-- Full features require MATLAB installed on the machine running Neovim.
-- If this machine does not have MATLAB, set matlabConnectionTiming = "never"
-- to avoid spawn errors, but expect reduced functionality.

vim.filetype.add({
	extension = {
		m = "matlab", -- Treat .m files as MATLAB instead of Objective-C
	},
})

vim.lsp.config(
	"matlab_ls",
	with_base({
		cmd = { "matlab-language-server", "--stdio" },
		filetypes = { "matlab" },

		root_dir = function(bufnr, on_dir)
			local fname = vim.api.nvim_buf_get_name(bufnr)
			local root = vim.fs.root(fname, {
				".git",
				"startup.m",
				"matlab.prj",
				"SimulinkProject",
			})
			on_dir(root or vim.fn.getcwd())
		end,

		settings = {
			MATLAB = {
				indexWorkspace = true,

				-- On the remote/Linux machine where MATLAB exists, use the real matlabroot.
				-- Based on your earlier shell path, this is probably:
				installPath = "/usr/local/MATLAB/R2026a",

				-- Options:
				--   "onStart"  = start MATLAB when opening a MATLAB file
				--   "onDemand" = start MATLAB only for features that need it
				--   "never"    = do not start MATLAB; safer on machines without MATLAB
				matlabConnectionTiming = "onStart",

				-- I would turn this off unless you specifically want MathWorks telemetry.
				telemetry = false,
			},
		},
	})
)

-- -----------------------------
-- Enable the servers
vim.lsp.enable({
	"html",
	"cssls",
	"bashls",
	"clangd",
	"ty",
	"matlab_ls",
})
