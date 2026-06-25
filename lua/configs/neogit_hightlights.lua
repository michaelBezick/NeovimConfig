-- ~/.config/nvim/lua/configs/neogit_highlights.lua

local function set_neogit_highlights()
  -- The "deleted" status word
  vim.api.nvim_set_hl(0, "NeogitChangeDeleted", {
    fg = "#ff6b6b",
    bold = true,
  })

  -- Deleted diff lines
  vim.api.nvim_set_hl(0, "NeogitDiffDelete", {
    fg = "#ff6b6b",
    bg = "#351a1a",
  })

  vim.api.nvim_set_hl(0, "NeogitDiffDeleteHighlight", {
    fg = "#ff8a8a",
    bg = "#452020",
  })

  vim.api.nvim_set_hl(0, "NeogitDiffDeleteCursor", {
    fg = "#ff8a8a",
    bg = "#552626",
  })

  -- Word-level deleted text inside a line
  vim.api.nvim_set_hl(0, "NeogitDiffDeleteInline", {
    fg = "#ffc0c0",
    bg = "#6b2a2a",
    bold = true,
  })

  -- Fallback for normal Vim diffs
  vim.api.nvim_set_hl(0, "DiffDelete", {
    fg = "#ff6b6b",
    bg = "#351a1a",
  })
end

set_neogit_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_neogit_highlights,
})
