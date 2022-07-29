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

  config = mkIf cfg.enable (
    let
      writeIf = cond: msg:
      if cond
      then msg
      else "";
    in {  
      vim.startPlugins = with pkgs.neovimPlugins; [
        nvim-treesitter
      ];

      vim.configRC = ''
        " Tree-sitter based folding
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        set nofoldenable
      '';

      vim.luaConfigRC = let
        tree-sitter-hare = builtins.fetchGit {
          url = "https://git.sr.ht/~ecmma/tree-sitter-hare";
          ref = "master";
          rev = "bc26a6a949f2e0d98b7bfc437d459b250900a165";
        };

        tree-sitter-lua = builtins.fetchGit {
          url = "https://github.com/MunifTanjim/tree-sitter-lua";
          ref = "main";
          rev = "c9ece5b2d348f917052db5a2da9bd4ecff07426c";
        };
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
        }
        local parser_config = require'nvim-treesitter.parsers'.get_parser_configs()
        parser_config.hare = {
          install_info = {
            url = "",
            files = { "" }
          },
          filetype = "ha",
        }
        parser_config.lua = {
          install_info = {
            url = "",
            files = { "" }
          },
          filetype = "lua",
        }
      '';     
    }
  );
}
