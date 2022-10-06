{ pkgs
, config
, lib
, ...
}:
with lib;
with builtins; let
  cfg = config.vim.visuals.status;
in
{
  config = mkIf (cfg.bar == "winbar") {
    vim.configRC = ''
      set laststatus=0
    '';

    vim.luaConfigRC = ''
      local function status_line()
        local file_name = "%-.15t"
        local modified = " %-m"
        local right_align = "%="
        local line_no = "%10([%l/%L%)]"

        return string.format(
          "%s%s%s%s",
          file_name,
          modified,
          right_align,
          line_no
        )
      end

      -- vim.opt.statusline = status_line()
      vim.opt.winbar = status_line()
    '';
  };
}
