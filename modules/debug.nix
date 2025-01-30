{ config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.debug;
in
{
  options.vim.debug = {
    enable = mkEnableOption "DAP debugger, also enabled automatically through language options";

    ui = {
      enable = mkEnableOption "a UI for nvim-dap (nvim-dap-ui)";

      autoOpen = mkOption {
        description = "automa open/close the ui when dap starts/ends";
        type = types.bool;
        default = true;
      };
    };

    virtualText.enable = mkEnableOption "virtual text for dap";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      vim.startPlugins = [ "nvim-dap" ];

      vim.luaConfigRC.dap-setup =
        nvim.dag.entryAnywhere
          /*
            lua
          */
          ''
            local dap = require('dap')

            -- JAVA
            dap.configurations.java = {
              {
                type = "java",
                request = "attach",
                name = "Debug (Attach) - Remote",
                hostName = "127.0.0.1",
                port = 8000,
              },
            }

            -- Scala DAP configurations
            dap.configurations.scala = {
              {
                type = "scala",
                request = "launch",
                name = "Run or Test Target",
                metals = {
                  runType = "runOrTestFile",
                },
              },
              {
                type = "scala",
                request = "launch",
                name = "Test Target",
                metals = {
                  runType = "testTarget",
                },
              },
            }

            -- Debug keymaps with which-key integration
            if ${boolToString config.vim.keys.whichKey.enable} then
              local wk = require("which-key")
              wk.add({
                { "<leader>d", group = "Debug" },
                { "<leader>do", dap.repl.open, desc = "Open REPL" },
                { "<leader>db", dap.toggle_breakpoint, desc = "Toggle Breakpoint" },
                { "<leader>dm", dap.run_to_cursor, desc = "Run to Cursor" },
                { "<leader>dB", function()
                  require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))
                end, desc = "Set Conditional Breakpoint" },
                { "<leader>dp", function()
                  require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
                end, desc = "Set Log Point" },

                -- Function key mappings
                { "<F9>", dap.continue, desc = "Continue" },
                { "<F10>", dap.step_into, desc = "Step Into" },
                { "<F11>", dap.step_over, desc = "Step Over" },
                { "<F8>", dap.step_out, desc = "Step Out" },
                { "<F7>", dap.restart, desc = "Restart" },
              })
            end
          '';
    }
    (mkIf cfg.virtualText.enable {
      vim.startPlugins = [ "nvim-dap-virtual-text" ];

      vim.luaConfigRC.dap-virtual-text =
        nvim.dag.entryAnywhere
          /*
        lua
          */
          ''
            require("nvim-dap-virtual-text").setup()
          '';
    })
    (mkIf cfg.ui.enable {
      vim.startPlugins = [ "nvim-dap-ui" ];

      vim.luaConfigRC.dap-ui = nvim.dag.entryAfter [ "dap-setup" ] ((
        /*
          lua
          */
        ''
          local dapui = require"dapui"

          dapui.setup()
          if ${boolToString config.vim.keys.whichKey.enable} then
            local wk = require("which-key")
            wk.add({
              { "<leader>du", dapui.toggle, desc = "Toggle DAP UI" },
            })
          end
        ''
      )
      + (optionalString cfg.ui.autoOpen
        /*
          lua
          */
        ''
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        ''));
    })
  ]);
}
