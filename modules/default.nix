{config, lib, pkgs, ...}:
{
  imports = [
    ./basic
    ./bufferline
    ./code
    ./core
    ./filetree
    ./gitsigns
    ./keys
    ./lualine
    ./visuals
  ];
}
