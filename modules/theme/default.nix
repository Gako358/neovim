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
        "borealis"
        "kanagawa"
        "onedark"
      ];
      default = "onedark";
      description = ''
        The color scheme to use for the visuals.
      '';
    };
  };

  imports = [
    ./borealis.nix
    ./kanagawa.nix
    ./onedark.nix
  ];
}
