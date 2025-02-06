{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.theme;
in {
  options.vim.theme = {
    enable = mkEnableOption "Theme configuration.";
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = ["theme"];

    vim.luaConfigRC.nightfox =
      nvim.dag.entryAnywhere
      /*
      lua
      */
      ''
        require('nightfox').setup({
          options = {
            transparent = true,
            styles = {
              comments = "italic",
              strings = "italic",
            },
          },
          palettes = {
            nightfox = {
              bg0 = "None",
              bg1 = "None",
              bg2 = "None",
              bg3 = "None",
              bg4 = "None",
              sel0 = "None",
              sel1 = "#3c5372",
            },
          },
          groups = {
            nightfox = {
              WinSeperator = { fg = "None" },
              NormalFloat = { bg = "None" },
              StatusLine = { bg = "None" },
              StatusLineNC = { bg = "None" },
              TabLineFill = { bg = "None" },
              WinBarNC = { bg = "None" },
              Visual = { bg = "#3c5372" },
            },
          },
        })
        vim.cmd("colorscheme nightfox")
      '';
  };
}
