{ config
, lib
, pkgs
, ...
}: {
  imports = [
    ./basic
    ./code
    ./core
    ./git
    ./keys
    ./status
    ./visuals
  ];
}
