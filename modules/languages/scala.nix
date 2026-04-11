{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.scala;

  defaultServer = "metals";
  servers = {
    metals = {
      package = pkgs.metals;
    };
  };
in
{
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
        default = servers.${cfg.lsp.server}.package;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.treesitter.enable = true;
      vim.treesitter.grammars = [ cfg.treesitter.package ];
    })

    (mkIf cfg.lsp.enable {
      vim.startPlugins = [ "nvim-metals" ];
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

          scala_on_attach = function(client, bufnr)
            attach_keymaps(client, bufnr)
            local opts = { noremap=true, silent=true, buffer = bufnr }
            vim.keymap.set("n", "<leader>sgD", "<cmd>MetalsGotoSuperMethod<CR>")
            vim.keymap.set("n", "<leader>si", "<Cmd>MetalsImportsBuild<CR>", opts)
            vim.keymap.set("n", "<leader>so", "<Cmd>MetalsOrganizeImports<CR>", opts)
            vim.keymap.set("n", "<leader>sd", "<Cmd>MetalsRunDoctor<CR>", opts)
            vim.keymap.set("n", "<leader>si", "<Cmd>MetalsInfo<CR>", opts)
            -- Enable codelens
            if client:supports_method("textDocument/codeLens") then
              vim.lsp.codelens.enable(true, { bufnr = bufnr })
            end
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
