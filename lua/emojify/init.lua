-- emojify.nvim --- Render emojis in Neovim ------------------------------------------------
--
-- Copyright (C) 2023  Ronan Arraes Jardim Chagas
--
-- License ---------------------------------------------------------------------------------
--
-- emojify.nvim - Render emojis in Neovim
-- Copyright (C) 2023  Ronan Arraes Jardim Chagas
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.
--
-- -----------------------------------------------------------------------------------------

local M = {}

local emojify = require("emojify.emojify")
local emojify_enabled = false

--- Disable emojify globally.
function M.disable_emojify()
  emojify.unemojify_all_buffers()
  vim.api.nvim_clear_autocmds({ group = "emojify" })
  emojify_enabled = false
end

--- Enable emojify globally.
function M.enable_emojify()
  emojify.emojify_all_buffers()
  vim.api.nvim_create_autocmd(
    {
      "CursorMoved",
      "CursorMovedI",
      "TextChanged",
      "TextChangedI"
    },
    {
      pattern = "*",
      callback = emojify.emojify,
      group = "emojify",
      desc = "Emojify buffer"
    }
  )
  emojify_enabled = true
end

--- Toggle emojify mode globaly.
function M.toggle_emojify()
  if emojify_enabled then
    M.disable_emojify()
  else
    M.enable_emojify()
  end
end

--- Setup emojify.
function M.setup()
  vim.api.nvim_create_augroup("emojify", { clear = true })
  vim.api.nvim_create_user_command("Emojify", M.toggle_emojify, { })
end

return M
