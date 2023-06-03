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
        lspconfig.jdtls.setup{
          capabilities = capabilities;
          on_attach = attached_keymaps,
          cmd = {
            '${cfg.lsp.package}/bin/metals',
          };
          init_options = {
            compilerOptions = {
              snippetAutoIndent = false;
            },
            isHttpEnabled = true,
            statusBarProvider = "show-message",
          };
          message_level = 4,
          root_dir = lspconfig.util.root_pattern("build.sbt", "build.sc", "build.gradle", "pom.xml", "gradlew", "gradle"),
        };
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
  # TODO: Add support for nvim-metals
  # scalameta/nvim-metals
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
      vim.startPlugins = ["nvim-jdtls"];
      vim.lsp.lspconfig.enable = true;
      vim.lsp.lspconfig.sources.scala-lsp = servers.${cfg.lsp.server}.lspConfig;
    })

    (mkIf cfg.format.enable {
      vim.lsp.null-ls.enable = true;
      vim.lsp.null-ls.sources.scala-format = formats.${cfg.format.type}.nullConfig;
    })
  ]);
}
