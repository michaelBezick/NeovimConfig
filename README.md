# Neovim configuration

Personal NvChad configuration for Neovim 0.11+.

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

Diagnostics are limited to open files, and workspace roots are bounded to avoid
scanning the entire home directory. Use `:checkhealth vim.lsp` to inspect clients.

The ty executable is installed with uv; `uv tool upgrade ty` updates it.
Existing Mason installations of Pyright and Jedi can remain installed, but are
not started by this configuration.

## Plugins

Plugins are managed by lazy.nvim; `lazy-lock.json` pins their versions. Language
servers and formatters installed with Mason are available on Neovim's PATH.

Based on [NvChad](https://github.com/NvChad/NvChad) and its
[starter](https://github.com/NvChad/starter).
