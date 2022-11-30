{ config
, lib
, pkgs
, ...
}:
with lib;
with builtins; {
  options.vim.visuals.status = {
    bar = mkOption {
      type = types.enum [
        "statusline"
        "lualine"
        "winbar"
        "none"
      ];
      default = "none";
      description = ''
        The bar to use for the statusline.
      '';
    };
  };
  imports = [
    ./bufferline.nix
    ./config.nix
    ./filetree.nix
    ./glow.nix
    ./lualine.nix
    ./nobar.nix
    ./noice.nix
    ./statusline.nix
    ./visuals.nix
    ./winbar.nix
  ];
}
