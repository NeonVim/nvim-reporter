local colors = require("colorscheme")
return {
  "rcarriga/nvim-notify",
  opts = {
    background_colour = colors.sumiInk1,
  },
  config = function()
    vim.api.nvim_set_hl(0, 'NotifyERRORBorder', { fg = colors.samuraiRed })
    vim.api.nvim_set_hl(0, 'NotifyERRORTitle', { fg = colors.samuraiRed })
    vim.api.nvim_set_hl(0, 'NotifyERRORIcon', { fg = colors.samuraiRed })
    vim.api.nvim_set_hl(0, 'NotifyWARNBorder', { fg = colors.roninYellow })
    vim.api.nvim_set_hl(0, 'NotifyWARNTitle', { fg = colors.roninYellow })
    vim.api.nvim_set_hl(0, 'NotifyWARNIcon', { fg = colors.roninYellow })
    vim.api.nvim_set_hl(0, 'NotifyINFOBorder', { fg = colors.springGreen })
    vim.api.nvim_set_hl(0, 'NotifyINFOTitle', { fg = colors.springGreen })
    vim.api.nvim_set_hl(0, 'NotifyINFOIcon', { fg = colors.springGreen })
    vim.api.nvim_set_hl(0, 'NotifyDEBUGBorder', { fg = colors.fujiGray })
    vim.api.nvim_set_hl(0, 'NotifyDEBUGTitle', { fg = colors.fujiGray })
    vim.api.nvim_set_hl(0, 'NotifyDEBUGIcon', { fg = colors.fujiGray })
    vim.api.nvim_set_hl(0, 'NotifyTRACEBorder', { fg = colors.fujiGray })
    vim.api.nvim_set_hl(0, 'NotifyTRACETitle', { fg = colors.fujiGray })
    vim.api.nvim_set_hl(0, 'NotifyTRACEIcon', { fg = colors.fujiGray })

local stages_util = require("notify.stages.util")
    require("notify").setup({
      fps = 60,
      timeout = 2000,
      top_down = true,
      stages = {
        function(state)
          local next_row = stages_util.available_slot(
            state.open_windows,
            state.message.height + 2,
            stages_util.DIRECTION.TOP_DOWN
          )

          if not next_row then
            return nil
          end

          return {
            relative = "editor",
            anchor = "NE",
            width = state.message.width,
            height = state.message.height,
            col = 1,
            row = next_row,
            border = "rounded",
            style = "minimal",
            opacity = 0,
          }
        end,
        function(state, win)
          return {
            opacity = { 100 },
            col = { 1 },
            row = {
              stages_util.slot_after_previous(
                win,
                state.open_windows,
                stages_util.DIRECTION.TOP_DOWN
              ),
              frequency = 3,
              complete = function()
                return true
              end,
            },
          }
        end,
        function(state, win)
          return {
            col = { 1 },
            time = true,
            row = {
              stages_util.slot_after_previous(
                win,
                state.open_windows,
                stages_util.DIRECTION.TOP_DOWN
              ),
              frequency = 3,
              complete = function()
                return true
              end,
            },
          }
        end,
        function(state, win)
          return {
            width = {
              1,
              frequency = 2.5,
              damping = 0.9,
              complete = function(cur_width)
                return cur_width < 3
              end,
            },
            opacity = {
              0,
              frequency = 2,
              complete = function(cur_opacity)
                return cur_opacity <= 4
              end,
            },
            col = { 1 },
            row = {
              stages_util.slot_after_previous(
                win,
                state.open_windows,
                stages_util.DIRECTION.TOP_DOWN
              ),
              frequency = 3,
              complete = function()
                return true
              end,
            },
          }
        end,
      },
      render = function(bufnr, notif, highlights)
        local base = require("notify.render.base")
        local namespace = base.namespace()
        local padded_message = vim.tbl_map(function(line)
          return " " .. line
        end, notif.message)
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, padded_message)

        vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
          hl_group = highlights.icon,
          end_line = #notif.message - 1,
          end_col = #notif.message[#notif.message] + 1,
          priority = 50,
        })
      end,
    })
  end
}
