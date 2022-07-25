-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------
-- Core plugins
local core = {

  -- cache everything!
  {
    "lewis6991/impatient.nvim",
  },

  {
    "nathom/filetype.nvim",
    config = function()
      require("filetype").setup({
        -- overrides the filetype or function for filetype
        -- See https://github.com/nathom/filetype.nvim#customization
        overrides = {},
      })
    end,
  },

  -- Dashboard (start screen)
  {
    'goolord/alpha-nvim',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require("plugins").load_cfg("alpha-nvim")
    end,
  },

  -- File explorer
  {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require("plugins").load_cfg("nvim-tree")
    end,
  },

  -- Editing multi cursor
  {
    'mg979/vim-visual-multi',
  },

  -- Surrounding select text with signs
  {
    'tpope/vim-surround',
  },

  -- Commentary
  {
    "terrortylor/nvim-comment",
    config = function()
      require('nvim_comment').setup()
    end,
  },

  -- Sessions
  {
    'xolox/vim-session',
    requires = {
      'xolox/vim-misc',
    },
  },

  -- Notify
  {
    'rcarriga/nvim-notify',
  },
}

-- Style and colorscheme plugins
local style = {

  -- Color schemes
  {
    'EdenEast/nightfox.nvim',
  },

  -- Bufferline
  {
    'akinsho/bufferline.nvim',
    tag = "*",
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require("plugins").load_cfg("bufferline")
    end,
  },

  -- Statusline
  {
    'feline-nvim/feline.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require("plugins").load_cfg("feline")
    end,
  },
}

-- Plugins for code completion
local completion = {

  -- Treesitter interface
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require("plugins").load_cfg("nvim-treesitter")
    end,
  },

  -- Indent line
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require("plugins").load_cfg("indent-blankline")
    end,
  },

  -- Autopair
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end
  },

  -- LSP Installer
  {
    'williamboman/nvim-lsp-installer',
    ft = vim.g.enable_lspconfig_ft,
    config = function()
      require("lspconfig")
    end,
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    config = function()
      require("plugins").load_cfg("nvim-lspconfig")
    end,
    module = "lspconfig",
  },

  -- Motion Movement
  {
    'ggandor/lightspeed.nvim',
  },

  -- Github copilot AI engine
  -- Need to be initialized first to build .config/github-copilot/
  -- Can comment out github copilot when not needed
  {
    'github/copilot.vim',
  },

  -- Autocomplete
  {
    'hrsh7th/nvim-cmp',
    requires = {
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      require("plugins").load_cfg("nvim-cmp")
    end,
  },

  -- Tag viewer
  {
    'liuchengxu/vista.vim',
    config = function()
      require("plugins").load_cfg("vista")
    end,
  },

  -- Find files
  {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require("plugins").load_cfg("telescope")
    end,
  },

  -- Latex
  {
    'lervag/vimtex',
  },

  -- git labels
  {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require("plugins").load_cfg("gitsigns")
    end,
  },

  -- lazygit terminal ui
  {
    "kdheepak/lazygit.nvim",
    setup = function()
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 1
      vim.g.lazygit_floating_window_corner_chars = {
        "╭",
        "╮",
        "╰",
        "╯",
      }
      vim.g.lazygit_floating_window_use_plenary = 0
      vim.g.lazygit_use_neovim_remote = 1
      if vim.g.lazygit_use_neovim_remote == 1 and vim.fn.executable("nvr") then
        vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
      end
    end,
    cmd = "LazyGit",
  },
}

return {
  core,
  style,
  completion,
}

