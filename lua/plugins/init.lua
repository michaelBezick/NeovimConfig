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
