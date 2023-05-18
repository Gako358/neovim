{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.debugging;
in {
  options.vim.debugging = {
    enable = mkEnableOption "Debug Adapter Protocol for Neovim";

    dap = {
      enable = mkOption {
        description = "Enable DAP for Neovim";
        type = types.bool;
      };
    };

    dapUI = {
      enable = mkOption {
        description = "Enable DAP UI";
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.dap.enable {
      vim.startPlugins = ["nvim-dap"];
      vim.luaConfigRC.nvim-dap = nvim.dag.entryAnywhere ''
        local dap = require('dap')
      '';
    })
    (mkIf cfg.dapUI.enable {
      vim.startPlugins = ["nvim-dap-ui"];
      vim.luaConfigRC.nvim-dap-ui = nvim.dag.entryAnywhere ''
        local dapui = require('dapui')
        dapui.setup()
      '';
    })
  ]);
}
