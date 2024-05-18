{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp;
  usingNvimCmp = config.vim.autocomplete.enable && config.vim.autocomplete.type == "nvim-cmp";
in {
  imports = [
    ./fidget.nix
    ./lightbulb.nix
    ./lspconfig.nix
    ./lspkind.nix
    ./null-ls.nix
    ./signature.nix
    ./trouble.nix
  ];

  options.vim.lsp = {
    enable = mkEnableOption "LSP, also enabled automatically through null-ls and lspconfig options";
    formatOnSave = mkEnableOption "format on save";
  };

  config = mkIf cfg.enable {
    vim.startPlugins = optional usingNvimCmp "cmp-nvim-lsp";
    vim.autocomplete.sources = {"nvim_lsp" = "[LSP]";};
    vim.luaConfigRC.lsp-setup =
      /*
      lua
      */
      ''
        vim.g.formatsave = ${boolToString cfg.formatOnSave};

        local attach_keymaps = function(client, bufnr)
          local opts = { noremap=true, silent=true }

          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gn', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gh', '<cmd>lua vim.lsp.inlay_hint.enable()<CR>', opts)

          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ln', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lf', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
        end

        -- Enable formatting
        format_callback = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              if vim.g.formatsave then
                if client.supports_method("textDocument/formatting") then
                  local params = require'vim.lsp.util'.make_formatting_params({})
                  client.request('textDocument/formatting', params, nil, bufnr)
                end
              end
            end
          })
        end

        default_on_attach = function(client, bufnr)
          attach_keymaps(client, bufnr)
          format_callback(client, bufnr)
        end

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        ${optionalString usingNvimCmp "capabilities = require('cmp_nvim_lsp').default_capabilities()"}
      '';
  };
}
