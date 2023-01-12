{
  pkgs,
  config,
  lig,
  ...
}: {
  imports = [
    ./theme.nix
    ./supported_themes.nix
  ];
}
