{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./lsp.nix
    ./trouble.nix
    ./lightbulb.nix
    ./nvim-code-action-menu.nix
  ];
}
