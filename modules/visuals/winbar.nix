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
      set cmdheight=0
    '';

    vim.luaConfigRC = ''
      local function status_line()
        local modified = " %-m"
        local file_type = " %y"
        local right_align = "%="
        local line_no = "%10([%l/%L%)]"

        return string.format(
          "%s%s%s%s",
          right_align,
          modified,
          file_type,
          line_no
        )
      end

      -- vim.opt.statusline = status_line()
      vim.opt.winbar = status_line()
    '';
  };
}
