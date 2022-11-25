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
      ];
      default = "statusline";
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
    ./noice.nix
    ./statusline.nix
    ./visuals.nix
    ./winbar.nix
  ];
}
