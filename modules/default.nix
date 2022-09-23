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

    ./filetree
    ./bufferline
    ./lualine
    ./keys
    ./toggleterm
    ./gitsigns
    ./visuals
  ];
}
