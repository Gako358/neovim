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
      ];

      vim.luaConfigRC = let
      in ''    
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
        
        local lsp_flags = {
          -- This is the default in Nvim 0.7+
          debounce_text_changes = 150,
        }
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
          require('lspconfig')['rust-analyzer'].setup{
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
