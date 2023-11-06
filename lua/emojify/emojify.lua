-- Description -----------------------------------------------------------------------------
--
-- Function to emojify the current buffer.
--
-- -----------------------------------------------------------------------------------------

local M = {}

-- Create our namespace.
local ns = vim.api.nvim_create_namespace("emojify")

--- Emojify the current buffer.
function M.emojify()
  local emoji_map = require("emojify.map").emoji_map

  -- Current window ID.
  local winid = vim.api.nvim_get_current_win()

  -- Get the visible lines to avoid parsing too many lines.
  local win_lines = vim.api.nvim_win_call(
    winid,
    function ()
      return { vim.fn.line("w0"), vim.fn.line("w$") }
    end
  )

  -- Get the current buffer.
  local buf = vim.api.nvim_get_current_buf()

  -- Get the lines in the buffer.
  local lines = vim.api.nvim_buf_get_lines(buf, win_lines[1] - 1, win_lines[2], true)

  -- Clear everything in our namepsace at the current buffer.
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  -- Parse each line.
  for k, line in pairs(lines) do
    local cstart
    local cend

    -- `row_id` is the row number in the buffer related to the `line`.
    local row_id = win_lines[1] + k - 2

    cend = 0

    while true do
      cstart, cend = string.find(line, ":[^:%s]*:", cend + 1)

      if ((cstart == nil) or (cend == nil)) then
        break
      end

      -- Get the emoji related with the string.
      local emoji = emoji_map[string.sub(line, cstart, cend)]

      if emoji ~= nil then
        vim.api.nvim_buf_set_extmark(
          buf,
          ns,
          row_id,
          cstart - 1,
          {
            conceal = emoji,
            end_col = cend,
            end_row = row_id,
          })
      end
    end

    ::continue::
  end
end

--- Emojify all the valid buffers.
function M.emojify_all_buffers()
  for _, buf in pairs(vim.api.nvim_list_bufs()) do
    if (vim.api.nvim_buf_is_valid(buf)) then
      vim.api.nvim_buf_call(buf, M.emojify)
    end
  end
end

--- Unemojify all the valid buffers.
function M.unemojify_all_buffers()
  for _, buf in pairs(vim.api.nvim_list_bufs()) do
    if (vim.api.nvim_buf_is_valid(buf)) then
      vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    end
  end
end

return M
