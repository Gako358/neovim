{ pkgs
, config
, lib
, ...
}:
with lib; {
  config = {
    vim.visuals = {
      enable = mkDefault false;

      nvimAutoPairs.enable = mkDefault false;
      nvimWebDevicons.enable = mkDefault false;
      lightSpeed.enable = mkDefault false;
      nvimComment.enable = mkDefault false;

      indentBlankline = {
        enable = mkDefault false;
        listChar = mkDefault "│";
        fillChar = mkDefault "";
        eolChar = mkDefault "";
        showCurrContext = mkDefault true;
      };
    };
  };
}
