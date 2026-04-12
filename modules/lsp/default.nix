{
  config,
  lib,
  ...
}:

with lib;
with builtins;
let
  cfg = config.vim.lsp;
  usingNvimCmp = config.vim.autocomplete.enable && config.vim.autocomplete.cmp.type == "nvim-cmp";
in
{
  imports = [
    ./conform.nix
    ./fidget.nix
    ./lightbulb.nix
    ./lspconfig.nix
    ./lspkind.nix
    ./nvim-lint.nix
    ./signature.nix
    ./trouble.nix
  ];

  options.vim.lsp = {
    enable = mkEnableOption "LSP, also enabled automatically through conform, nvim-lint, and lspconfig options";
    formatOnSave = mkEnableOption "format on save";
  };

  config = mkIf cfg.enable {
    vim = {
      startPlugins = optional usingNvimCmp "cmp-nvim-lsp";
      autocomplete.cmp.sources = {
        "nvim_lsp" = "[LSP]";
      };
      luaConfigRC.lsp-setup = /* lua */ ''
        vim.g.formatsave = ${boolToString cfg.formatOnSave};

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        ${optionalString usingNvimCmp "capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)"}

        -- Shared on_attach keymaps via LspAttach autocmd
        local attach_keymaps = function(client, bufnr)
          local opts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '[d', function() vim.diagnostic.jump({count=-1, float=true}) end, opts)
          vim.keymap.set('n', ']d', function() vim.diagnostic.jump({count=1, float=true}) end, opts)
          vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
          vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format() end, opts)
          vim.keymap.set('v', '<leader>f', function() vim.lsp.buf.format() end, opts)
        end

        -- Enable formatting
        format_callback = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              if vim.g.formatsave then
                vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 3000 })
              end
            end
          })
        end

        default_on_attach = function(client, bufnr)
          attach_keymaps(client, bufnr)
          format_callback(client, bufnr)
        end

        -- Global LspAttach autocmd for keymaps
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client then
              attach_keymaps(client, bufnr)
              format_callback(client, bufnr)
            end
          end,
        })
      '';
    };
  };
}
