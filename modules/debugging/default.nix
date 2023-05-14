{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.debugging;
in {
  options.vim.debugging = {
    enable = mkEnableOption "Debug Adapter Protocol for Neovim";

    nvimDAP = mkOption {
      enable = mkOption {
        description = "Enable DAP for Neovim";
        type = types.bool;
      };
    };

    dapUI = mkOption {
      enable = mkOption {
        description = "Enable DAP UI";
        type = types.bool;
      };
    };

    javaDAP = mkOption {
      enable = mkOption {
        description = "Enable DAP for Java in Neovim";
        type = types.bool;
      };
      dapConfig = mkOption {
        description = "DAP configuration for Java";
        type = types.lines;
        default = ''
          local dap = require('dap')
          dap.adapters.java = function(callback)
            -- Insert function to trigger the `vscode.java.startDebugSession` LSP command
            -- The response to the command must be the `port` used below
            callback({
              type = 'server';
              host = '127.0.0.1';
              port = port;
            })
          end

          dap.configurations.java = {
            {
              classPaths = {},
              projectName = "yourProjectName",
              javaExec = "/path/to/your/bin/java",
              mainClass = "your.package.name.MainClassName",
              modulePaths = {},
              name = "Launch YourClassName",
              request = "launch",
              type = "java"
            },
          }
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.nvimDAP.enable {
      vim.startPlugins = ["nvim-dap" "nvim-dap-ui"];
      vim.luaConfigRC.nvim-dap = nvim.dag.entryAnywhere ''
        local dap = require('dap')
        require('dapui').setup {}
      '';
    })
    (mkIf cfg.javaDAP.enable {
      vim.luaConfigRC.java-dap = cfg.javaDAP.dapConfig;
    })
  ]);
}
