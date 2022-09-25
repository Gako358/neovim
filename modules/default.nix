{config, lib, pkgs, ...}:
{
  imports = [
    ./basic
    ./bufferline
    ./code
    ./core
    ./filetree
    ./git
    ./keys
    ./lualine
    ./telescope
    ./visuals
  ];
}
