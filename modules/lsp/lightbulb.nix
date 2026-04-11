{ config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp;
in
{
  options.vim.lsp = {
    lightbulb = {
      enable = mkEnableOption "lightbulb for code actions. Requires emoji font";
    };
  };

  config = mkIf (cfg.enable && cfg.lightbulb.enable) {
    vim = {
      startPlugins = [ "nvim-lightbulb" ];

      luaConfigRC.lightbulb =
        nvim.dag.entryAnywhere
          /*
        lua
          */
          ''
            -- Enable lightbulb for code actions
            require'nvim-lightbulb'.setup({
              autocmd = { enabled = true }
            })
          '';
    };
  };
}
