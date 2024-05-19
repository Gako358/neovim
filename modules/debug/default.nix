{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.debug;
in {
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
      vim.startPlugins = ["nvim-dap"];

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

          vim.keymap.set("n", "<leader>do", dap.repl.open)
          vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
          vim.keymap.set("n", "<leader>dm", dap.run_to_cursor)
          vim.keymap.set("n", "<leader>dB", function() require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
          vim.keymap.set("n", "<leader>dp", function() require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)

          vim.keymap.set("n", "<F9>", dap.continue)
          vim.keymap.set("n", "<F10>", dap.step_into)
          vim.keymap.set("n", "<F11>", dap.step_over)
          vim.keymap.set("n", "<F8>", dap.step_out)
          vim.keymap.set("n", "<F7>", dap.restart)
        '';
    }
    (mkIf cfg.virtualText.enable {
      vim.startPlugins = ["nvim-dap-virtual-text"];

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
      vim.startPlugins = ["nvim-dap-ui"];

      vim.luaConfigRC.dap-ui = nvim.dag.entryAfter ["dap-setup"] ((
          /*
          lua
          */
          ''
            local dapui = require"dapui"

            dapui.setup()
            vim.keymap.set("n", "<leader>du", dapui.toggle)
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
