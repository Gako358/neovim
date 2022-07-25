----------------------------------------------------------
-- Vista (tagbar) configuration file
-----------------------------------------------------------

-- Plugin: vista.vim
-- url: https://github.com/liuchengxu/vista.vim


local g = vim.g
local cmd = vim.cmd

-- How each level is indented and what to prepend.
--- This could make the display more compact or more spacious.
--- e.g., more compact: ["▸ ", ""]
--- Note: this option only works for the kind renderer, not the tree renderer
g.vista_icon_indent = '["╰─▸ ", "├─▸ "]'

-- Executive used when opening vista sidebar without specifying it.
--- See all the avaliable executives via `:echo g:vista#executives`.
g.vista_default_executive = 'ctags'

-- Ensure you have installed some decent font to show these pretty symbols,
--- then you can enable icon for the kind.
cmd [[let g:vista#renderer#enable_icon = 1]]


-- Change some default icons
--- see: https://github.com/slavfox/Cozette/blob/master/img/charmap.txt
cmd [[
  let g:vista#renderer#icons = {
  \   "function": "\u0192",
  \   "variable": "\uf00d",
  \   "prototype": "\uf013",
  \   "macro": "\uf00b",
  \ }
]]

