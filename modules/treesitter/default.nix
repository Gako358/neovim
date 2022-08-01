{ pkgs, lib, config, stdenv, writeTextFile, curl, git, cacert, neovim-nightly, ... }:
with lib;
with builtins;

let
  installParsers = writeTextFile {
    name = "install-parsers.lua";
    text = ''
      treesitter = require("nvim-treesitter")
      treesitter.setup()
      require'nvim-treesitter.configs'.setup({
        ensure_installed = "maintained",
      })
      vim.cmd("TSInstallSync maintained")
      vim.cmd("q")
    '';
  };
in stdenv.mkDerivation rec {
  pname = "nvim-treesitter-parsers";
  version = flake.inputs.nvim-treesitter.shortRev;
  src = flake.inputs.nvim-treesitter;

  buildInputs = [ neovim-nightly curl cacert git ];

  # Should not be setting HOME
  buildPhase = ''
    pushd lua
    HOME=./ nvim -u NONE --headless -c "luafile ${installParsers}"
    popd
  '';

  installPhase = ''
    installDir=$out/share/nvim/parser
    mkdir -p $installDir
    cp -a parser/*.so $installDir
  '';

  meta = with lib; {
    description = "nvim-treesitter maintained parsers";
    homepage = "https://github.com/nvim-treesitter/nvim-treesitter";
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
    license = with licenses; [ asl20 ];
  };
}
