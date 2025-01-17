{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.treesitter;
  usingNvimCmp = config.vim.autocomplete.enable && config.vim.autocomplete.cmp.type == "nvim-cmp";
in {
  options.vim.treesitter = {
    enable = mkEnableOption "treesitter, also enabled automatically through language options";

    fold = mkEnableOption "fold with treesitter";

    grammars = mkOption {
      type = with types; listOf package;
      default = [];
      description = nvim.nmd.asciiDoc ''
        List of treesitter grammars to install. For supported languages
        use the `vim.languages.<language>.treesitter.enable` option
      '';
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins =
      ["nvim-treesitter"]
      ++ optional usingNvimCmp "cmp-treesitter";

    vim.autocomplete.cmp.sources = {"treesitter" = "[Treesitter]";};

    # For some reason treesitter highlighting does not work on start if this is set before syntax on
    vim.configRC.treesitter-fold = mkIf cfg.fold (nvim.dag.entryBefore ["basic"] ''
      set foldmethod=expr
      set foldexpr=nvim_treesitter#foldexpr()
      set nofoldenable
    '');

    vim.luaConfigRC.treesitter =
      nvim.dag.entryAnywhere
      /*
      lua
      */
      ''
        vim.opt.conceallevel = 2

        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true,
            disable = {},
          },

          auto_install = false,
          ensure_installed = {},

          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "gnn",
              node_incremental = "grn",
              scope_incremental = "grc",
              node_decremental = "grm",
            },
          }
        }
      '';
  };
}
