{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.theme;
in
{
  config = mkIf (cfg.scheme == "borealis") {
    vim.startPlugins = with pkgs.neovimPlugins; [ borealis ];

    vim.luaConfigRC = ''
      require('borealis').load()
    '';
  };
}
