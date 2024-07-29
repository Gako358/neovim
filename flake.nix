{
  description = "MerrinX Neovim Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Langauge server (use master instead of nixpkgs)
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # LSP plugins
    plugins-fidget = {
      url = "github:j-hui/fidget.nvim";
      flake = false;
    };
    plugins-nvim-lightbulb = {
      url = "github:kosayoda/nvim-lightbulb";
      flake = false;
    };
    plugins-nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    plugins-lspkind = {
      url = "github:onsails/lspkind-nvim";
      flake = false;
    };
    plugins-null-ls = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
      flake = false;
    };
    plugins-lsp-signature = {
      url = "github:ray-x/lsp_signature.nvim";
      flake = false;
    };
    plugins-trouble = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };

    # LSP tools
    plugins-crates-nvim = {
      url = "github:Saecki/crates.nvim";
      flake = false;
    };
    plugins-nvim-jdtls = {
      url = "github:mfussenegger/nvim-jdtls";
      flake = false;
    };
    plugins-nvim-metals = {
      url = "github:scalameta/nvim-metals";
      flake = false;
    };
    plugins-rust-tools = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };
    plugins-sqls-nvim = {
      url = "github:nanotee/sqls.nvim";
      flake = false;
    };

    # SQL
    plugins-vim-dadbod = {
      url = "github:tpope/vim-dadbod";
      flake = false;
    };
    plugins-vim-dadbod-ui = {
      url = "github:kristijanhusak/vim-dadbod-ui";
      flake = false;
    };
    plugins-vim-dadbod-completion = {
      url = "github:kristijanhusak/vim-dadbod-completion";
      flake = false;
    };

    # Debug
    plugins-nvim-dap = {
      url = "github:mfussenegger/nvim-dap";
      flake = false;
    };
    plugins-nvim-dap-ui = {
      url = "github:rcarriga/nvim-dap-ui";
      flake = false;
    };
    plugins-nvim-dap-virtual-text = {
      url = "github:theHamsta/nvim-dap-virtual-text";
      flake = false;
    };
    plugins-nvim-nio = {
      url = "github:nvim-neotest/nvim-nio";
      flake = false;
    };

    # Telescope
    plugins-telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    # Autocompletes
    plugins-nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    plugins-cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    plugins-cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    plugins-cmp-vsnip = {
      url = "github:hrsh7th/cmp-vsnip";
      flake = false;
    };
    plugins-cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    plugins-cmp-treesitter = {
      url = "github:ray-x/cmp-treesitter";
      flake = false;
    };
    plugins-cmp-dap = {
      url = "github:rcarriga/cmp-dap";
      flake = false;
    };

    # snippets
    plugins-vim-vsnip = {
      url = "github:hrsh7th/vim-vsnip";
      flake = false;
    };

    # Copilot
    plugins-copilot = {
      url = "github:zbirenbaum/copilot.lua";
      flake = false;
    };
    plugins-copilot-chat = {
      url = "github:CopilotC-Nvim/CopilotChat.nvim";
      flake = false;
    };

    # Markdown
    plugins-glow-nvim = {
      url = "github:ellisonleao/glow.nvim";
      flake = false;
    };

    # theme
    plugins-tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };

    # Git
    plugins-gitsigns-nvim = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    plugins-lazygit = {
      url = "github:kdheepak/lazygit.nvim";
      flake = false;
    };
    plugins-undotree = {
      url = "github:jiaoshijie/undotree";
      flake = false;
    };

    # Visuals
    plugins-lualine = {
      url = "github:hoob3rt/lualine.nvim";
      flake = false;
    };
    plugins-nvim-autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };
    plugins-indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    plugins-nvim-cursorline = {
      url = "github:yamatsum/nvim-cursorline";
      flake = false;
    };
    plugins-nvim-web-devicons = {
      url = "github:kyazdani42/nvim-web-devicons";
      flake = false;
    };
    plugins-noice = {
      url = "github:folke/noice.nvim";
      flake = false;
    };
    plugins-nui = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };
    plugins-notify = {
      url = "github:rcarriga/nvim-notify";
      flake = false;
    };
    plugins-oil = {
      url = "github:stevearc/oil.nvim";
      flake = false;
    };

    # Key binding help
    plugins-which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };

    plugins-plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    rawPlugins = nvimLib.plugins.fromInputs inputs "plugins-";

    neovimConfiguration = {modules ? [], ...} @ args:
      import ./modules
      (args // {modules = [{config.build.rawPlugins = rawPlugins;}] ++ modules;});

    nvimBin = pkg: "${pkg}/bin/nvim";

    buildPkg = pkgs: modules: (neovimConfiguration {
      inherit pkgs modules;
    });

    nvimLib = (import ./modules/lib/stdlib-extended.nix nixpkgs.lib).nvim;
    mainConfig = {
      config = {
        build.viAlias = false;
        build.vimAlias = true;
        vim.autocomplete = {
          enable = true;
          type = "nvim-cmp";
        };
        vim.copilot.chat = {
          enable = true;
        };
        vim.git = {
          enable = true;
          gitsigns.enable = true;
          gitsigns.codeActions = true;
          lazygit.enable = true;
        };
        vim.keys = {
          enable = true;
          whichKey.enable = true;
        };
        vim.languages = {
          enableLSP = true;
          enableDebug = true;
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          clang.enable = true;
          css.enable = true;
          haskell.enable = true;
          html.enable = true;
          java.enable = true;
          kotlin.enable = true;
          lua.enable = true;
          markdown.enable = true;
          nix.enable = true;
          python.enable = true;
          rust = {
            enable = true;
            crates.enable = true;
          };
          scala.enable = true;
          shell.enable = true;
          sql.enable = true;
          tailwind.enable = true;
          ts.enable = true;
          vue.enable = true;
          xml.enable = true;
        };
        vim.lsp = {
          formatOnSave = false;
          fidget.enable = true;
          lightbulb.enable = true;
          lspkind.enable = true;
          lspSignature.enable = true;
          trouble.enable = true;
        };
        vim.debug = {
          virtualText.enable = true;
          ui.enable = true;
        };
        vim.sql.enable = true;
        vim.undo.enable = true;
        vim.visuals = {
          enable = true;
          lualine = {
            enable = true;
            theme = "tokyonight";
          };
          nvimWebDevicons.enable = true;
          autopairs.enable = true;
          indentBlankline = {
            enable = true;
          };
          noice = {
            enable = true;
          };
          oil.enable = true;
        };
        vim.theme.enable = true;
        vim.telescope.enable = true;
      };
    };
  in
    {
      lib = {
        nvim = nvimLib;
        inherit neovimConfiguration;
      };

      overlays.default = final: prev: {
        inherit neovimConfiguration;
        neovim = buildPkg prev [mainConfig];
      };
    }
    // (flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            rnix-lsp = inputs.rnix-lsp.defaultPackage.${system};
            nil = inputs.nil.packages.${system}.default;
          })
        ];
      };

      neovimPkg = buildPkg pkgs [mainConfig];

      devPkg = buildPkg pkgs [mainConfig {config.vim.languages.html.enable = pkgs.lib.mkForce true;}];
    in {
      apps =
        rec {
          neovim = {
            type = "app";
            program = nvimBin neovimPkg;
          };
          default = neovim;
        }
        // pkgs.lib.optionalAttrs (!(builtins.elem system ["aarch64-darwin" "x86_64-darwin"])) {
        };

      devShells.default = pkgs.mkShell {nativeBuildInputs = [devPkg];};

      packages =
        {
          default = neovimPkg;
          neovim = neovimPkg;
        }
        // pkgs.lib.optionalAttrs (!(builtins.elem system ["aarch64-darwin" "x86_64-darwin"])) {
        };
      defaultPackage = neovimPkg;
    }));
}
