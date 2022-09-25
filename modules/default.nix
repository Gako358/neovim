{config, lib, pkgs, ...}:
{
  imports = [
    ./basic
    ./code
    ./core
    ./filetree
    ./gitsigns
    ./keys
    ./status
    ./visuals
  ];
}
