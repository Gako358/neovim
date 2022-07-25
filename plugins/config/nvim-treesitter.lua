-----------------------------------------------------------
-- Treesitter configuration file
----------------------------------------------------------

-- Plugin: nvim-treesitter
-- url: https://github.com/nvim-treesitter/nvim-treesitter

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    vim.g.enable_treesitter_ft,
    'typescript',
    'javascript',
    'comment',
    'python',
    'bibtex',
    'html',
    'bash',
    'make',
    'json',
    'rust',
    'vim',
    'lua',
    'css',
    'cpp',
    'c',
  },
  highlight = {
    enable = true,
  },
  matchup = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["al"] = "@call.outer",
        ["il"] = "@call.inner",
      },
    },
  },
})
