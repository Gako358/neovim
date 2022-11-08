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
        red = '#ca1243',
        grey = '#a0a1a7',
        black = '#383a42',
        white = '#dcd7ba',
        light_green = '#83a598',
        orange = '#fe8019',
        green = '#8ec07c',
        dark = '#272727',
        blue = '#2D4F67',
      }

      local theme = {
        normal = {
          a = { fg = colors.white, bg = colors.blue },
          b = { fg = colors.dark, bg = colors.grey },
          c = { fg = colors.white, bg = colors.dark },
          z = { fg = colors.white, bg = colors.blue },
        },
        insert = { a = { fg = colors.black, bg = colors.light_green } },
        visual = { a = { fg = colors.black, bg = colors.orange } },
        replace = { a = { fg = colors.black, bg = colors.green } },
      }

      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = theme,
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {},
            winbar = {},
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
