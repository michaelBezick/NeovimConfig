require("nvchad.mappings")

-- Add your custom mappings here
local map = vim.keymap.set

-- General
-- map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Jump next in jump list
map("n", "<C-p>", "<C-i>", { desc = "Jump next in jump list", noremap = true, silent = true })

-- Telescope LSP symbols
map("n", "<leader>fds", function()
	require("telescope.builtin").lsp_dynamic_workspace_symbols()
end, { desc = "Find Dynamic Workspace Symbols", noremap = true, silent = true })

map("n", "<leader>fs", function()
	require("telescope.builtin").lsp_workspace_symbols()
end, { desc = "Find Workspace Symbols", noremap = true, silent = true })

-- Find classes with Telescope
map("n", "<leader>fc", function()
	require("telescope.builtin").lsp_document_symbols({ symbols = "class" })
end, { desc = "Find Classes" })

-- Find diagnostics with Telescope
map("n", "<leader>fd", function()
	require("telescope.builtin").diagnostics()
end, { desc = "Find Diagnostics" })

-- Find functions and methods with Telescope
map("n", "<leader>fn", function()
	require("telescope.builtin").lsp_document_symbols({ symbols = { "function", "method" } })
end, { desc = "Find Functions", noremap = true, silent = true })

-- Format using Conform
map("n", "<leader>fm", function()
	require("conform").format()
end, { desc = "Format Code" })

-- Visual mode better indenting
map("v", ">", ">gv", { desc = "Indent in visual mode" })

-- Toggle the blame panel in the current tab, from either pane.
map("n", "<leader>gb", function()
	local closed = false
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "gitsigns-blame" then
			vim.api.nvim_win_close(win, false)
			closed = true
		end
	end
	if not closed then
		require("gitsigns").blame()
	end
end, { desc = "Toggle Git Blame" })

-- Toggle Markdown preview
map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", {
	desc = "Toggle Markdown Preview",
	noremap = true,
	silent = true,
})
