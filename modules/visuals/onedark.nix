{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.visuals.theme;
in
{
  config = mkIf (cfg.scheme == "onedark") {
    vim.startPlugins = with pkgs.neovimPlugins; [ onedark ];

    vim.luaConfigRC = ''
      require('onedark').setup  {
          -- Main options --
          style = 'darker', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
          transparent = false,  -- Show/hide background
          term_colors = true, -- Change terminal color as per the selected theme style
          ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
          cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

          -- toggle theme style ---
          toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
          toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between

          -- Change code style ---
          -- Options are italic, bold, underline, none
          -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
          code_style = {
              comments = 'italic',
              keywords = 'none',
              functions = 'none',
              strings = 'none',
              variables = 'none'
          },

          -- Custom Highlights --
          colors = {
            bg0 = "#282828",
            purple = "#ff00aa",
            yellow = "#FFE66D",
            blue = "#7cb7ff",
            red = "#ee5d43",
            green = "#96E072",
            cyan = "#00e8c6",
          }, -- Override default colors
          highlights = {}, -- Override highlight groups

          -- Plugins Config --
          diagnostics = {
              darker = true, -- darker colors for diagnostic
              undercurl = true,   -- use undercurl instead of underline for diagnostics
              background = false,    -- use background color for virtual text
          },
      }
      require('onedark').load()
    '';
  };
}
