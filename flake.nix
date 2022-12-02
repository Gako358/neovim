{
  description = "MerrinX's NeoVim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      # url = "github:neovim/neovim/85c7d4f7a92326dcd70317b048bafe96c8051701?dir=contrib"; # 0.8.0
      # In the case nightly breaks, use the above line to pin to a specific commit
      # Or pin down another commit that works
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### Vim plugins ###

    # Plenary
    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
    };
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # LSP
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      # pinning to a specific commit because of error on querys on python
      /*
        url = "github:nvim-treesitter/nvim-treesitter/8f927a4d50716e534c5845e835625962adf878e1";
      */
      flake = false;
    };
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    null-ls = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
      flake = false;
    };
    nvim-lightbulb = {
      url = "github:kosayoda/nvim-lightbulb";
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
    rust-tools = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };

    # COPILOT
    github-copilot = {
      url = "github:github/copilot.vim";
      flake = false;
    };

    # CMP
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    luasnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };
    cmp-treesitter = {
      url = "github:ray-x/cmp-treesitter";
      flake = false;
    };

    # Rust crates
    crates-nvim = {
      url = "github:Saecki/crates.nvim";
      flake = false;
    };

    # Theme
    borealis = {
      url = "github:Gako358/borealis.nvim";
      flake = false;
    };

    # Visuals
    nvim-autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };
    web-devicons = {
      url = "github:kyazdani42/nvim-web-devicons";
      flake = false;
    };
    lightspeed = {
      url = "github:ggandor/lightspeed.nvim";
      flake = false;
    };
    nvim-comment = {
      url = "github:terrortylor/nvim-comment";
      flake = false;
    };
    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    toggleterm = {
      url = "github:akinsho/toggleterm.nvim";
      flake = false;
    };
    nvim-bufferline = {
      url = "github:akinsho/bufferline.nvim";
      flake = false;
    };
    nvim-tree = {
      url = "github:nvim-tree/nvim-tree.lua";
      flake = false;
    };
    lualine = {
      url = "github:nvim-lualine/lualine.nvim";
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
    glow-nvim = {
      url = "github:ellisonleao/glow.nvim";
      flake = false;
    };

    # GIT
    nvim-gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    lazygit = {
      url = "github:kdheepak/lazygit.nvim";
      flake = false;
    };

    # Undo tree
    undotree = {
      url = "github:mbbill/undotree";
      flake = false;
    };

    # Help
    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };

    # TELESCOPE
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , neovim
    , rnix-lsp
    , nil
    , ...
    } @ inputs:
    let
      plugins = [
        "plenary-nvim"
        "nvim-treesitter"
        "nvim-lspconfig"
        "null-ls"
        "nvim-lightbulb"
        "nvim-code-action-menu"
        "trouble"
        "rust-tools"
        "github-copilot"
        "nvim-cmp"
        "luasnip"
        "cmp-nvim-lsp"
        "cmp-path"
        "cmp-buffer"
        "cmp-luasnip"
        "cmp-treesitter"
        "crates-nvim"
        "borealis"
        "nvim-autopairs"
        "web-devicons"
        "lightspeed"
        "nvim-comment"
        "indent-blankline"
        "toggleterm"
        "nvim-bufferline"
        "nvim-tree"
        "lualine"
        "noice"
        "nui"
        "notify"
        "glow-nvim"
        "nvim-gitsigns"
        "lazygit"
        "undotree"
        "which-key"
        "telescope"
      ];

      externalBitsOverlay = top: last: {
        neovim-nightly = neovim.defaultPackage.${top.system};
        rnix-lsp = rnix-lsp.defaultPackage.${top.system};
        nil-lsp = nil.defaultPackage.${top.system};
      };

      pluginOverlay = top: last:
        let
          treesitterGrammars = last.tree-sitter.withPlugins (p: [
            p.tree-sitter-c
            p.tree-sitter-vim
            p.tree-sitter-regex
            p.tree-sitter-nix
            p.tree-sitter-python
            p.tree-sitter-rust
            p.tree-sitter-markdown
            p.tree-sitter-markdown-inline
            p.tree-sitter-comment
            p.tree-sitter-toml
            p.tree-sitter-make
            p.tree-sitter-html
            p.tree-sitter-javascript
            p.tree-sitter-css
            p.tree-sitter-latex
            p.tree-sitter-lua
            p.tree-sitter-typescript
            p.tree-sitter-bash
          ]);
          buildPlug = name:
            top.vimUtils.buildVimPluginFrom2Nix {
              pname = name;
              version = "master";
              src = builtins.getAttr name inputs;
              postPatch =
                if (name == "nvim-treesitter")
                then ''
                  rm -r parser
                  ln -s ${treesitterGrammars} parser
                ''
                else "";
            };
        in
        {
          neovimPlugins = builtins.listToAttrs (map
            (name: {
              inherit name;
              value = buildPlug name;
            })
            plugins);
        };

      allPkgs = lib.mkPkgs {
        inherit nixpkgs;
        cfg = { };
        overlays = [
          pluginOverlay
          externalBitsOverlay
        ];
      };

      lib =
        import
          ./lib;

      mkNeoVimPkg = pkgs:
        lib.neovimBuilder {
          inherit pkgs;
          config = {
            vim.viAlias = true;
            vim.vimAlias = true;
            vim.autoIndent = true;

            vim.treesitter.enable = true;
            vim.lsp = {
              enable = true;
              lightbulb.enable = true;
              nvimCodeActionMenu.enable = true;
              trouble.enable = true;

              # Language servers:
              python = true;
              clang = true;
              cmake = true;
              bash = true;
              lua = true;
              nix = true;
              rust = true;
              typescript = true;
              docker = true;
              tex = true;
              css = true;
              html = true;
              json = true;
            };

            vim.theme.scheme = "borealis";

            vim.visuals = {
              enable = true;
              nvimAutoPairs.enable = true;
              nvimWebDevicons.enable = true;
              lightSpeed.enable = true;
              nvimComment.enable = true;
              indentBlankline.enable = true;
              toggleTerm.enable = true;
              bufferline.enable = true;
              filetree.enable = true;
              noice.enable = true;
              glow.enable = true;
              status.bar = "lualine";
            };

            vim.autocomplete.enable = true;

            vim.git = {
              gitsigns.enable = true;
              lazygit.enable = true;
            };

            vim.keys = {
              enable = true;
              whichKey.enable = true;
            };

            vim.telescope.enable = true;
          };
        };
    in
    {
      apps = lib.withDefaultSystems (sys: {
        nvim = {
          type = "app";
          program = "${self.defaultPackage."${sys}"}/bin/nvim";
        };
      });

      defaultApp = lib.withDefaultSystems (sys: {
        type = "app";
        program = "${self.defaultPackage."${sys}"}/bin/nvim";
      });

      defaultPackage = lib.withDefaultSystems (sys: self.packages."${sys}".neovimMX);

      packages = lib.withDefaultSystems (sys: {
        neovimMX = mkNeoVimPkg allPkgs."${sys}";
      });

      devShells = lib.withDefaultSystems (sys: {
        neovimMX = mkNeoVimPkg allPkgs."${sys}";
      });
    };
}
