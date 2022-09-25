{config, lib, pkgs, ...}:
{
  imports = [
    ./core
    ./basic

    ./treesitter
    ./telescope
    ./lsp

    ./cmp

    ./filetree
    ./bufferline
    ./lualine
    ./keys
    ./gitsigns
    ./visuals
  ];
}
