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
  config = mkIf (cfg.bar == "statusline") {
    vim.luaConfigRC = ''
      local fn = vim.fn
      local api = vim.api

      local set_hl = function(group, options)
        local bg = options.bg == nil and "" or 'guibg=' .. options.bg
        local fg = options.fg == nil and "" or 'guifg=' .. options.fg
        local gui = options.gui == nil and "" or 'gui=' .. options.gui

        vim.cmd(string.format('hi %s %s %s %s', group, bg, fg, gui))
      end

      -- you can of course pick whatever colour you want, I picked these colours
      -- because I use Gruvbox and I like them
      local highlights = {
        {'StatusLine', { fg = '#16161D', bg = '#DCD7BA' }},
        {'StatusLineNC', { fg = '#16161D', bg = '#DCD7BA' }},
        {'Mode', { bg = '#54546D', fg = '#1D2021', gui="bold" }},
        {'LineCol', { bg = '#2D4F67', fg = '#DCD7BA', gui="bold" }},
        {'Git', { bg = '#2D4F67', fg = '#DCD7BA' }},
        {'Filetype', { bg = '#2D4F67', fg = '#DCD7BA' }},
        {'Filename', { bg = '#16161D', fg = '#DCD7BA' }},
        {'ModeAlt', { bg = '#16161D', fg = '#DCD7BA' }},
        {'GitAlt', { bg = '#16161D', fg = '#DCD7BA' }},
        {'LineColAlt', { bg = '#16161D', fg = '#DCD7BA' }},
        {'FiletypeAlt', { bg = '#16161D', fg = '#DCD7BA' }},
        {'diagnosticErr', { bg = '#E82424', fg = '#DCD7BA' }},
        {'diagnosticAlt', { bg = '#16161D', fg = '#DCD7BA' }},
      }

      for _, highlight in ipairs(highlights) do
        set_hl(highlight[1], highlight[2])
      end

      local M = {}

      -- possible values are 'arrow' | 'rounded' | 'blank'
      local active_sep = 'blank'

      -- change them if you want to different separator
      M.separators = {
        arrow = { '', '' },
        rounded = { '', '' },
        blank = { "", "" },
      }

      -- highlight groups
      M.colors = {
        active        = '%#StatusLine#',
        inactive      = '%#StatusLineNC#',
        file_name     = '%#Filename#',
        mode          = '%#Mode#',
        mode_alt      = '%#ModeAlt#',
        git           = '%#Git#',
        git_alt       = '%#GitAlt#',
        filetype      = '%#Filetype#',
        filetype_alt  = '%#FiletypeAlt#',
        line_col      = '%#LineCol#',
        line_col_alt  = '%#LineColAlt#',
        diagnostic    = '%#diagnosticErr#',
        diagnostic_alt= '%#diagnosticAlt#',
      }

      M.trunc_width = setmetatable({
        mode       = 80,
        git_status = 90,
        filename   = 140,
        line_col   = 60,
      }, {
        __index = function()
            return 80
        end
      })

      M.is_truncated = function(_, width)
        local current_width = api.nvim_win_get_width(0)
        return current_width < width
      end

      M.modes = setmetatable({
        ['n']  = {'Normal', 'N'};
        ['no'] = {'N·Pending', 'N·P'} ;
        ['v']  = {'Visual', 'V' };
        ['V']  = {'V·Line', 'V·L' };
        ['␖'] = {'V·Block', 'V·B'}; -- this is not ^V, but it's ␖, they're different
        ['s']  = {'Select', 'S'};
        ['S']  = {'S·Line', 'S·L'};
        ['␓'] = {'S·Block', 'S·B'}; -- same with this one, it's not ^S but it's ␓
        ['i']  = {'Insert', 'I'};
        ['ic'] = {'Insert', 'I'};
        ['R']  = {'Replace', 'R'};
        ['Rv'] = {'V·Replace', 'V·R'};
        ['c']  = {'Command', 'C'};
        ['cv'] = {'Vim·Ex ', 'V·E'};
        ['ce'] = {'Ex ', 'E'};
        ['r']  = {'Prompt ', 'P'};
        ['rm'] = {'More ', 'M'};
        ['r?'] = {'Confirm ', 'C'};
        ['!']  = {'Shell ', 'S'};
        ['t']  = {'Terminal ', 'T'};
      }, {
        __index = function()
            return {'Unknown', 'U'} -- handle edge cases
        end
      })

      M.get_current_mode = function(self)
        local current_mode = api.nvim_get_mode().mode

        if self:is_truncated(self.trunc_width.mode) then
          return string.format(' %s ', self.modes[current_mode][2]):upper()
        end
        return string.format(' %s ', self.modes[current_mode][1]):upper()
      end

      M.get_git_status = function(self)
        -- use fallback because it doesn't set this variable on the initial `BufEnter`
        local signs = vim.b.gitsigns_status_dict or {head = "", added = 0, changed = 0, removed = 0}
        local is_head_empty = signs.head ~= ""

        if self:is_truncated(self.trunc_width.git_status) then
          return is_head_empty and string.format('  %s ', signs.head or "") or ""
        end

        return is_head_empty and string.format(
          ' +%s ~%s -%s |  %s ',
          signs.added, signs.changed, signs.removed, signs.head
        ) or ""
      end

      M.get_filename = function(self)
        if self:is_truncated(self.trunc_width.filename) then return " %<%f " end
        return " %<%F "
      end

      M.get_filetype = function()
        local file_name, file_ext = fn.expand("%:t"), fn.expand("%:e")
        local icon = require'nvim-web-devicons'.get_icon(file_name, file_ext, { default = true })
        local filetype = vim.bo.filetype

        if filetype == "" then return "" end
        return string.format(' %s %s ', icon, filetype):lower()
      end

      M.get_line_col = function(self)
        if self:is_truncated(self.trunc_width.line_col) then return ' %l:%c ' end
        return ' Ln %l, Col %c '
      end

      -- Figure out lsp errors
      -- M.get_lsp_status = function(self)
      --   local result = {}
      --   local levels = {
      --     errors = 'Error',
      --     warnings = 'Warning',
      --     info = 'Information',
      --     hints = 'Hint'
      --   }

      --   for k, level in pairs(levels) do
      --     result[k] = vim.lsp.diagnostic.get_count(0, level)
      --   end

      --   if self:is_truncated(120) then
      --     return ""
      --   else
      --     return string.format(
      --       "| :%s :%s :%s :%s ",
      --       result['errors'] or 0, result['warnings'] or 0,
      --       result['info'] or 0, result['hints'] or 0
      --     )
      --   end
      -- end

      M.set_active = function(self)
        local colors = self.colors

        local mode = colors.mode .. self:get_current_mode()
        local mode_alt = colors.mode_alt .. self.separators[active_sep][1]
        local git = colors.git .. self:get_git_status()
        local git_alt = colors.git_alt .. self.separators[active_sep][1]
        -- local lsp = colors.diagnostic .. self:get_lsp_status()
        -- local lsp_alt = colors.diagnostic_alt .. self.separators[active_sep][1]
        local filename = colors.file_name .. self:get_filename()
        local filetype_alt = colors.filetype_alt .. self.separators[active_sep][2]
        local filetype = colors.filetype .. self:get_filetype()
        local line_col = colors.line_col .. self:get_line_col()
        local line_col_alt = colors.line_col_alt .. self.separators[active_sep][2]

        return table.concat({
          colors.active, mode, mode_alt, git, git_alt,
          "%=", filename, "%=",
          filetype_alt, filetype, line_col_alt, line_col
        })
      end

      M.set_inactive = function(self)
        return self.colors.inactive .. '%= %F %='
      end

      M.set_explorer = function(self)
        local title = self.colors.mode .. '   '
        local title_alt = self.colors.mode_alt .. self.separators[active_sep][2]

        return table.concat({ self.colors.active, title, title_alt })
      end

      Statusline = setmetatable(M, {
        __call = function(statusline, mode)
          if mode == "active" then return statusline:set_active() end
          if mode == "inactive" then return statusline:set_inactive() end
        end
      })

      -- set statusline
      -- TODO: replace this once we can define autocmd using lua
      api.nvim_exec([[
        augroup Statusline
        au!
        au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline('active')
        au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline('inactive')
        augroup END
      ]], false)
    '';
  };
}
