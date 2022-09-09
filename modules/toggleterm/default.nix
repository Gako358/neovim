{ pkgs, lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.vim.toggleterm;

in {
  options.vim.toggleterm = {
    enable = mkOption {
      type = types.bool;
      description = "Enable toggleterm plugin: [toggleterm]";
    };
  };

  config = mkIf cfg.enable ( 
    let
      writeIf = cond: msg:
        if cond
        then msg
        else "";
    in {
      vim.startPlugins = with.pkgs.neovimPlugins; [
        toggleterm
      ];

      vim.luaConfigRC = ''
        require("toggleterm").setup()
          autocmd TermEnter term://*toggleterm#*
            \ tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>

          " By applying the mappings this way you can pass a count to your
          " mapping to open a specific window.
          " For example: 2<C-t> will open terminal 2
          nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
          inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
      '';
    }
  );
}
