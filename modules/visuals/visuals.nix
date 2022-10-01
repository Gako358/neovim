{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.visuals;
in
{
  options.vim.visuals = {
    enable = mkOption {
      type = types.bool;
      description = "Enable vim visuals";
    };

    nvimAutoPairs.enable = mkOption {
      type = types.bool;
      description = "Enable auto pairs in nvim [nvim-autopairs]";
    };

    nvimWebDevicons.enable = mkOption {
      type = types.bool;
      description = "enable dev icons. required for certain plugins [nvim-web-devicons]";
    };

    lightSpeed.enable = mkOption {
      type = types.bool;
      description = "enable light speed. required for certain plugins [lightspeed]";
    };

    nvimComment.enable = mkOption {
      type = types.bool;
      description = "enable nvim comment. required for certain plugins [nvim-comment]";
    };

    indentBlankline = {
      enable = mkOption {
        type = types.bool;
        description = "enable indent blankline. required for certain plugins [indent-blankline.nvim]";
      };

      listChar = mkOption {
        type = types.str;
        description = "character for indentation line";
      };

      fillChar = mkOption {
        type = types.str;
        description = "character to fill indents";
      };

      eolChar = mkOption {
        type = types.str;
        description = "character to fill end of line";
      };

      showCurrContext = mkOption {
        type = types.bool;
        description = "show current context";
      };
    };

    Focus.enable = mkOption {
      type = types.bool;
      description = "enable focus. required for certain plugins [focus]";
    };

    lazyGit.enable = mkOption {
      type = types.bool;
      description = "enable lazy git. git manager [lazygit]";
    };

    toggleTerm.enable = mkOption {
      type = types.bool;
      description = "enable toggleterm. terminal emulator [toggleterm]";
    };
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins; [
      (
        if cfg.nvimAutoPairs.enable
        then nvim-autopairs
        else null
      )
      (
        if cfg.nvimWebDevicons.enable
        then web-devicons
        else null
      )
      (
        if cfg.lightSpeed.enable
        then lightspeed
        else null
      )
      (
        if cfg.nvimComment.enable
        then nvim-comment
        else null
      )
      (
        if cfg.indentBlankline.enable
        then indent-blankline
        else null
      )
      (
        if cfg.Focus.enable
        then focus
        else null
      )
      (
        if cfg.lazyGit.enable
        then lazygit
        else null
      )
      (
        if cfg.toggleTerm.enable
        then toggleterm
        else null
      )
    ];

    vim.luaConfigRC = ''
      ${
        if cfg.nvimAutoPairs.enable
        then ''
          require'nvim-autopairs'.setup {}
        ''
        else ""
      }
      ${
        if cfg.indentBlankline.enable
        then ''
          -- highlight error: https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
          vim.wo.colorcolumn = "99999"
          vim.opt.list = true
          ${
            if cfg.indentBlankline.eolChar == ""
            then ""
            else ''vim.opt.listchars:append({ eol = "${cfg.indentBlankline.eolChar}" })''
          }
          ${
            if cfg.indentBlankline.fillChar == ""
            then ""
            else ''vim.opt.listchars:append({ space = "${cfg.indentBlankline.fillChar}"})''
          }
          require("indent_blankline").setup {
            char = "${cfg.indentBlankline.listChar}",
            show_current_context = ${boolToString cfg.indentBlankline.showCurrContext},
            show_end_of_line = true,
          }
        ''
        else ""
      }
      ${
        if cfg.Focus.enable
        then ''
          vim.api.nvim_set_keymap('n', '<c-l>', ':FocusSplitNicely<CR>', { silent = true })
          vim.api.nvim_set_keymap('n', '<leader>h', ':FocusSplitLeft<CR>', { silent = true })
          vim.api.nvim_set_keymap('n', '<leader>j', ':FocusSplitDown<CR>', { silent = true })
          vim.api.nvim_set_keymap('n', '<leader>k', ':FocusSplitUp<CR>', { silent = true })
          vim.api.nvim_set_keymap('n', '<leader>l', ':FocusSplitRight<CR>', { silent = true })
          require("focus").setup({hybridnumber = true, excluded_filetypes = {"toggleterm"}})
        ''
        else ""
      }
      ${
        if cfg.lazyGit.enable
        then ''
          vim.api.nvim_set_keymap('n', '<leader>/', ':LazyGit<CR>', { silent = true })
        ''
        else ""
      }
      ${
        if cfg.toggleTerm.enable
        then ''
          require("toggleterm").setup {
            size = 20,
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_terminals = true,
            start_in_insert = true,
            persist_size = true,
            direction = 'horizontal',
            close_on_exit = true,
            shell = vim.o.shell,
          }
        ''
        else ""
      }
    '';
  };
}
