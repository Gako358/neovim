{ config
, lib
, pkgs
, ...
}: {
  imports = [
    ./basic
    ./bufferline
    ./cmp
    ./core
    ./filetree
    ./gitsigns
    ./keys
    ./lsp
    ./lualine
    ./telescope
    ./theme
    ./treesitter
    ./visuals
  ];
}
