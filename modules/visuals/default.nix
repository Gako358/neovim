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
        "onedark"
        "gruvbox"
        "github"
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
    ./onedark.nix
  ];
}
