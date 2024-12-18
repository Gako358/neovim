{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.gui;
in {
  options.vim.gui = {
    enable = mkEnableOption "Neovide gui";
  };

  config = mkIf (cfg.enable) {
    vim.luaConfigRC.gui =
      nvim.dag.entryAnywhere
      /*
      lua
      */
      ''

          -- TODO: need to be done today
          -- need to bind qluck fix list navigation cnex nprev and so on
          -- need to turn off copilot, only for when i need it
          -- need to fix a terminal float and toggle
          -- need to remove zellij

          -- Neovide Font
          vim.o.guifont = "JetBrainsMono Nerd Font:h10:Medium:i"
        end
        -- Lua function to open multiple terminals in new tab
        function _G.OpenMultipleTerminalsInNewTab()
          vim.cmd("tabnew")
          vim.cmd("terminal")
          vim.cmd("vsplit")
          vim.cmd("terminal")
          vim.cmd("split")
          vim.cmd("terminal")
        end

        function _G.OpenDoubleTerminalsInNewTab()
          vim.cmd("tabnew")
          vim.cmd("terminal")
          vim.cmd("vsplit")
          vim.cmd("terminal")
        end

        vim.keymap.set("t", "<ESC><ESC>", "<C-\\><C-n>", {desc = "Exit terminal mode"})
        vim.keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>", {desc = "Open vertical split terminal"})
        vim.keymap.set("n", "<leader>th", ":split | terminal<CR>", {desc = "Open horizontal split terminal"})
        vim.keymap.set("n", "<leader>tt", ":lua OpenDoubleTerminalsInNewTab()<CR>", {desc = "Open terminal in new tab"})
        vim.keymap.set("n", "<leader>tm", ":lua OpenMultipleTerminalsInNewTab()<CR>", {desc = "Open terminal in new tab"})
      '';
  };
}
