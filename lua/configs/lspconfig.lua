-- NvChad LSP config (Neovim 0.11+), using `vim.lsp.config()` + `vim.lsp.enable()`.

-- NvChad defaults: applies its capabilities and on_init to every server via
-- vim.lsp.config("*"), sets up LSP keymaps on attach, and enables lua_ls.
require("nvchad.configs.lspconfig").defaults()

-- Keep language servers from treating a home-level .git as a whole-home workspace.
local function bounded_root(markers)
	return function(bufnr, on_dir)
		local root = vim.fs.root(bufnr, markers)
		local home = vim.fs.normalize(vim.uv.os_homedir())
		if not root or root == home or root == "/" then
			root = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
		end
		if root and root ~= home and root ~= "/" then
			on_dir(root)
		end
	end
end

vim.lsp.config("lua_ls", {
	root_dir = bounded_root({
		".emmyrc.json",
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	}),
})

-- -----------------------------
-- clangd (explicit config, CUDA-friendly)
vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--completion-style=detailed",
		"--header-insertion=never",
		"--pch-storage=memory",
		"--query-driver=/usr/bin/clang++,/usr/bin/clang,/usr/bin/g++,/usr/bin/gcc,/usr/bin/*-g++,/usr/bin/*-gcc,/usr/local/cuda/bin/nvcc",
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
})

-- -----------------------------
-- Python: ty
local ty_cmd = { "ty", "server" }
if vim.env.VIRTUAL_ENV and vim.fn.isdirectory(vim.env.VIRTUAL_ENV) == 0 then
	-- A deleted activated environment makes ty fail before it can discover Python.
	-- Only sanitize the server process; leave Neovim's environment unchanged.
	ty_cmd = { "env", "-u", "VIRTUAL_ENV", "ty", "server" }
end

vim.lsp.config("ty", {
	cmd = ty_cmd,
	capabilities = {
		workspace = {
			didChangeWatchedFiles = { dynamicRegistration = true },
		},
	},
	root_dir = bounded_root({
		"ty.toml",
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		".git",
	}),
	settings = {
		ty = {
			diagnosticMode = "openFilesOnly",
		},
	},
})

-- -----------------------------
-- MATLAB: use MATLAB_ROOT or a MATLAB executable on PATH when available.
local matlab_root = vim.env.MATLAB_ROOT
if matlab_root and vim.fn.isdirectory(matlab_root) == 0 then
	matlab_root = nil
end
local matlab_available = matlab_root ~= nil or vim.fn.executable("matlab") == 1

vim.lsp.config("matlab_ls", {
	cmd = { "matlab-language-server", "--stdio" },
	filetypes = { "matlab" },

	root_dir = bounded_root({ ".git", "startup.m", "matlab.prj", "SimulinkProject" }),

	settings = {
		MATLAB = {
			indexWorkspace = true,

			installPath = matlab_root or "",
			matlabConnectionTiming = matlab_available and "onStart" or "never",

			telemetry = false,
		},
	},
})

-- -----------------------------
-- Enable the servers
vim.lsp.enable({
	"html",
	"cssls",
	"bashls",
	"clangd",
	"ty",
})

if vim.fn.executable("matlab-language-server") == 1 then
	vim.lsp.enable("matlab_ls")
end
