{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.note;
in {
  options.vim.note = {
    enable = mkEnableOption "enable note taking in nvim";
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = [
      "obsidian"
    ];

    vim.luaConfigRC.sql =
      nvim.dag.entryAnywhere
      /*
      lua
      */
      ''
        vim.api.nvim_set_keymap('n', '<leader>on', '<cmd>ObsidianNew<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>of', '<cmd>ObsidianSearch<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>ow', '<cmd>ObsidianWorkspace<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>og', '<cmd>ObsidianFollowLink<CR>', { noremap = true, silent = true })

        require("obsidian").setup({
              workspaces = {
                {
                  name = "personal",
                  path = "~/Documents/notes/private",
                },
                {
                  name = "work",
                  path = "~/Documents/notes/work",
                },
              },
              completion = {
                  nvim_cmp = true,
                  min_chars = 2,
              },
              mappings = {
                ["<leader>oc"] = {
                      action = function()
                        return require("obsidian").util.toggle_checkbox()
                      end,
                      opts = { buffer = true },
                    },
                    ["<os>"] = {
                      action = function()
                        return require("obsidian").util.smart_action()
                      end,
                      opts = { buffer = true, expr = true },
                    }
              },
              preferred_link_style = "wiki",
              picker = {
                  name = "telescope.nvim",
                  note_mappings = {
                    new = "<C-x>",
                    insert_link = "<C-l>",
                  },
                  tag_mappings = {
                    tag_note = "<C-x>",
                    insert_tag = "<C-l>",
                  },
                },
            })
      '';
  };
}
