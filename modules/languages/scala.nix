{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.languages.scala;

  defaultServer = "metals";
  servers = {
    metals = {
      package = pkgs.metals;
      lspConfig = ''
        -- Scala nvim-metals config
        vim.keymap.set("n", "<leader>cm", "<Cmd>lua require('metals').commands()<CR>", opts)
        vim.keymap.set("n", "<leader>cs", "<Cmd>lua require('metals').toggle_setting('showImplicitArguments')<CR>", opts)
        vim.keymap.set("n", "<leader>ch", "<Cmd>lua require('metals').worksheet_hover()<CR>", opts)
        vim.keymap.set("n", "<leader>cd", "<Cmd>lua require('metals').open_all_diagnostics()<CR>", opts)
        metals_config = require('metals').bare_config()
        metals_config.capabilities = capabilities
        metals_config.on_attach = attached_keymaps

        metals_config.settings = {
           metalsBinaryPath = "${cfg.lsp.package}/bin/metals",
           showImplicitArguments = true,
           showImplicitConversionsAndClasses = true,
           showInferredType = true,
           excludedPackages = {
             "akka.actor.typed.javadsl",
             "com.github.swagger.akka.javadsl"
           }
        }

        metals_config.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
          vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = {
              prefix = '',
            }
          }
        )

        -- without doing this, autocommands that deal with filetypes prohibit messages from being shown
        vim.opt_global.shortmess:remove("F")

        vim.cmd([[augroup lsp]])
        vim.cmd([[autocmd!]])
        vim.cmd([[autocmd FileType scala,sbt lua require('metals').initialize_or_attach(metals_config)]])
        vim.cmd([[augroup end]])
      '';
    };
  };

  defaultFormat = "scalaFmt";
  formats = {
    scalaFmt = {
      package = pkgs.scalafmt;
      nullConfig = ''
        table.insert(
          ls_sources,
          null_ls.builtins.formatting.scalafmt.with({
            command = "${cfg.format.package}/bin/scalafmt";
            args = {
              "--stdin",
            };
          })
        )
      '';
    };
  };
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
        default = servers.${cfg.lsp.server}.package;
      };
    };

    format = {
      enable = mkOption {
        description = "Enable Scala formatting";
        type = types.bool;
        default = config.vim.languages.enableFormat;
      };
      type = mkOption {
        description = "Scala formatter to use";
        type = with types; enum (attrNames formats);
        default = defaultFormat;
      };
      package = mkOption {
        description = "Scala formatter package";
        type = types.package;
        default = formats.${cfg.format.type}.package;
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
      vim.lsp.lspconfig.sources.scala-lsp = servers.${cfg.lsp.server}.lspConfig;
    })

    (mkIf cfg.format.enable {
      vim.lsp.null-ls.enable = true;
      vim.lsp.null-ls.sources.scala-format = formats.${cfg.format.type}.nullConfig;
    })
  ]);
}
