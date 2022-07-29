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
      
      vim.luaConfigRC = ''
        require'nvim-treesitter.configs'.setup({
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
          },
          autotag = {
            enable = true,
          },
          matchup = {
            enable = true,
          }
        })
      '';
    }
  );
}
