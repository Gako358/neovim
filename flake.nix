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
    github-nvim-theme = {
      url = "github:projekt0n/github-nvim-theme";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, neovim, ... }@inputs:
  let
    plugins = [
      "github-nvim-theme"
    
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

          # Enable theme
          vim.theme.github-nvim-theme.enable = true;
      
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

    defaultPackage = lib.withDefaultSystems (sys: self.packages."${sys}".neovimMx);

    packages = lib.withDefaultSystems (sys: {
      neovimMx = mkNeoVimPkg allPkgs."${sys}";
    });
  };
}
