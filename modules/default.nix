{config, lib, pkgs, ...}:
{
  imports = [
    ./core
    ./basic
    ./theme

    ./treesitter
    ./lsp

    ./cmp

    #./autopairs
    ./filetree
    ./bufferline
  ];
}
