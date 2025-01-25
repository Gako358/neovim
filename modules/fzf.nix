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

    vim.nnoremap = {
      # File pickers
      "<leader>ff" = "<cmd>lua require('fzf-lua').files()<CR>";
      "<leader>fg" = "<cmd>lua require('fzf-lua').live_grep()<CR>";
      "<leader>fs" = "<cmd>lua require('fzf-lua').grep()<CR>";
      "<leader>fr" = "<cmd>lua require('fzf-lua').oldfiles()<CR>";
      "<leader>fm" = "<cmd>lua require('fzf-lua').marks()<CR>";
      "<leader><space>" = "<cmd>lua require('fzf-lua').grep_cword()<CR>";

      # Buffer picker
      "<Tab>" = "<cmd>lua require('fzf-lua').buffers()<CR>";

      # Git pickers
      "<leader>fvcw" = "<cmd>lua require('fzf-lua').git_commits()<CR>";
      "<leader>fvcb" = "<cmd>lua require('fzf-lua').git_bcommits()<CR>";
      "<leader>fvb" = "<cmd>lua require('fzf-lua').git_branches()<CR>";
      "<leader>fvs" = "<cmd>lua require('fzf-lua').git_status()<CR>";
      "<leader>fvx" = "<cmd>lua require('fzf-lua').git_stash()<CR>";
    } // (
      if config.vim.lsp.enable
      then {
        # LSP pickers
        "<leader>flsb" = "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>";
        "<leader>flsw" = "<cmd>lua require('fzf-lua').lsp_workspace_symbols()<CR>";
        "<leader>flr" = "<cmd>lua require('fzf-lua').lsp_references()<CR>";
        "<leader>fli" = "<cmd>lua require('fzf-lua').lsp_implementations()<CR>";
        "<leader>flD" = "<cmd>lua require('fzf-lua').lsp_definitions()<CR>";
        "<leader>flt" = "<cmd>lua require('fzf-lua').lsp_typedefs()<CR>";
        "<leader>fld" = "<cmd>lua require('fzf-lua').lsp_workspace_diagnostics()<CR>";
        "<leader>fla" = "<cmd>lua require('fzf-lua').lsp_code_actions()<CR>";
      }
      else {}
    );

    vim.luaConfigRC.fzf = nvim.dag.entryAnywhere /* lua */ ''
      require("fzf-lua").setup {
      }
    '';
  };
}
