{config, lib, pkgs, ...}:
{
  imports = [
    ./core
    ./basic
    ./theme
    ./lsp
    ./cmp
    ./treesitter
    ./snippets
  ];
}
