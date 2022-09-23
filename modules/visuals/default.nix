{ config
, lib
, pkgs
, ...
}:
with lib;
with builtins; {
  options.visuals = {
    theme = mkOption {
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
    ./onedarl.nix
  ];
}
