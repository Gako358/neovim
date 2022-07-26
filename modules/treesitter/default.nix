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
    vim.luaConfigRC = let
      tree-sitter-hare = builtins.fetchGit {
        url = "https://git.sr.ht/~ecmma/tree-sitter-hare";
        ref = "master";
        rev = "bc26a6a949f2e0d98b7bfc437d459b250900a165";
      };
    in ''
      -- Treesitter config
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {
        vim.g.enable_treesitter_ft,
        'typescript',
        'javascript',
        'comment',
        'python',
        'bibtex',
        'html',
        'bash',
        'make',
        'json',
        'rust',
        'vim',
        'lua',
        'css',
        'cpp',
        'c',
        },
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
        }
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
