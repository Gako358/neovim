{ pkgs
, lib
, config
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.git.lazygit;
in
{
  options.vim.git.lazygit = {
    enable = mkOption {
      type = types.bool;
      description = "enable git plugin: [lazygit]";
    };
  };

  config = mkIf cfg.enable (
    let
      writeIf = cond: msg:
        if cond
        then msg
        else "";
    in
    {
      vim.startPlugins = with pkgs.neovimPlugins; [
        lazygit
      ];

      vim.luaConfigRC = ''
        vim.api.nvim_set_keymap('n', '<leader>/', ':LazyGit<CR>', { silent = true })
      '';
    }
  );
}
