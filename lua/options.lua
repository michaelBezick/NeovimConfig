require("nvchad.options")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

-- Keep swap files available without creating directories in every project.
local swap_dir = vim.fn.stdpath("state") .. "/swap"
vim.fn.mkdir(swap_dir, "p")
vim.opt.directory = swap_dir .. "//"

-- Language servers can be chatty on stderr; start over once the log gets large.
local lsp_log = vim.lsp.log.get_filename()
local lsp_log_stat = vim.uv.fs_stat(lsp_log)
if lsp_log_stat and lsp_log_stat.size > 5 * 1024 * 1024 then
	vim.fn.delete(lsp_log)
end

local previews = vim.api.nvim_create_augroup("UserPreviewRedraw", { clear = true })

local function redraw_preview(args)
	local win = vim.api.nvim_get_current_win()
	vim.defer_fn(function()
		-- A quick buffer switch must not redraw a different preview 50 ms later.
		if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= args.buf then
			return
		end
		vim.api.nvim_win_call(win, function()
			if args.match:lower():match("%.pdf$") then
				pcall(vim.cmd, "PDFReader redrawPage")
				return
			end

			pcall(vim.cmd, "redraw!")
			local ok, image = pcall(require, "image")
			if not ok then
				return
			end
			for _, img in ipairs(image.get_images({ window = win, buffer = args.buf })) do
				pcall(function()
					img:render()
				end)
			end
		end)
	end, 50)
end

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = previews,
	pattern = { "*.pdf", "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
	callback = redraw_preview,
})
