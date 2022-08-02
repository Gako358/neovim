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

    ./autopairs
    ./filetree
    ./bufferline
    ./lualine
    ./gitsigns
  ];
}
