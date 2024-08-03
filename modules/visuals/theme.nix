{
  config,
  lib,
  ...
}:
with lib;
with lib.attrsets;
with builtins; let
  cfg = config.vim.visuals.theme;
in {
  options.vim.visuals.theme = {
    enable = mkEnableOption "themes";

    extraConfig = mkOption {
      description = "Additional lua configuration to add before setup";
      type = types.lines;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = ["rose-pine"];
    vim.luaConfigRC.themeSetup = nvim.dag.entryBefore ["rose-pine"] cfg.extraConfig;
    vim.luaConfigRC.theme =
      /*
      lua
      */
      ''
          require("rose-pine").setup({
              variant = "auto", -- auto, main, moon, or dawn
              dark_variant = "main", -- main, moon, or dawn
              dim_inactive_windows = false,
              extend_background_behind_borders = true,

              enable = {
              terminal = true,
              },

              styles = {
              bold = true,
              italic = true,
              transparency = true,
              },
          })

        vim.cmd("colorscheme rose-pine-moon")
      '';
  };
}
