{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.org;
in {
  options.vim.languages.org = {
    enable = mkEnableOption "Org mode language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Org mode treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "org";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      vim = {
        startPlugins = ["orgmode" "org-roam"];
        treesitter = mkIf cfg.treesitter.enable {
          enable = true;
          grammars = [cfg.treesitter.package];
        };
        luaConfigRC = {
          orgmode-maps = nvim.dag.entryAnywhere ''
            if ${boolToString config.vim.keys.whichKey.enable} then
              local wk = require("which-key")
              wk.add({
                -- Org mode bindings
                { "<leader>o", group = "Org Mode" },
                { "<leader>oa", "<cmd>lua require('orgmode').action('agenda.prompt')<CR>", desc = "Org Agenda" },
                { "<leader>oc", "<cmd>lua require('orgmode').action('capture.prompt')<CR>", desc = "Org Capture" },

                -- Org Roam bindings
                { "<leader>n", group = "Org Roam" },
                -- Node operations
                { "<leader>naa", desc = "Add alias to node" },
                { "<leader>noa", desc = "Add origin to node" },
                { "<leader>nc", desc = "Open capture window" },
                { "<leader>n.", desc = "Complete at point" },
                { "<leader>nf", desc = "Find node" },
                { "<leader>nn", desc = "Go to next node" },
                { "<leader>np", desc = "Go to previous node" },
                { "<leader>ni", desc = "Insert node" },
                { "<leader>nm", desc = "Insert node immediate" },
                { "<leader>nq", desc = "Quickfix backlinks" },
                { "<leader>nar", desc = "Remove alias" },
                { "<leader>nor", desc = "Remove origin" },
                { "<leader>nl", desc = "Toggle roam buffer" },
                { "<leader>nb", desc = "Toggle fixed roam buffer" },
                -- Dailies
                { "<leader>nd", group = "Org Roam Dailies" },
                { "<leader>ndD", desc = "Capture date" },
                { "<leader>ndN", desc = "Capture today" },
                { "<leader>ndT", desc = "Capture tomorrow" },
                { "<leader>ndY", desc = "Capture yesterday" },
                { "<leader>nd.", desc = "Find directory" },
                { "<leader>ndd", desc = "Goto date" },
                { "<leader>ndf", desc = "Goto next date" },
                { "<leader>ndb", desc = "Goto previous date" },
                { "<leader>ndn", desc = "Goto today" },
                { "<leader>ndt", desc = "Goto tomorrow" },
                { "<leader>ndy", desc = "Goto yesterday" },
              })
            end
          '';
          orgmode = nvim.dag.entryAnywhere ''
            -- Setup orgmode
            require('orgmode').setup({
              org_agenda_files = "~/Documents/notes/work/**",
              org_default_notes_file = "~/Documents/notes/notes.org",
            })

            -- Setup org-roam
            require("org-roam").setup({
              directory = "~/Documents/notes/org_roam_files",
              org_files = {
                "~/Documents/notes/work/**",
                "~/Documents/notes/*.org",
              },
            })
          '';
        };
      };
    }
  ]);
}
