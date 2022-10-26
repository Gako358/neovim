{ pkgs
, lib
, config
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.visuals.noice;
in
{
  options.vim.visuals.noice = {
    enable = mkOption {
      type = types.bool;
      description = "Enable noice plugin: [noice]";
    };
  };

  config = mkIf cfg.enable (
    let
      writeIf = cond: msg:
        if cond
        then msg
        else "";
    in
    {
      vim.startPlugins = with pkgs.neovimPlugins; [
        noice
        nui
        notify
      ];

      vim.luaConfigRC = ''
        require("noice").setup()
      '';
    }
  );
}
