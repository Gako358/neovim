-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Change leader to a comma
vim.g.mapleader = ','

-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------

-- Resize splits
map('n', '<A-Up>', ':resize -1<CR>')
map('n', '<A-Down>', ':resize +1<CR>')
map('n', '<A-Left>', ':vertical resize -1<CR>')
map('n', '<A-Right>', ':vertical resize +1<CR>')
map('n', '<leader>=', '<C-w>=')

-- Clear search highlighting with <leader> and c
map('n', '<leader>c', ':nohl<CR>')

-- Map Esc to kk
map('i', 'kj', '<Esc>')
map('i', 'jk', '<Esc>')

-- Don't use arrow keys
map('', '<up>', '<nop>')
map('', '<down>', '<nop>')
map('', '<left>', '<nop>')
map('', '<right>', '<nop>')

-- Fast saving with <leader> and s
map('n', '<leader>s', ':w<CR>')
map('i', '<leader>s', '<C-c>:w<CR>')

-- Move around splits using Ctrl + {h,j,k,l}
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Buffer Navigation
map('n', '<leader>d', ':BufferLineCycleNext<CR>')
map('n', '<leader>a', ':BufferLineCyclePrev<CR>')
map('n', '<leader>bd', ':BufferLineSortByDirectory<CR>')
map('n', '<leader>bq', ':bd!<CR>')

-- Buffer Number
map('n', '<leader>1', '<cmd>BufferLineGoToBuffer 1<CR>')
map('n', '<leader>2', '<cmd>BufferLineGoToBuffer 2<CR>')
map('n', '<leader>3', '<cmd>BufferLineGoToBuffer 3<CR>')
map('n', '<leader>4', '<cmd>BufferLineGoToBuffer 4<CR>')
map('n', '<leader>5', '<cmd>BufferLineGoToBuffer 5<CR>')
map('n', '<leader>6', '<cmd>BufferLineGoToBuffer 6<CR>')
map('n', '<leader>7', '<cmd>BufferLineGoToBuffer 7<CR>')
map('n', '<leader>8', '<cmd>BufferLineGoToBuffer 8<CR>')
map('n', '<leader>9', '<cmd>BufferLineGoToBuffer 9<CR>')

-- Close all windows and exit from Neovim with <leader> and q
map('n', '<leader>q', ':qa!<CR>')

-- Spell Checking
map('n', '<F7>', ':setlocal spell spelllang=en_us<CR>')

-- Lsp Config
map('n', '<F8>', ':LspInfo<CR>')
map('n', '<F9>', ':LspStart<CR>')

-----------------------------------------------------------
-- Applications and Plugins shortcuts
-----------------------------------------------------------

-- Terminal mappings
map('n', '<C-t>', ':Term<CR>', { noremap = true })  -- open
map('t', '<Esc>', '<C-\\><C-n>')                    -- exit

-- Vista tag-viewer
map('n', '<C-m>', ':Vista!!<CR>') -- open/close

-- NvimTree
map('n', '<C-space>', ':NvimTreeToggle<CR>')            -- open/close
map('n', '<leader>r', ':NvimTreeRefresh<CR>')       -- refresh
map('n', '<leader>n', ':NvimTreeFindFile<CR>')      -- search file

-- Lazygit
map('n', '<leader>l', [[<cmd>LazyGit<CR>]])

-- Sessions
map('n', '<leader>so', ':OpenSession<Space>')
map('n', '<leader>ss', ':SaveSession<Space>')
map('n', '<leader>sd', ':DeleteSession<CR>')
map('n', '<leader>sc', ':CloseSession<CR>')

-- Telescope
map('n', '<leader>ff', '<cmd>Telescope find_files<CR>')
map('n', '<leader>fg', '<cmd>Telescope live_grep<CR>')
map('n', '<leader>fs', '<cmd>Telescope git_status<CR>')
map('n', '<leader>fc', '<cmd>Telescope git_commits<CR>')

-- Telescope Neovim Source
map('n', '<leader>fn', [[<Cmd>lua require'plugins.config.telescope'.vim_config()<CR>]], { noremap = true, silent = true })
-- Telescope Projects
map('n', '<leader>fp', [[<Cmd>lua require'plugins.config.telescope'.list_projects()<CR>]], { noremap = true, silent = true })
-- Telescope Courses
map('n', '<leader>fk', [[<Cmd>lua require'plugins.config.telescope'.list_courses()<CR>]], { noremap = true, silent = true })
-- Telescope Dotfiles
map('n', '<leader>fd', [[<Cmd>lua require'plugins.config.telescope'.list_dotfiles()<CR>]], { noremap = true, silent = true })

-- VimTeX
map('n', '<leader>lp', ':VimtexCompile<CR>')
map('n', '<leader>lv', ':VimtexView<CR>')

-- Copilot
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })


-- Debugg
-- vim.cmd("au InsertChange * lua require('copilot.utils').send_completion_request()")
