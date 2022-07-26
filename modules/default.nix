{config, lib, pkgs, ...}:
{
  imports = [
    ./core
    ./basic
    ./themes
    ./dashboard
    ./statusline
    ./lsp
    ./fuzzyfind
    ./filetree
    ./git
    ./formating
    ./editor
    ./test
  ];
}
