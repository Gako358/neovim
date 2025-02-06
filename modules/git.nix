{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.git;
in {
  options.vim.git = {
    enable = mkEnableOption "Git support";
  };

  config = mkIf cfg.enable (mkMerge [
    # Base git plugins and null-ls
    {
      vim.startPlugins = [
        "lazygit"
        "gitsigns-nvim"
      ];

      vim.lsp.null-ls.enable = true;
      vim.lsp.null-ls.sources.gitsigns-ca = ''
        table.insert(
          ls_sources,
          null_ls.builtins.code_actions.gitsigns
        )
      '';
    }

    # LazyGit configuration
    {
      vim.luaConfigRC.lazygit = nvim.dag.entryAnywhere ''
        vim.api.nvim_set_keymap('n', '<leader>/', ':LazyGit<CR>', { silent = true })
      '';
    }

    # Gitsigns configuration
    {
      vim.luaConfigRC.gitsigns =
        nvim.dag.entryAnywhere
        /*
        lua
        */
        ''
          require('gitsigns').setup {
            watch_gitdir = {
            interval = 1000,
            follow_files = true
            },
            attach_to_untracked = true,
            current_line_blame = false,
            current_line_blame_opts = {
              virt_text = true,
              virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
              delay = 1000,
              ignore_whitespace = false,
            },
            current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
            max_file_length = 3000, -- Disable if file is longer than this (in lines)
            preview_config = {
              -- Options passed to nvim_open_win
              border = 'single',
              style = 'minimal',
              relative = 'cursor',
              row = 0,
              col = 1
            },
            on_attach = function(bufnr)
              local gs = package.loaded.gitsigns

              local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
              end

              -- actions
              map('n', '<leader>gb', function() gs.blame_line{full=true} end)

              -- Text objects
              map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            end
          }
        '';
    }
  ]);
}
