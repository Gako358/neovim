# From home-manager: https://github.com/nix-community/home-manager/blob/master/modules/lib/booleans.nix
{ lib }:
{
  # Converts diagnostic configuration to nvim-lint Lua sources
  diagnosticsToLua =
    {
      lang,
      config,
      diagnostics,
    }:
    lib.listToAttrs (
      map (
        v:
        let
          type = if builtins.isString v then v else builtins.getAttr v.type;
          package = if builtins.isString v then diagnostics.${type}.package else v.package;
        in
        {
          name = "${lang}-diagnostics-${type}";
          value = diagnostics.${type}.lintConfig package;
        }
      ) config
    );

  # Converts a command option to an actual command
  commandOptToCmd = pkg: cmd: if pkg == null then cmd else "${pkg}/bin/${cmd}";
}
