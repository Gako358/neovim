{ config
, lib
, pkgs
, ...
}: {
  imports = [
    ./bufferline
    ./lualine
  ];
}
