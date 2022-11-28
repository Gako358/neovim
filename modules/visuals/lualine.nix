{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.visuals.status;
in
{
  config = mkIf (cfg.bar == "lualine") {
    vim.startPlugins = with pkgs.neovimPlugins; [ lualine ];

    vim.luaConfigRC = ''
      local colors = {
        gray     = '#3C3C3C',
        lightred = '#D16969',
        blue     = '#569CD6',
        pink     = '#C586C0',
        black    = '#262626',
        white    = '#D4D4D4',
        green    = '#608B4E',
      }

      local theme = {
        normal = {
          a = { fg = colors.black, bg = colors.blue, gui = 'bold' },
          b = { fg = colors.white, bg = colors.black },
          c = { fg = colors.white, bg = colors.black },
        },
        insert = {
          a = { fg = colors.black, bg = colors.green, gui = 'bold' },
          b = { fg = colors.white, bg = colors.black },
          c = { fg = colors.white, bg = colors.black },
        },
        visual = {
          a = { fg = colors.black, bg = colors.pink, gui = 'bold' },
          b = { fg = colors.white, bg = colors.black },
          c = { fg = colors.white, bg = colors.black },
        },
        replace = {
          a = { fg = colors.black, bg = colors.lightred, gui = 'bold' },
          b = { fg = colors.white, bg = colors.black },
          c = { fg = colors.white, bg = colors.black },
        },
        command = {
          a = { fg = colors.black, bg = colors.gray, gui = 'bold' },
          b = { fg = colors.white, bg = colors.black },
          c = { fg = colors.white, bg = colors.black },
        },
      }

      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = theme,
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = { 'NvimTree' },
            winbar = { 'NvimTree' },
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {
          'nvim-tree',
          'toggleterm'
        }
      }
    '';
  };
}
