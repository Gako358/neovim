{ config
, lib
, pkgs
, ...
}:
with lib;
with builtins; {
  options.vim.theme = {
    scheme = mkOption {
      type = types.enum [
        "github"
        "onedark"
        "kanagawa"
      ];
      default = "onedark";
      description = ''
        The color scheme to use for the visuals.
      '';
    };
  };

  imports = [
    ./github.nix
    ./onedark.nix
    ./kanagawa.nix
  ];
}
