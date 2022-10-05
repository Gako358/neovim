{ config
, lib
, pkgs
, ...
}: {
  imports = [
    ./config.nix
    ./visuals.nix
    ./statusline.nix
  ];
}
