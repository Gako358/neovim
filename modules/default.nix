{config, lib, pkgs, ...}:
{
  imports = [
    ./core
    ./basic

    ./theme
    ./treesitter
    ./telescope
    ./lsp

    ./cmp

    ./bufferline
    ./keys
    ./gitsigns
    ./visuals
  ];
}
