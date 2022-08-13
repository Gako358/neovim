{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
  cfg = config.vim.session;
in {
  options.vim.session = {
    enable = mkOption {
      type = types.bool;
      description = "enable session plugin: [vim-session]";
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
        vim-misc
        vim-session
      ];  

      vim.nnoremap = {
        "<leader>so" = ":OpenSession<Space>";
        "<leader>ss" = ":SaveSession<Space>";
        "<leader>sd" = ":DeleteSession<CR>";
        "<leader>sc" = ":CloseSession<CR>";
      };

      vim.luaConfigRC = ''
        -----------------------------------------------------------
        -- Session Management
        -----------------------------------------------------------
        vim.g.session_directory = "~/.config/nvim/sessions"
        vim.g.session_autoload = "no"
        vim.g.session_autosave = "no"
        vim.g.session_command_aliases = 1
      '';
    }
  );
}
        
