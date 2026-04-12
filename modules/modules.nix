{
  pkgs,
  lib,
  check ? true,
}:
let
  modules = [
    ./languages
    ./lsp
    ./basic.nix
    ./completion.nix
    ./core.nix
    ./debug.nix
    ./git.nix
    ./keys.nix
    ./picker.nix
    ./terminal.nix
    ./theme.nix
    ./treesitter.nix
    ./visual.nix
  ];

  pkgsModule = {
    config = {
      _module = {
        args = {
          baseModules = modules;
          pkgsPath = lib.mkDefault pkgs.path;
          pkgs = lib.mkDefault pkgs;
        };
        inherit check;
      };
    };
  };
in
modules ++ [ pkgsModule ]
