{
  pkgs,
  lib,
  check ? true,
}: let
  modules = [
    ./languages
    ./lsp
    ./basic.nix
    ./completion.nix
    ./core.nix
    ./debug.nix
    ./fzf.nix
    ./git.nix
    ./keys.nix
    ./terminal.nix
    ./treesitter.nix
    ./visual.nix
  ];

  pkgsModule = {config, ...}: {
    config = {
      _module.args.baseModules = modules;
      _module.args.pkgsPath = lib.mkDefault pkgs.path;
      _module.args.pkgs = lib.mkDefault pkgs;
      _module.check = check;
    };
  };
in
  modules ++ [pkgsModule]
