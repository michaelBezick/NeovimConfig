require "nvchad.options"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.directory = "./.nvim-swap//"
vim.opt.clipboard = "unnamedplus"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*.pdf",
  callback = function()
    vim.defer_fn(function()
      pcall(vim.cmd, "PDFReader redrawPage")
    end, 50)
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = {
		"*.png",
		"*.jpg",
		"*.jpeg",
		"*.gif",
		"*.webp",
	},
	callback = function()
		vim.defer_fn(function()
			-- First let Neovim/Kitty finish drawing the window layout.
			pcall(vim.cmd, "redraw!")

			-- Then force image.nvim to render the image again.
			local ok, image = pcall(require, "image")
			if not ok then
				return
			end

			local win = vim.api.nvim_get_current_win()
			local buf = vim.api.nvim_get_current_buf()

			for _, img in ipairs(image.get_images({
				window = win,
				buffer = buf,
			})) do
				pcall(function()
					img:render()
				end)
			end
		end, 50)
	end,
})
