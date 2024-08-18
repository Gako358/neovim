{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.scala;
in {
  options.vim.languages.scala = {
    enable = mkEnableOption "Scala language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Scala treesitter";
        type = types.bool;
        default = config.vim.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "scala";
    };

    lsp = {
      enable = mkOption {
        description = "Enable Scala LSP support";
        type = types.bool;
        default = config.vim.languages.enableLSP;
      };
      server = mkOption {
        description = "Scala LSP server to use";
        type = with types; enum (attrNames servers);
        default = defaultServer;
      };
      package = mkOption {
        description = "Scala LSP server package";
        type = types.package;
        default = pkgs.metals;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [cfg.treesitter.package];
    })

    (mkIf cfg.lsp.enable {
      vim.startPlugins = ["nvim-metals"];
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.scala-lsp =
        /*
        lua
        */
        ''
          local metals_config = require("metals").bare_config()
          metals_config.settings = {
            metalsBinaryPath = "${cfg.lsp.package}/bin/metals",
            showImplicitArguments = true,
            showImplicitConversionsAndClasses = true,
            showInferredType = true,
            enableSemanticHighlighting = false,
            excludedPackages = {}
          }

          vim.cmd([[augroup lsp]])
          vim.cmd([[autocmd!]])

          local function setup_codelens_refresh(client, bufnr)
            local status_ok, codelens_supported = pcall(function()
              return client.supports_method("textDocument/codeLens")
            end)
            if not status_ok or not codelens_supported then
              return
            end
            local group = "lsp_code_lens_refresh"
            local cl_events = { "BufEnter", "InsertLeave" }
            local ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
              group = group,
              buffer = bufnr,
              event = cl_events,
            })
            if ok and #cl_autocmds > 0 then
              return
            end
            local cb = function()
              if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_is_valid(bufnr) then
                vim.lsp.codelens.refresh({ bufnr = bufnr })
              end
            end
            vim.api.nvim_create_augroup(group, { clear = false })
            vim.api.nvim_create_autocmd(cl_events, {
              group = group,
              buffer = bufnr,
              callback = cb,
            })
          end

          scala_on_attach = function(client, bufnr)
            attach_keymaps(client, bufnr)
            local opts = { noremap=true, silent=true, buffer = bufnr }
            vim.keymap.set("n", "<leader>sgD", "<cmd>MetalsGotoSuperMethod<CR>")
            vim.keymap.set("n", "<leader>si", "<Cmd>MetalsImportsBuild<CR>", opts)
            vim.keymap.set("n", "<leader>so", "<Cmd>MetalsOrganizeImports<CR>", opts)
            vim.keymap.set("n", "<leader>sd", "<Cmd>MetalsRunDoctor<CR>", opts)
            vim.keymap.set("n", "<leader>si", "<Cmd>MetalsInfo<CR>", opts)
            setup_codelens_refresh(client, bufnr)
            require("metals").setup_dap()
          end

          metals_config.capabilities = capabilities
          metals_config.on_attach = scala_on_attach

          local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
          vim.api.nvim_create_autocmd("FileType", {
            pattern = { "scala", "sbt" },
            callback = function()
              require("metals").initialize_or_attach(metals_config)
            end,
            group = nvim_metals_group,
          })
        '';
    })
  ]);
}
