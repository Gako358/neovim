{
  config,
  lib,
  ...
}:
with lib;
with lib.attrsets;
with builtins; let
  cfg = config.vim.theme;
in {
  options.vim.theme = {
    enable = mkEnableOption "themes";

    extraConfig = mkOption {
      description = "Additional lua configuration to add before setup";
      type = types.lines;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = ["tokyonight"];
    vim.luaConfigRC.themeSetup = nvim.dag.entryBefore ["theme"] cfg.extraConfig;
    vim.luaConfigRC.theme =
      /*
      lua
      */
      ''
        -- Tokyo Night theme
        require('tokyonight').setup({
          style = "storm",
          light_style = "day",
          transparent = false,
          terminal_colors = true,
          styles = {
            comments = { italic = true },
            keywords = { italic = true },
            functions = {},
            variables = {},
            sidebars = "dark",
            floats = "dark",
          },
          sidebars = { "qf", "help" },
          day_brightness = 0.3,
          hide_inactive_statusline = false,
          dim_inactive = false,
          lualine_bold = false,
          on_colors = function(colors)
            colors.bg = "#272727"
            colors.bg_dark = "#262626"
          end,
          on_highlights = function(highlights, colors) end,
        })
        vim.cmd[[colorscheme tokyonight]]
      '';
  };
}

