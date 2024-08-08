{lib}: let
  optionsLanguage = import ./options-languages.nix {inherit lib;};
in {
  inherit (optionsLanguage) mkDiagnosticsOption mkGrammarOption mkCommandOption;
}
