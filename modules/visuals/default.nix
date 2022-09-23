{ config
, lib
, pkgs
, ...
}: {
  options.visuals.theme = {
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
    ./onedarl.nix
  ];
}
