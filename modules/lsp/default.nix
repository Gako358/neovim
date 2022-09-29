{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./lsp.nix
    ./trouble.nix
    ./lspsaga.nix
    ./lightbulb.nix
    ./lsp-signature.nix
    ./nvim-code-action-menu.nix
  ];
}
