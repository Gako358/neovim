{ pkgs
, lib
, config
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.git.gitsigns;
in
{
  options.vim.git.gitsigns = {
    enable = mkOption {
      type = types.bool;
      description = "enable git plugin: [nvim-gitsigns]";
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
        nvim-gitsigns
      ];

      vim.luaConfigRC = ''
        require('gitsigns').setup {
              keymaps = {
                noremap = true,
                ['n <leader>gn'] = { expr = true, "&diff ? \'\' : '<cmd>Gitsigns next_hunk<CR>'"},
                ['n <leader>gp'] = { expr = true, "&diff ? \'\' : '<cmd>Gitsigns prev_hunk<CR>'"},
                ['n <leader>gs'] = '<cmd>Gitsigns stage_hunk<CR>',
                ['v <leader>gs'] = ':Gitsigns stage_hunk<CR>',
                ['n <leader>gu'] = '<cmd>Gitsigns undo_stage_hunk<CR>',
                ['n <leader>gr'] = '<cmd>Gitsigns reset_hunk<CR>',
                ['v <leader>gr'] = ':Gitsigns reset_hunk<CR>',
                ['n <leader>gR'] = '<cmd>Gitsigns reset_buffer<CR>',
                ['n <leader>gv'] = '<cmd>Gitsigns preview_hunk<CR>',
                ['n <leader>gd'] = '<cmd>Gitsigns diffthis<CR>',
                ['n <leader>gb'] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
                ['n <leader>gS'] = '<cmd>Gitsigns stage_buffer<CR>',
                ['n <leader>gU'] = '<cmd>Gitsigns reset_buffer_index<CR>',
                ['n <leader>gts'] = ':Gitsigns toggle_signs<CR>',
                ['n <leader>gtn'] = ':Gitsigns toggle_numhl<CR>',
                ['n <leader>gtl'] = ':Gitsigns toggle_linehl<CR>',
                ['n <leader>gtw'] = ':Gitsigns toggle_word_diff<CR>',
                -- Text objects
                ['o ih'] = ':<C-U>Gitsigns select_hunk<CR>',
                ['x ih'] = ':<C-U>Gitsigns select_hunk<CR>'
              },
            }
      '';
    }
  );
}
