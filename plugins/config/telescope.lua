
local actions = require "telescope.actions"

require('telescope').setup{
  defaults = {
      prompt_prefix = '>',
      color_devicons = true,
      initial_mode = "insert",
      selection_strategy = "reset",
      sorting_strategy = "descending",
      file_ignore_patterns = {},
      path_display = { "absolute" },
      file_sorter = require("telescope.sorters").get_fuzzy_file,
      generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,

    -- Default configuration for telescope goes here:
    -- config_key = value,
    file_ignore_patterns = {
      '__pycache__',
      "node_modules",
      "vendor/",
    },
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
        ["<C-h>"] = "which_key"
      }
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    -- the default case_mode is "smart_case"
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
    },
  }
}

local M = {}

-- Vim config files
function M.vim_config()
  require("telescope.builtin").grep_string {
    results_title = "Neovim Configurations",
    path_display = { "smart" },
    search_dirs = {
      "~/.config/nvim/",
      "~/.config/nvim/lua/core/",
      "~/.config/nvim/lua/plugins/",
    },
  }
end

-- Projects folder
function M.list_projects()
  require("telescope.builtin").grep_string {
    results_title = "Project Folders",
    path_display = { "smart" },
    search_dirs = {
      "~/Projects/Scheme/",
      "~/Projects/Masterclass/",
    },
  }
end

-- Courses folder
function M.list_courses()
  require("telescope.builtin").grep_string {
    results_title = "Courses",
    path_display = { "smart" },
    search_dirs = {
      "~/Projects/Courses/",
    },
  }
end

-- Dotfiles config
function M.list_dotfiles()
  require("telescope.builtin").grep_string {
    results_title = "Dotfiles",
    path_display = { "smart" },
    search_dirs = {
      "~/.config/bspwm/",
      "~/.config/sxhkd/",
      "~/.config/polybar/",
    },
  }
end

return M
