local u = require("functions.utils")
local debugger_installs = require("plugins.dap.debugger_installs")
local adapters = require("plugins.dap.adapters")
local configurations = require("plugins.dap.configs")

return {
  setup = function()
    local dap = require("dap")

    -- Install debuggers if they don't exist
    debugger_installs.delve()
    debugger_installs.node()


    -- Global DAP Settings
    dap.set_log_level("TRACE")
    vim.fn.sign_define('DapBreakpoint', { text = '🐞' })

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Adapters                                                 │
    -- ╰──────────────────────────────────────────────────────────╯
    -- Neovim needs a debug adapter with which it can communicate. Neovim can either
    -- launch the debug adapter itself, or it can attach to an existing one.
    -- To tell Neovim if it should launch a debug adapter or connect to one, and if
    -- so, how, you need to configure them via the `dap.adapters` table.

    adapters.go(dap)
    adapters.chrome(dap)
    adapters.node2(dap)

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ Configuration                                            │
    -- ╰──────────────────────────────────────────────────────────╯
    -- In addition to launching (possibly) and connecting to a debug adapter, Neovim
    -- needs to instruct the adapter itself how to launch and connect to the program
    -- that you are trying to debug (the debugee).

    configurations.javascript(dap)
    configurations.vue(dap)

    vim.keymap.set("n", "<localleader>ds", function()
      require("dapui").toggle()
      dap.continue()
    end)

    vim.keymap.set("n", "<localleader>dr", function()
      require("dapui").toggle()
      require("dap").run({
        type = "go",
        name = "Debug",
        request = "launch",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        args = function()
          local argument_string = vim.fn.input("Arguments: ")
          return vim.fn.split(argument_string, " ", true)
        end,
      })
    end)

    vim.keymap.set("n", "<localleader>dl", require("dap.ui.widgets").hover)
    vim.keymap.set("n", "<localleader>dc", dap.continue)
    vim.keymap.set("n", "<localleader>db", dap.toggle_breakpoint)
    vim.keymap.set("n", "<localleader>dn", dap.step_over)
    vim.keymap.set("n", "<localleader>di", dap.step_into)
    vim.keymap.set("n", "<localleader>do", dap.step_out)
    vim.keymap.set("n", "<localleader>dC", dap.clear_breakpoints)
    vim.keymap.set("n", "<localleader>de", function()
      require("dapui").toggle()
      require("dap").close()
    end)

    -- Could be used to jump back/forth to a window with a specific name...
    -- vim.keymap.set("n", "<localleader>dl", function()
    --   local buf_name = u.get_current_buf_name()
    --   if buf_name == "DAP Scopes" then
    --     vim.api.nvim_feedkeys(
    --       vim.api.nvim_replace_termcodes("<C-w><C-p>", false, true, true),
    --       "n",
    --       false
    --     )
    --   end
    --   local win = u.get_win_by_buf_name("DAP Scopes")
    --   if win == -1 then
    --     return
    --   end
    --   vim.api.nvim_set_current_win(win)
    -- end)

    require("dapui").setup({
      icons = { expanded = "▾", collapsed = "▸" },
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      expand_lines = vim.fn.has("nvim-0.7"),
      layouts = {
        {
          elements = {
            "scopes",
          },
          size = 0.3,
          position = "right"
        },
        {
          elements = {
            "breakpoints",
            "stacks",
          },
          size = 0.3,
          position = "right",
        },
        {
          elements = {
            "repl",
          },
          size = 0.15,
          position = "bottom",
        },
      },
      floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = "single", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      windows = { indent = 1 },
      render = {
        max_type_length = nil,
      },
    })
  end,
}
