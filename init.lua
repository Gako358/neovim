local utils = require("core.utils")

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

