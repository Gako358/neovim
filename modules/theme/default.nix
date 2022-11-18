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
      ];
      default = "borealis";
      description = ''
        The color scheme to use for the visuals.
      '';
    };
  };

  imports = [
    ./borealis.nix
  ];
}
