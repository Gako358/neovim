{
  description = "MerrinX's NeoVim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      # url = "github:neovim/neovim/875b58e0941ef62a75992ce0e6496bb7879e0bbe?dir=contrib";
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

    # LSP
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
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
    lspsaga = {
      url = "github:tami5/lspsaga.nvim";
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

    # Visuals
    onedark = {
      url = "github:navarasu/onedark.nvim";
      flake = false;
    };
    github-nvim-theme = {
      url = "github:projekt0n/github-nvim-theme";
      flake = false;
    };
    kanagawa = {
      url = "github:rebelot/kanagawa.nvim";
      flake = false;
    };
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

    # GIT
    nvim-gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
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

  outputs = {
    self,
    nixpkgs,
    neovim,
    ...
  } @ inputs: let
    plugins = [
      "onedark"
      "plenary-nvim"
      "nvim-treesitter"
      "nvim-lspconfig"
      "null-ls"
      "trouble"
      "rust-tools"
      "github-copilot"
      "nvim-cmp"
      "luasnip"
      "cmp-nvim-lsp"
      "cmp-path"
      "cmp-buffer"
      "cmp-luasnip"
      "lightspeed"
      "nvim-comment"
      "cmp-treesitter"
      "crates-nvim"
      "nvim-autopairs"
      "web-devicons"
      "nvim-bufferline"
      "nvim-gitsigns"
      "lualine"
      "nvim-filetree"
      "telescope"
    ];

    externalBitsOverlay = top: last: {
      neovim-nightly = neovim.defaultPackage.${top.system};
    };

    pluginOverlay = top: last: let
      treesitterGrammars = last.tree-sitter.withPlugins (p: [
        p.tree-sitter-c
        p.tree-sitter-nix
        p.tree-sitter-python
        p.tree-sitter-rust
        p.tree-sitter-markdown
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
    in {
      neovimPlugins = builtins.listToAttrs (map (name: {
          inherit name;
          value = buildPlug name;
        })
        plugins);
    };

    allPkgs = lib.mkPkgs {
      inherit nixpkgs;
      cfg = {};
      overlays = [
        pluginOverlay
        externalBitsOverlay
      ];

      externalBitsOverlay = top: last: {
        neovim-nightly = neovim.defaultPackage.${top.system};
      };

      pluginOverlay = top: last:
        let
          treesitterGrammars = last.tree-sitter.withPlugins (p: [
            p.tree-sitter-c
            p.tree-sitter-nix
            p.tree-sitter-python
            p.tree-sitter-rust
            p.tree-sitter-markdown
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
              lspsaga.enable = true;
              lightbulb.enable = true;
              lspSignature.enable = true;
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

            vim.theme.scheme = "kanagawa";

            vim.visuals = {
              enable = true;
              nvimAutoPairs.enable = true;
              nvimWebDevicons.enable = true;
              lightSpeed.enable = true;
              nvimComment.enable = true;
              indentBlankline.enable = true; 
              Focus.enable = true;
              lazyGit.enable = true;
              toggleTerm.enable = true;
              bufferline.enable = true;
              status.bar = "lualine";
            };

            vim.autocomplete.enable = true;

            vim.gitsigns.enable = true;

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
    };
}
