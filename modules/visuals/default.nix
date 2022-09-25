{ config
, lib
, pkgs
, ...
}:
with lib;
with builtins; {
  options.vim.visuals.theme = {
    scheme = mkOption {
      type = types.enum [
        "github"
        "onedark"
        "gruvbox"
        "kanagawa"
        "tokyonight"
      ];
      default = "onedark";
      description = ''
        The color scheme to use for the visuals.
      '';
    };
  };

  imports = [
    ./config.nix
    ./visuals.nix
    ./github.nix
    ./onedark.nix
    ./gruvbox.nix
    ./kanagawa.nix
    ./tokyonight.nix
  ];
}
