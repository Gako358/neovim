{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./lazygit.nix
    ./gitsigns.nix
  ];
}
