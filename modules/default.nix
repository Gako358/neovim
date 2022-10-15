{ config
, lib
, pkgs
, ...
}: {
  imports = [
    ./core
    ./basic

    ./theme
    ./treesitter
    ./telescope
    ./lsp

    ./cmp

    ./keys
    ./git
    ./visuals
  ];
}
