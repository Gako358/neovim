{lib, ...}:
with lib; let
  mkEnable = desc:
    mkOption {
      description = "Turn on ${desc} for enabled languages by default";
      type = types.bool;
      default = false;
    };
in {
  imports = [
    ./clang.nix
    ./css.nix
    ./dhall.nix
    ./haskell.nix
    ./html.nix
    ./java.nix
    ./kotlin.nix
    ./lua.nix
    ./nix.nix
    ./markdown.nix
    ./python.nix
    ./rust.nix
    ./scala.nix
    ./sql.nix
    ./tailwind.nix
    ./ts.nix
    ./vue.nix
  ];

  options.vim.languages = {
    enableLSP = mkEnable "LSP";
    enableTreesitter = mkEnable "treesitter";
    enableFormat = mkEnable "formatting";
    enableExtraDiagnostics = mkEnable "extra diagnostics";
  };
}
