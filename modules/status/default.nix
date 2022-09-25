{ config
, lib
, pkgs
, ...
}: {
  imports = [
    ./bufferline
    ./filetree
    ./lualine
  ];
}
