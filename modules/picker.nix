{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.fzf;
in {
  options.vim.fzf = {
    enable = mkEnableOption "enable fzf-lua";
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = [
      "fzf-lua"
    ];

    vim.luaConfigRC.fzf-maps = nvim.dag.entryAnywhere ''
      if ${boolToString config.vim.keys.whichKey.enable} then
        local wk = require("which-key")
        wk.add({
          -- File pickers
          { "<leader>f", group = "Find" },
          { "<leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", desc = "Find Files" },
          { "<leader>fg", "<cmd>lua require('fzf-lua').live_grep()<CR>", desc = "Live Grep" },
          { "<leader>fs", "<cmd>lua require('fzf-lua').grep()<CR>", desc = "Grep" },
          { "<leader>fr", "<cmd>lua require('fzf-lua').oldfiles()<CR>", desc = "Recent Files" },
          { "<leader>fm", "<cmd>lua require('fzf-lua').marks()<CR>", desc = "Marks" },
          { "<leader><space>", "<cmd>lua require('fzf-lua').grep_cword()<CR>", desc = "Grep Current Word" },

          -- Buffer picker
          { "<Tab>", "<cmd>lua require('fzf-lua').buffers()<CR>", desc = "Buffers" },

          -- Git pickers
          { "<leader>fv", group = "Git" },
          { "<leader>fvc", "<cmd>lua require('fzf-lua').git_commits()<CR>", desc = "Git Commits" },
          { "<leader>fvb", "<cmd>lua require('fzf-lua').git_branches()<CR>", desc = "Git Branches" },
          { "<leader>fvs", "<cmd>lua require('fzf-lua').git_status()<CR>", desc = "Git Status" },
          { "<leader>fvx", "<cmd>lua require('fzf-lua').git_stash()<CR>", desc = "Git Stash" },
        })

        -- LSP pickers (conditional)
        if ${boolToString config.vim.lsp.enable} then
          wk.add({
            { "<leader>fl", group = "LSP" },
            { "<leader>flr", "<cmd>lua require('fzf-lua').lsp_references()<CR>", desc = "LSP References" },
            { "<leader>fli", "<cmd>lua require('fzf-lua').lsp_implementations()<CR>", desc = "LSP Implementations" },
            { "<leader>flD", "<cmd>lua require('fzf-lua').lsp_definitions()<CR>", desc = "LSP Definitions" },
            { "<leader>flt", "<cmd>lua require('fzf-lua').lsp_typedefs()<CR>", desc = "LSP Type Definitions" },
            { "<leader>fld", "<cmd>lua require('fzf-lua').lsp_workspace_diagnostics()<CR>", desc = "LSP Workspace Diagnostics" },
            { "<leader>fla", "<cmd>lua require('fzf-lua').lsp_code_actions()<CR>", desc = "LSP Code Actions" },
          })
        end
      end
    '';

    vim.luaConfigRC.fzf =
      nvim.dag.entryAnywhere
      /*
      lua
      */
      ''
        require("fzf-lua").setup({
          "telescope",
          fzf_opts = {
            ["--layout"] = "reverse"
          }
        })
      '';
  };
}
