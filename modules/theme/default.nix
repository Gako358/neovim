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
    vim.startPlugins = ["borealis"];
    vim.luaConfigRC.themeSetup = nvim.dag.entryBefore ["theme"] cfg.extraConfig;
    vim.luaConfigRC.theme = ''
      -- Borealis theme
      require('borealis').load()
    '';
  };
}

