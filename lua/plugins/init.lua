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
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"vim",
				"lua",
				"vimdoc",
				"html",
				"css",
				"clangd",
				"python",
				"matlab",
			},
		},
	},
	{
		"sphamba/smear-cursor.nvim",
		event = "VeryLazy",
		main = "smear_cursor",
		opts = {
			smear_between_buffers = true,
			smear_between_neighbor_lines = true,
			scroll_buffer_space = true,
			legacy_computing_symbols_support = false,
			smear_insert_mode = true,
		},
	},
	{
		"karb94/neoscroll.nvim",
		event = "VeryLazy",
		config = function()
			require("neoscroll").setup({
				mappings = {
					"<C-u>",
					"<C-d>",
					"<C-b>",
					"<C-f>",
					"zt",
					"zz",
					"zb",
				},

				hide_cursor = true,
				stop_eof = true,
				easing = "sine",

				-- Good starting speed
				duration_multiplier = 1.0,
			})
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		{
			"r-pletnev/pdfreader.nvim",
			lazy = false,
			dependencies = {
				"folke/snacks.nvim",
				"nvim-telescope/telescope.nvim",
			},
			config = function()
				require("pdfreader").setup()
			end,
		},
	},
	{
		"3rd/image.nvim",
		lazy = false,
		priority = 1000,
		build = false,

		opts = {
			backend = "kitty",
			processor = "magick_cli",

			integrations = {
				markdown = {
					enabled = false,
				},
				neorg = {
					enabled = false,
				},
			},

			max_width_window_percentage = 90,
			max_height_window_percentage = 90,

			hijack_file_patterns = {
				"*.png",
				"*.jpg",
				"*.jpeg",
				"*.gif",
				"*.webp",
			},
		},
	},
}
