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
  config = mkIf (cfg.scheme == "kanagawa") {
    vim.startPlugins = with pkgs.neovimPlugins; [ kanagawa ];

    vim.luaConfigRC = ''
      vim.cmd("colorscheme kanagawa")
    '';
  };
}
