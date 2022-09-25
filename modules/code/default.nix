{config, lib, pkgs, ...}:
{
  imports = [
    ./cmp
    ./lsp
    ./treesitter
  ];
}
