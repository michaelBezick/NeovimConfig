# Neovim configuration

Personal NvChad configuration for Neovim 0.12+.

## Python

[ty](https://docs.astral.sh/ty/) provides type diagnostics, completion, hover, and
navigation. It replaces Pyright; only one Python language server is enabled.
Install it separately from your project environments:

```sh
uv tool install ty
```

Open Neovim from the Python environment you want to use. ty discovers activated
virtual environments, Conda environments, or a project `.venv`. A stale
`VIRTUAL_ENV` pointing to a deleted directory is ignored for the server process.
Project settings belong in `ty.toml` or `[tool.ty]` in `pyproject.toml`.

Diagnostics refresh when you leave insert mode, and only errors are shown
inline. Diagnostics are limited to open files,
and Python, Lua, and MATLAB workspace roots are bounded to avoid scanning the
entire home directory. Use `:checkhealth vim.lsp` to inspect clients.

The ty executable is installed with uv; `uv tool upgrade ty` updates it.
Existing Mason installations of Pyright and Jedi can remain installed, but are
not started by this configuration.

## Plugins

Plugins are managed by lazy.nvim; `lazy-lock.json` pins their versions. Language
servers and formatters installed with Mason are available on Neovim's PATH.

Based on [NvChad](https://github.com/NvChad/NvChad) and its
[starter](https://github.com/NvChad/starter).

## Other tools and shortcuts

Python formatting (`<leader>fm`) uses isort followed by Black. Install isort with
`uv tool install isort` and Black with `:MasonInstall black` if missing. Other
formatters are Stylua, clang-format, and yamlfmt, available through Mason.

`<leader>gb` opens the Gitsigns blame view. `<leader>gg` opens Neogit.
Treesitter installs C, C++, CUDA, Python, MATLAB, and the configured markup/Lua
parsers. `clangd` is an LSP executable, not a Treesitter parser. Building parsers
requires the [`tree-sitter` CLI](https://github.com/tree-sitter/tree-sitter/releases)
(0.26.1+), a C compiler, `tar`, and `curl`.

Lua language services use NvChad's defaults. For MATLAB, install
`matlab-language-server` separately and set `MATLAB_ROOT` when MATLAB is not on
PATH. A missing MATLAB installation leaves the server disconnected from MATLAB;
a missing language server is not enabled.

Swap files live in Neovim's state directory (`:echo stdpath('state')`), so opening
files in new or read-only project directories does not require `.nvim-swap`.
