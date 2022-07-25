-- Import Lua modules
-- load basic configuration
local utils = require("core.utils")

-- Try to call the cache plugin
pcall(require, "impatient")

for _, module_name in
  ipairs({ "core.colors", "core.keymaps", "core.settings" })
do
  local ok, err = pcall(require, module_name)
  if not ok then
    local msg = "calling module: " .. module_name .. " fail: " .. err
    utils.errorL(msg)
  end
end

-- vim.defer_fn(function()
--   require("plugins").load()
-- end, 0)
