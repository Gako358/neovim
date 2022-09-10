 { pkgs, config, lib, ...}:
  with lib;
  with builtins;

  let
    cfg = config.vim.lsp;
  in {
    options.vim.lsp = {
      enable = mkOption {
        type = types.bool;
        description = "enable lsp config [nvim-lspconfig]";
      };
      formatOnSave = mkEnableOption "format on save";

      python = mkEnableOption "Enable Python Language Support";
      clang = mkEnableOption "Enable C Language Support";
      bash = mkEnableOption "Enable Bash Language Support";
      lua = mkEnableOption "Enable Lua Language Support";
      nix = mkEnableOption "Enable Nix Language Support";
      rust = mkEnableOption "Enable Rust Support";
      typescript = mkEnableOption "Enable Typescript/Javascript Support";
    };

    config = mkIf cfg.enable {
      vim.startPlugins = with pkgs.neovimPlugins; [
        nvim-lspconfig
        null-ls
      ]
      ++ (
        if cfg.rust then [
          rust-tools
          crates-nvim
        ]
        else []
      );

      vim.configRC = ''
        ${if cfg.nix then ''
          autocmd filetype nix setlocal tabstop=2 shiftwidth=2 softtabstop=2
        ''
        else ""
        } 
        ${if cfg.rust then ''
          function! MapRustTools()
            nnoremap <silent><leader>rh <cmd>lua require('rust-tools').hover_actions.hover_actions()<CR>
            nnoremap <silent><leader>ri <cmd>lua require('rust-tools').inlay_hints.set()<CR>
            nnoremap <silent><leader>ru <cmd>lua require('rust-tools').inlay_hints.unset()<CR>
            nnoremap <silent><leader>rr <cmd>lua require('rust-tools').runnables.runnables()<CR>
            nnoremap <silent><leader>re <cmd>lua require('rust-tools.expand_macro').expand_macro()<CR>
            nnoremap <silent><leader>rc <cmd>lua require('rust-tools.open_cargo_toml').open_cargo_toml()<CR>
            nnoremap <silent><leader>rg <cmd>lua require('rust-tools.crate_graph').view_crate_graph('x11', nil)<CR>
          endfunction
            autocmd filetype rust nnoremap <silent><leader>rh <cmd>lua require('rust-tools').hover_actions.hover_actions()<CR>
            autocmd filetype rust nnoremap <silent><leader>ri <cmd>lua require('rust-tools').inlay_hints.set()<CR>
            autocmd filetype rust nnoremap <silent><leader>ru <cmd>lua require('rust-tools').inlay_hints.unset()<CR>
            autocmd filetype rust nnoremap <silent><leader>rr <cmd>lua require('rust-tools').runnables.runnables()<CR>
            autocmd filetype rust nnoremap <silent><leader>re <cmd>lua require('rust-tools.expand_macro').expand_macro()<CR>
            autocmd filetype rust nnoremap <silent><leader>rc <cmd>lua require('rust-tools.open_cargo_toml').open_cargo_toml()<CR>
            autocmd filetype rust nnoremap <silent><leader>rg <cmd>lua require('rust-tools.crate_graph').view_crate_graph('x11', nil)<CR>
        ''
        else ""
        }
      '';

      vim.luaConfigRC = let
      in ''    
        -- Seting up null-ls
        local null_ls = require("null-ls")
        local null_helpers = require("null-ls.helpers")
        local null_methods = require("null-ls.methods")

        local ls_sources = {
          ${if cfg.python then ''
            null_ls.builtins.formatting.black.with({
                command = "${pkgs.black}/bin/black",
              }),
          ''else ""}

          ${if cfg.nix then ''
            null_ls.builtins.formatting.alejandra.with({
                command = "${pkgs.alejandra}/bin/alejandra",
            }),
          ''else ""}

          ${if cfg.typescript then ''
            null_ls.builtins.diagnostics.eslint,
            null_ls.builtins.formatting.prettier,
          ''else ""} 
        }

        vim.g.formatsave = ${if cfg.formatOnSave
          then "true"
          else "false"
        };

        -- Enable formatting
        format_callback = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              if vim.g.formatsave then
                  local params = require'vim.lsp.util'.make_formatting_params({})
                  client.request('textDocument/formatting', params, nil, bufnr)
              end
            end
          })
        end
        default_on_attach = function(client, bufnr)
          attach_keymaps(client, bufnr)
          format_callback(client, bufnr)
        end
        -- Enable null-ls
        require('null-ls').setup({
          diagnostics_format = "[#{m}] #{s} (#{c})",
          debounce = 250,
          default_timeout = 5000,
          sources = ls_sources,
          on_attach=default_on_attach
        })
        
        local lsp_flags = {
          -- This is the default in Nvim 0.7+
          debounce_text_changes = 150,
        }
        
        local opts = { noremap=true, silent=true }
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
        
        -- Use an on_attach function to only map the following keys
        -- after the language server attaches to the current buffer
        local on_attach = function(client, bufnr)
          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        
          -- Mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local bufopts = { noremap=true, silent=true, buffer=bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, bufopts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
        end

        ${if cfg.python then ''
          require('lspconfig')['pyright'].setup{
              on_attach = on_attach,
              flags = lsp_flags,
              cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
          }
        '' else ""}
        ${if cfg.clang then ''
          require('lspconfig')['clangd'].setup{
              on_attach = on_attach,
              flags = lsp_flags,
              cmd = {'${pkgs.clang-tools}/bin/clangd', '--background-index'};
              filetypes = { "c", "cpp", "objc", "objcpp" };
          }
        '' else ""}
        ${if cfg.bash then ''
          require('lspconfig')['bashls'].setup{
              on_attach = on_attach,
              flags = lsp_flags,
              cmd = {"${pkgs.nodePackages.bash-language-server}/bin/bash-language-server", "start"}
          }
        '' else ""}
        ${if cfg.lua then ''
          require('lspconfig')['sumneko_lua'].setup{
              on_attach = on_attach,
              flags = lsp_flags,
              cmd = {"${pkgs.sumneko-lua-language-server}/bin/sumneko_lua", "start"}
          }
        '' else ""}
        ${if cfg.nix then ''
          require('lspconfig')['rnix'].setup{
              on_attach = on_attach,
              flags = lsp_flags,
              cmd = {"${pkgs.rnix-lsp}/bin/rnix-lsp"}
          }
        '' else ""}
        ${if cfg.rust then ''
          local opts = {
              tools = { -- rust-tools options
                  -- how to execute terminal commands
                  -- options right now: termopen / quickfix
                  executor = require("rust-tools/executors").termopen,

                  autoSetHints = true,
                  inlinethints = {
                      auto = true,
                      only_current_line = false,
                  },
                  hover_actions = {
                      auto = true,
                  }
              },
          }
          require('crates').setup()
          require('rust-tools').setup(opts)
          require('lspconfig')['rust_analyzer'].setup{
              on_attach = on_attach,
              flags = lsp_flags,
              cmd = {"${pkgs.rust-analyzer}/bin/rust-analyzer"}
          }
        '' else ""}
         
        ${if cfg.typescript then ''
          require('lspconfig')['tsserver'].setup{
              on_attach = on_attach,
              flags = lsp_flags,
              cmd = { "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio" }
          }
        '' else ""}
      '';
  };
}
