{
  description = "MerrinX's NeoVim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ### Vim plugins ###

    # Theme
    github-theme = {
      url = "github:projekt0n/github-nvim-theme";
      flake = false;
    };

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

    nvim-lsp-installer = {
      url = "github:williamboman/nvim-lsp-installer";
      flake = false;
    };


  };

  outputs = { self, nixpkgs, neovim, ... }@inputs:
  let
    plugins = [
      "github-theme"
      "plenary-nvim"
      "nvim-treesitter"
      "nvim-lspconfig"
      "nvim-lsp-installer"
    ];

    externalBitsOverlay = top: last: {
      neovim-nightly = neovim.defaultPackage.${top.system};
    };

    pluginOverlay = top: last: let
      buildPlug = name: top.vimUtils.buildVimPluginFrom2Nix {
        pname = name;
        version = "master";
        src = builtins.getAttr name inputs;
      };
    in {
      neovimPlugins = builtins.listToAttrs (map (name: { inherit name; value = buildPlug name; }) plugins);
    };
    
    allPkgs = lib.mkPkgs { 
      inherit nixpkgs; 
      cfg = { };
      overlays = [
        pluginOverlay
        externalBitsOverlay
      ];
    };

    lib = import ./lib;

    mkNeoVimPkg = pkgs: lib.neovimBuilder {
        inherit pkgs;
        config = {
          vim.viAlias = true;
          vim.vimAlias = true;
          vim.theme.github-theme.enable = true;

          vim.treesitter.enable = true;
          vim.lsp.enable = true;

        };
      };

  in {

    apps = lib.withDefaultSystems (sys:
    {
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
