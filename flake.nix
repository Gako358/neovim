{
  description = "MerrinX Neovim Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # LSP plugins
    fidget = {
      url = "github:j-hui/fidget.nvim";
      flake = false;
    };
    nvim-lightbulb = {
      url = "github:kosayoda/nvim-lightbulb";
      flake = false;
    };
    lsp-signature = {
      url = "github:ray-x/lsp_signature.nvim";
      flake = false;
    };
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    lspkind = {
      url = "github:onsails/lspkind-nvim";
      flake = false;
    };
    lspsaga = {
      url = "github:tami5/lspsaga.nvim";
      flake = false;
    };
    null-ls = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
      flake = false;
    };
    nvim-code-action-menu = {
      url = "github:weilbith/nvim-code-action-menu";
      flake = false;
    };
    trouble = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };

    # LSP tools
    nvim-treesitter-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
    };
    nvim-jdtls = {
      url = "github:mfussenegger/nvim-jdtls";
      flake = false;
    };
    rust-tools = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };
    sqls-nvim = {
      url = "github:nanotee/sqls.nvim";
      flake = false;
    };
    nvim-metals = {
      url = "github:scalameta/nvim-metals";
      flake = false;
    };

    # Debugging
    nvim-dap = {
      url = "github:mfussenegger/nvim-dap";
      flake = false;
    };
    nvim-dap-ui = {
      url = "github:rcarriga/nvim-dap-ui";
      flake = false;
    };

    # Copying/Registers
    registers = {
      url = "github:tversteeg/registers.nvim";
      flake = false;
    };
    nvim-neoclip = {
      url = "github:AckslD/nvim-neoclip.lua";
      flake = false;
    };

    # Telescope
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    # Langauge server (use master instead of nixpkgs)
    rnix-lsp.url = "github:nix-community/rnix-lsp";
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # Filetrees
    nvim-tree-lua = {
      url = "github:kyazdani42/nvim-tree.lua";
      flake = false;
    };

    # Statuslines
    lualine = {
      url = "github:hoob3rt/lualine.nvim";
      flake = false;
    };

    # Autocompletes
    nvim-compe = {
      url = "github:hrsh7th/nvim-compe";
      flake = false;
    };
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-vsnip = {
      url = "github:hrsh7th/cmp-vsnip";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    cmp-treesitter = {
      url = "github:ray-x/cmp-treesitter";
      flake = false;
    };

    # snippets
    vim-vsnip = {
      url = "github:hrsh7th/vim-vsnip";
      flake = false;
    };

    # Autopairs
    nvim-autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };
    nvim-ts-autotag = {
      url = "github:windwp/nvim-ts-autotag";
      flake = false;
    };

    # dropbar
    dropbar-nvim = {
      url = "github:Bekaboo/dropbar.nvim";
      flake = false;
    };

    # Themes
    borealis = {
      url = "github:Gako358/borealis.nvim";
      flake = false;
    };

    # Rust crates
    crates-nvim = {
      url = "github:Saecki/crates.nvim";
      flake = false;
    };

    # Git
    gitsigns-nvim = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    lazygit = {
      url = "github:kdheepak/lazygit.nvim";
      flake = false;
    };

    # Visuals
    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    kommentary = {
      url = "github:b3nj5m1n/kommentary";
      flake = false;
    };
    nvim-cursorline = {
      url = "github:yamatsum/nvim-cursorline";
      flake = false;
    };
    nvim-web-devicons = {
      url = "github:kyazdani42/nvim-web-devicons";
      flake = false;
    };
    noice = {
      url = "github:folke/noice.nvim";
      flake = false;
    };
    nui = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };
    notify = {
      url = "github:rcarriga/nvim-notify";
      flake = false;
    };
    todo-comments = {
      url = "github:folke/todo-comments.nvim";
      flake = false;
    };
    toggleterm = {
      url = "github:akinsho/toggleterm.nvim";
      flake = false;
    };

    # Key binding help
    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };

    # Markdown
    glow-nvim = {
      url = "github:ellisonleao/glow.nvim";
      flake = false;
    };

    # Plenary (required by crates-nvim)
    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    open-browser = {
      url = "github:tyru/open-browser.vim";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    # Plugin must be same as input name
    availablePlugins = [
      "fidget"
      "nvim-lightbulb"
      "lsp-signature"
      "nvim-lspconfig"
      "lspkind"
      "lspsaga"
      "null-ls"
      "nvim-code-action-menu"
      "trouble"
      "nvim-treesitter-context"
      "nvim-jdtls"
      "rust-tools"
      "sqls-nvim"
      "nvim-metals"
      "nvim-dap"
      "nvim-dap-ui"
      "telescope"
      "nvim-tree-lua"
      "lualine"
      "nvim-compe"
      "nvim-cmp"
      "cmp-nvim-lsp"
      "cmp-buffer"
      "cmp-vsnip"
      "cmp-path"
      "cmp-treesitter"
      "github-copilot"
      "vim-vsnip"
      "nvim-autopairs"
      "nvim-ts-autotag"
      "borealis"
      "crates-nvim"
      "gitsigns-nvim"
      "lazygit"
      "dropbar-nvim"
      "indent-blankline"
      "nvim-cursorline"
      "nvim-web-devicons"
      "kommentary"
      "noice"
      "nui"
      "notify"
      "todo-comments"
      "toggleterm"
      "which-key"
      "glow-nvim"
      "plenary-nvim"
      "open-browser"
    ];
    rawPlugins = nvimLib.plugins.inputsToRaw inputs availablePlugins;

    neovimConfiguration = {modules ? [], ...} @ args:
      import ./modules
      (args // {modules = [{config.build.rawPlugins = rawPlugins;}] ++ modules;});

    nvimBin = pkg: "${pkg}/bin/nvim";

    buildPkg = pkgs: modules: (neovimConfiguration {
      inherit pkgs modules;
    });

    nvimLib = (import ./modules/lib/stdlib-extended.nix nixpkgs.lib).nvim;

    mainConfig = isMaximal: let
      overrideable = nixpkgs.lib.mkOverride 1200; # between mkOptionDefault and mkDefault
    in {
      config = {
        build.viAlias = overrideable false;
        build.vimAlias = overrideable true;
        vim.autopairs.enable = overrideable true;
        vim.autocomplete = {
          enable = overrideable true;
          type = overrideable "nvim-cmp";
        };
        vim.debugging = {
          enable = overrideable true;
          dap.enable = overrideable true;
          dapUI.enable = overrideable true;
        };
        vim.filetree.nvimTreeLua.enable = overrideable true;
        vim.git = {
          enable = overrideable true;
          gitsigns.enable = overrideable true;
          gitsigns.codeActions = overrideable true;
          lazygit.enable = overrideable true;
        };
        vim.keys = {
          enable = overrideable true;
          whichKey.enable = overrideable true;
        };
        vim.languages = {
          enableLSP = overrideable true;
          enableFormat = overrideable true;
          enableTreesitter = overrideable true;
          enableExtraDiagnostics = overrideable true;

          clang.enable = overrideable true;
          css.enable = overrideable true;
          dhall.enable = overrideable true;
          haskell.enable = overrideable true;
          html.enable = overrideable true;
          java.enable = overrideable true;
          kotlin.enable = overrideable true;
          lua.enable = overrideable true;
          markdown.enable = overrideable true;
          nix.enable = overrideable true;
          python.enable = overrideable true;
          rust = {
            enable = overrideable true;
            crates.enable = overrideable true;
          };
          scala = {
            enable = overrideable true;
          };
          sql = {
            enable = overrideable true;
            extraDiagnostics.enable = overrideable false;
          };
          ts.enable = overrideable true;
        };
        vim.lsp = {
          formatOnSave = overrideable false;
          lspkind.enable = overrideable true;
          lightbulb.enable = overrideable true;
          lspsaga.enable = overrideable false;
          nvimCodeActionMenu.enable = overrideable true;
          trouble.enable = overrideable true;
          lspSignature.enable = overrideable true;
        };
        vim.visuals = {
          enable = overrideable true;
          nvimWebDevicons.enable = overrideable true;
          cursorWordline = {
            enable = overrideable true;
            lineTimeout = overrideable 0;
          };
          dropbar.enable = overrideable false;
          indentBlankline = {
            enable = overrideable true;
            fillChar = overrideable null;
            eolChar = overrideable null;
            showCurrContext = overrideable true;
          };
          kommentary.enable = overrideable true;
          noice = {
            enable = overrideable true;
          };
          todoComments.enable = overrideable true;
          toggleTerm = {
            enable = overrideable true;
          };
        };
        vim.statusline.lualine = {
          enable = overrideable true;
          theme = overrideable "borealis";
        };
        vim.theme = {
          enable = overrideable true;
          name = overrideable "borealis";
        };
        vim.telescope.enable = overrideable true;
        vim.treesitter.context.enable = overrideable true;
      };
    };

    nixConfig = mainConfig false;
    maximalConfig = mainConfig true;
  in
    {
      lib = {
        nvim = nvimLib;
        inherit neovimConfiguration;
      };

      overlays.default = final: prev: {
        inherit neovimConfiguration;
        neovim-nix = buildPkg prev [nixConfig];
        neovim-maximal = buildPkg prev [maximalConfig];
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

      nixPkg = buildPkg pkgs [nixConfig];
      maximalPkg = buildPkg pkgs [maximalConfig];

      devPkg = buildPkg pkgs [nixConfig {config.vim.languages.html.enable = pkgs.lib.mkForce true;}];
    in {
      apps =
        rec {
          nix = {
            type = "app";
            program = nvimBin nixPkg;
          };
          maximal = {
            type = "app";
            program = nvimBin maximalPkg;
          };
          default = nix;
        }
        // pkgs.lib.optionalAttrs (!(builtins.elem system ["aarch64-darwin" "x86_64-darwin"])) {
        };

      devShells.default = pkgs.mkShell {nativeBuildInputs = [devPkg];};

      packages =
        {
          default = nixPkg;
          nix = nixPkg;
          maximal = maximalPkg;
        }
        // pkgs.lib.optionalAttrs (!(builtins.elem system ["aarch64-darwin" "x86_64-darwin"])) {
        };
      defaultPackage = nixPkg;
    }));
}
