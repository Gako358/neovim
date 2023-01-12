{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./gitsigns.nix
    ./lazygit.nix
  ];
}
