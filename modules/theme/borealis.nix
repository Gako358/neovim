{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.theme;
in {
  config = mkIf (cfg.scheme == "borealis") {
    vim.startPlugins = with pkgs.neovimPlugins; [github-nvim-theme];

    vim.luaConfigRC = ''
      vim.cmd[[colorscheme tokyonight]]
    '';
  };
}
