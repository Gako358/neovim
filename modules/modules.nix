{
  pkgs,
  lib,
  check ? true,
}: let
  modules = [
    ./autopairs
    ./basic
    ./build
    ./completion
    ./core
    ./debugging
    ./filetree
    ./git
    ./keys
    ./languages
    ./lsp
    ./snippets
    ./statusline
    ./telescope
    ./theme
    ./treesitter
    ./visuals
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
