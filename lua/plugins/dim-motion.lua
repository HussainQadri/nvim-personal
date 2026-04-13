-- Dim effect on f/F/t/T (vanilla motions, no plugin)
local ns = vim.api.nvim_create_namespace("fdim")

local function dim_line()
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  vim.api.nvim_buf_set_extmark(0, ns, row, 0, {
    end_row = row + 1,
    end_col = 0,
    hl_group = "Comment",
    hl_eol = true,
    priority = 200,
  })
end

local function clear_dim()
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
end

local function dim_motion(key)
  return function()
    dim_line()
    vim.schedule(function()
      -- redraw so the dim is visible before getcharstr blocks
      vim.cmd("redraw")
      local ok, ch = pcall(vim.fn.getcharstr)
      if ok and ch and ch ~= "\27" then -- not <Esc>
        -- Use feedkeys so counts, operator-pending, visual all work natively
        vim.api.nvim_feedkeys(key .. ch, "nt", false)
      end
      -- Clear dim after the motion executes
      vim.schedule(clear_dim)
    end)
  end
end

for _, m in ipairs({ "n", "x", "o" }) do
  for _, k in ipairs({ "f", "F", "t", "T" }) do
    vim.keymap.set(m, k, dim_motion(k), { desc = "Dim " .. k })
  end
end

return {}
