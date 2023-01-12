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
    ./html.nix
    ./java.nix
    ./kotlin.nix
    ./lua.nix
    ./nix.nix
    ./markdown.nix
    ./python.nix
    ./rust.nix
    ./sql.nix
    ./ts.nix
  ];

  options.vim.languages = {
    enableLSP = mkEnable "LSP";
    enableTreesitter = mkEnable "treesitter";
    enableFormat = mkEnable "formatting";
    enableExtraDiagnostics = mkEnable "extra diagnostics";
  };
}
