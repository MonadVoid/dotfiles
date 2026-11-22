-- Isolated private state encapsulation
local ns_id = vim.api.nvim_create_namespace("emacs_mark_ring")
local mark_stack = {}
local current_index = 0

-- Helper: Defensive memory management to prune destroyed buffers
local function clean_and_validate_stack()
  local valid_stack = {}
  for _, mark in ipairs(mark_stack) do
    if vim.api.nvim_buf_is_valid(mark.buf) then
      table.insert(valid_stack, mark)
    end
  end
  mark_stack = valid_stack
  
  -- Prevent the pointer from drifting out of table limits
  if current_index > #mark_stack then
    current_index = #mark_stack
  elseif current_index < 1 and #mark_stack > 0 then
    current_index = 1
  end
end

-- Core Function: Push an anonymous mark onto the stack
local function push_mark()
  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  
  -- Create an Extmark: structural positioning that survives text deletion/shifts
  local id = vim.api.nvim_buf_set_extmark(buf, ns_id, cursor[1] - 1, cursor[2], {
    invalidate = false, 
  })
  
  table.insert(mark_stack, { buf = buf, id = id })
  current_index = #mark_stack
  vim.notify("Mark set anonymously", vim.log.levels.INFO, { title = "Mark Ring" })
end

-- Helper: Execute atomic jump sequence
local function execute_jump(idx)
  if idx < 1 or idx > #mark_stack then return end
  local mark = mark_stack[idx]
  if not mark then return end

  -- Fetch live structural coordinate offsets from the C-engine
  local pos = vim.api.nvim_buf_get_extmark_by_id(mark.buf, ns_id, mark.id, {})
  if pos and #pos > 0 then
    vim.api.nvim_set_current_buf(mark.buf)
    vim.api.nvim_win_set_cursor(0, { pos[1] + 1, pos[2] })
  end
end

-- Core Function: Move backward through stack history (Like C-u C-SPC)
local function prev_mark()
  clean_and_validate_stack()
  if #mark_stack == 0 then
    vim.notify("Mark ring is empty", vim.log.levels.WARN, { title = "Mark Ring" })
    return
  end

  -- Decrement pointer first, wrap to the top if we run off the bottom
  current_index = current_index - 1
  if current_index < 1 then
    current_index = #mark_stack
  end

  execute_jump(current_index)
end

-- Core Function: Move forward through stack history
local function next_mark()
  clean_and_validate_stack()
  if #mark_stack == 0 then
    vim.notify("Mark ring is empty", vim.log.levels.WARN, { title = "Mark Ring" })
    return
  end

  -- Increment pointer first, wrap to the bottom if we run off the top
  current_index = current_index + 1
  if current_index > #mark_stack then
    current_index = 1
  end

  execute_jump(current_index)
end

-- Core Function: Clean memory flush
local function clear_marks()
  for _, mark in ipairs(mark_stack) do
    if vim.api.nvim_buf_is_valid(mark.buf) then
      vim.api.nvim_buf_clear_namespace(mark.buf, ns_id, 0, -1)
    end
  end
  mark_stack = {}
  current_index = 0
  vim.notify("Mark ring cleared", vim.log.levels.INFO, { title = "Mark Ring" })
end

return {
  -- Explicit, isolated declarative Which-key mapping injection
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, {
        { "<leader>m", group = "marks (emacs-style)", icon = { icon = "󰈚 ", color = "blue" } },
      })
    end,
  },

  -- Map to user initialization lifecycle boundaries
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.keymap.set("n", "<leader>mm", push_mark, { desc = "Set Anonymous Mark" })
      vim.keymap.set("n", "<leader>mp", prev_mark, { desc = "Jump to Previous Mark" })
      vim.keymap.set("n", "<leader>mn", next_mark, { desc = "Jump to Next Mark" })
      vim.keymap.set("n", "<leader>mc", clear_marks, { desc = "Clear Mark Stack" })
    end,
  },
}
