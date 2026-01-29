return {
	{
		"stevearc/conform.nvim",
		-- event = "BufWritePre", -- uncomment for format on save
		opts = require("configs.conform"),
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
		end,
	},

	-- Neogit
	{
		"NeogitOrg/neogit",
		cmd = "Neogit",
		keys = {
			{ "<leader>gg", "<cmd>Neogit<CR>", desc = "Show Neogit UI" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional (diff integration)
			"nvim-telescope/telescope.nvim", -- optional (picker integration)
		},
		config = function()
			require("neogit").setup({
				integrations = {
					diffview = true,
					telescope = true,
				},
			})
		end,
	},

    -- lua/configs/gitsigns.lua (or wherever you override plugins)
  require("gitsigns").setup({
    current_line_blame = true, -- show blame for the line your cursor is on
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
      delay = 300,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> • <summary>",
  })

	
	-- {
	--   "nvim-treesitter/nvim-treesitter",
	--   opts = {
	--     ensure_installed = {
	--       "vim", "lua", "vimdoc",
	--       "html", "css", "clangd"
	--     },
	--   },
	-- },
}
