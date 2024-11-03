{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.project = {
    enable = mkEnableOption "enable project management in neovim";
  };

  config = mkIf (config.vim.gui.enable) {
    vim.startPlugins = [
      "project"
      "session"
      "direnv"
    ];

    vim.luaConfigRC.sql =
      nvim.dag.entryAnywhere
      /*
      lua
      */
      ''
        vim.api.nvim_set_keymap('n', '<leader>pp', '<cmd>NeovimProjectDiscover<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>pr', '<cmd>NeovimProjectLoadRecent<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>ph', '<cmd>NeovimProjectHistory<CR>', { noremap = true, silent = true })

        require("neovim-project").setup {
          projects = {
            "~/Projects/*",
            "~/Projects/plugins/*",
            "~/Projects/workspace/*",
            "~/Sources/*",
            "~/Documents/*",
          },
          picker = {
            type = "telescope",
          }
        }
        require("session_manager").setup{}
        require("direnv").setup({
          autoload_direnv = true,
        })
      '';
  };
}
