{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp;
in
{
  options.vim.lsp = {
    nvimCodeActionMenu = {
      enable = mkEnableOption "nvim code action menu";
    };
  };

  config = mkIf (cfg.enable && cfg.nvimCodeActionMenu.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [
      nvim-code-action-menu
    ];

    vim.vnoremap = {
      "<silent><leader>ca" = ":<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>";
    };

    vim.nnoremap = {
      "<silent><leader>ca" = ":CodeActionMenu<CR>";
    };
  };
}
