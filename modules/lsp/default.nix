{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./lsp.nix
    ./lspsaga.nix
    ./lsp-signature.nix
    ./nvim-code-action-menu.nix
    ./trouble.nix
  ];
}
