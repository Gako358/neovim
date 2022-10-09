{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp;
in
{
  options.vim.lsp = {
    enable = mkOption {
      type = types.bool;
      description = "enable lsp config [nvim-lspconfig]";
    };
    python = mkEnableOption "Enable Python Language Support";
    clang = mkEnableOption "Enable C Language Support";
    cmake = mkEnableOption "Enable CMake";
    bash = mkEnableOption "Enable Bash Language Support";
    lua = mkEnableOption "Enable Lua Language Support";
    nix = mkEnableOption "Enable Nix Language Support";
    rust = mkEnableOption "Enable Rust Support";
    typescript = mkEnableOption "Enable Typescript/Javascript Support";
    docker = mkEnableOption "Enable docker support";
    tex = mkEnableOption "Enable tex support";
    css = mkEnableOption "Enable css support";
    html = mkEnableOption "Enable html support";
    json = mkEnableOption "Enable JSON";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = with pkgs.neovimPlugins;
      [
        nvim-lspconfig
        null-ls
      ]
      ++ (
        if cfg.rust
        then [
          rust-tools
          crates-nvim
        ]
        else [ ]
      );

    vim.configRC = ''
      ${
        if cfg.nix
        then ''
          autocmd filetype nix setlocal tabstop=2 shiftwidth=2 softtabstop=2
        ''
        else ""
      }
      ${
        if cfg.rust
        then ''
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

    vim.luaConfigRC =
      let
      in
      ''
        local lsp_flags = {
          -- This is the default in Nvim 0.7+
          debounce_text_changes = 150,
        }

        -- Use an on_attach function to only map the following keys
        -- after the language server attaches to the current buffer
        local default_on_attach = function(client, bufnr)
          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

          -- Mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local bufopts = { noremap=true, silent=true, buffer=bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<C-i>', vim.lsp.buf.signature_help, bufopts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, bufopts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
          vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, bufopts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
          vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, bufopts)
        end

        -- Offset encoding
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.offsetEncoding = {"utf-16"}

        -- Setting up null-ls
        local null_ls = require("null-ls")
        local null_helpers = require("null-ls.helpers")
        local null_methods = require("null-ls.methods")

        local ls_sources = {
          ${
          if cfg.python
          then ''
            null_ls.builtins.formatting.black.with({
                command = "${pkgs.black}/bin/black",
              }),
          ''
          else ""
        }

          ${
          if cfg.nix
          then ''
            null_ls.builtins.formatting.alejandra.with({
                command = "${pkgs.alejandra}/bin/alejandra",
            }),
          ''
          else ""
        }
          ${
          if cfg.typescript
          then ''
            null_ls.builtins.diagnostics.eslint.with({
                command = "${pkgs.nodePackages.eslint}/bin/eslint",
            }),
            null_ls.builtins.formatting.prettier.with({
              command = "${pkgs.nodePackages.prettier}/bin/prettier",
            }),
          ''
          else ""
        }
        }

        -- Enable null-ls
        require('null-ls').setup({
          diagnostics_format = "[#{m}] #{s} (#{c})",
          debounce = 250,
          default_timeout = 5000,
          sources = ls_sources,
          on_attach= default_on_attach,
        })

        ${
          if cfg.python
          then ''
            require('lspconfig')['pyright'].setup{
                on_attach = default_on_attach,
                flags = lsp_flags,
                cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
            }
          ''
          else ""
        }
        ${
          if cfg.clang
          then ''
            require('lspconfig')['clangd'].setup{
                capabilities = capabilities,
                on_attach = default_on_attach,
                flags = lsp_flags,
                cmd = {'${pkgs.clang-tools}/bin/clangd', '--background-index'};
                filetypes = { "c", "cpp", "objc", "objcpp" };
            }
          ''
          else ""
        }
        ${
          if cfg.cmake
          then ''
            require('lspconfig')['cmake'].setup{
              on_attach = default_on_attach,
              cmd = {'${pkgs.cmake-language-server}/bin/cmake-language-server'};
              filetypes = { "cmake"};
            }
          ''
          else ""
        }
        ${
          if cfg.bash
          then ''
            require('lspconfig')['bashls'].setup{
                on_attach = default_on_attach,
                flags = lsp_flags,
                cmd = {"${pkgs.nodePackages.bash-language-server}/bin/bash-language-server", "start"}
            }
          ''
          else ""
        }
        ${
          if cfg.lua
          then ''
            require('lspconfig')['sumneko_lua'].setup{
                on_attach = default_on_attach,
                flags = lsp_flags,
                cmd = {"${pkgs.sumneko-lua-language-server}/bin/lua-language-server"},
                Lua = {
                  runtime = {
                    version = 'LuaJIT',
                  },
                  diagnostics = {
                    globals = { "vim" },
                  },
                  workspace = {
                    library = vim.api.nvim_get_runtime_file("lua", true),
                  },
                  telemetry = {
                    enable = false,
                  };
                }
            }
          ''
          else ""
        }
        ${
          if cfg.nix
          then ''
            -- require('lspconfig')['rnix'].setup{
            require('lspconfig')['nil_ls'].setup{
                on_attach = default_on_attach,
                flags = lsp_flags,
                -- cmd = {"${pkgs.rnix-lsp}/bin/rnix-lsp"}
                cmd = {"${pkgs.nil}/bin/nil"}
            }
          ''
          else ""
        }
        ${
          if cfg.rust
          then ''
            local rust_opts = {
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
            require('rust-tools').setup(rust_opts)
            require('lspconfig')['rust_analyzer'].setup{
                on_attach = default_on_attach,
                flags = lsp_flags,
                cmd = {"${pkgs.rust-analyzer}/bin/rust-analyzer"}
            }
          ''
          else ""
        }
        ${
          if cfg.typescript
          then ''
            require('lspconfig')['tsserver'].setup{
                on_attach = default_on_attach,
                flags = lsp_flags,
                cmd = { "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio" }
            }
          ''
          else ""
        }
        ${
          if cfg.docker
          then ''
            require('lspconfig')['dockerls'].setup{
              on_attach = default_on_attach,
              cmd = {'${pkgs.nodePackages.dockerfile-language-server-nodejs}/bin/docker-language-server', '--stdio' }
            }
          ''
          else ""
        }
        ${
          if cfg.css
          then ''
            require('lspconfig')['cssls'].setup{
              on_attach = default_on_attach,
              cmd = {'${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver', '--stdio' };
              filetypes = { "css", "scss", "less" };
            }
          ''
          else ""
        }

        ${
          if cfg.html
          then ''
            require('lspconfig')['html'].setup{
              on_attach = default_on_attach,
              cmd = {'${pkgs.nodePackages.vscode-html-languageserver-bin}/bin/html-languageserver', '--stdio' };
              filetypes = { "html", "css", "javascript" };
            }
          ''
          else ""
        }

        ${
          if cfg.json
          then ''
            require('lspconfig')['jsonls'].setup{
              on_attach = default_on_attach,
              cmd = {'${pkgs.nodePackages.vscode-json-languageserver-bin}/bin/json-languageserver', '--stdio' };
              filetypes = { "html", "css", "javascript" };
            }
          ''
          else ""
        }
        ${
          if cfg.tex
          then ''
            require('lspconfig')['texlab'].setup{
              on_attach = default_on_attach,
              cmd = {'${pkgs.texlab}/bin/texlab'}
            }
          ''
          else ""
        }
      '';
  };
}
