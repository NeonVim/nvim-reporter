local ts_utils = require("nvim-treesitter.ts_utils")
local M = {}

local get_parent = function (node)
  local prev = ts_utils.get_previous_node(node, true, true)
  while(prev:parent() == node:parent()) do
    node = prev
    if(ts_utils.get_previous_node(prev, true, true) == nil) then
      -- If we're at the last node...
      return node
    end
    prev = ts_utils.get_previous_node(prev, true, true)
  end

  return node

end

_G.get_tag_name_from_element = function (node)
  for n in node:iter_children() do
    if(n == nil) then
      error("That node has no children")
    end
    local type = n:type()
    if type == 'tag_name' then
      return n
    end

    -- Recurse until finding tag_name
    if n:child_count() ~= 0 then
      return get_tag_name_from_element(n)
    end

  end
  error("Could not find tag name.")
end

local get_master_node = function ()
  local node = ts_utils.get_node_at_cursor()
  if node == nil then
    error("No Treesitter parser found.")
  end

  local start_row = node:start()
  local parent = node:parent()

  while(parent ~= nil and parent:start() == start_row) do
    node = parent
    parent = node:parent()
  end

  return node
end

M.getParent = function ()
  local node = get_master_node()
  local parent = get_parent(node)
  ts_utils.goto_node(parent)
end

M.getNextSibling = function ()
  local node = get_master_node()
  local sibling = node:next_sibling()
  if sibling == nil then
    error("This is the last element.")
  end

  local tag_name = get_tag_name_from_element(sibling)
  ts_utils.goto_node(tag_name)
end

M.getPrevSibling = function ()
  local node = get_master_node()
  local sibling = node:prev_sibling()
  if sibling == nil then
    error("This is the last element.")
  end

  local tag_name = get_tag_name_from_element(sibling)
  ts_utils.goto_node(tag_name)
end

return M
