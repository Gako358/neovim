{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.visuals.glow;
in
{
  options.vim.visuals.glow = {
    enable = mkOption {
      type = types.bool;
      description = "Enable glow plugin: [glow-nvim]";
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
        glow-nvim
      ];

      vim.globals = {
        "glow_binary_path" = "${pkgs.glow}/bin";
      };

      vim.configRC = ''
        autocmd FileType markdown noremap <leader>p :Glow<CR>
      '';
    }
  );
}
