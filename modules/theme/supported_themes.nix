{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with builtins; let
  themeSubmodule.options = {
    setup = mkOption {
      description = "Lua code to initialize theme";
      type = types.str;
    };
    styles = mkOption {
      description = "The available styles for the theme";
      type = with types; nullOr (listOf str);
      default = null;
    };
    defaultStyle = mkOption {
      description = "The default style for the theme";
      type = types.str;
    };
  };

  cfg = config.vim.theme;
  style = cfg.style;
in {
  options.vim.theme = {
    supportedThemes = mkOption {
      description = "Supported themes";
      type = with types; attrsOf (submodule themeSubmodule);
    };
  };

  config.vim.theme.supportedThemes = {
    borealis = {
      setup = ''
        -- Borealis theme
        require('borealis').load()
      '';
    };

    onedark = {
      setup = ''
        -- OneDark theme
        require('onedark').setup {
          style = "${cfg.style}"
        }
        require('onedark').load()
      '';
      styles = ["dark" "darker" "cool" "deep" "warm" "warmer"];
      defaultStyle = "dark";
    };

    tokyonight = {
      setup = ''
        -- need to set style before colorscheme to apply
        vim.g.tokyonight_style = '${cfg.style}'
        vim.cmd[[colorscheme tokyonight]]
      '';
      styles = ["day" "night" "storm"];
      defaultStyle = "night";
    };
  };
}
