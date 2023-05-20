{lib, ...}:
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
  };
}
