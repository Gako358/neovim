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
    ./config.nix
    ./visuals.nix
    ./winbar.nix
    ./lualine.nix
    ./statusline.nix
    ./bufferline.nix
  ];
}
