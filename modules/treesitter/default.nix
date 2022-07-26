{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.treesitter;
in {
  options.vim.treesitter = {
    enable = mkOption {
      type = types.bool;
      description = "enable tree-sitter [nvim-treesitter]";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      nvim-treesitter
    ];
    in ''
        -- Treesitter config
        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true,
            disable = {},
          },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "gnn",
              node_incremental = "grn",
              scope_incremental = "grc",
              node_decremental = "grm",
            },
          },
          ${writeIf cfg.autotagHtml ''
          autotag = {
            enable = true,
          },
        ''}
        }
        local parser_config = require'nvim-treesitter.parsers'.get_parser_configs()
        parser_config.hare = {
          install_info = {
            url = "",
            files = { "" }
          },
          filetype = "ha",
        }
      '';
  };
}
