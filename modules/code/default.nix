{ config
, lib
, pkgs
, ...
}: {
  imports = [
    ./cmp
    ./lsp
    ./telescope
    ./treesitter
  ];
}
