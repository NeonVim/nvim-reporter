local f = require("functions")
local u = require("functions.utils")

vim.keymap.set("n", "<localleader>dl", require("dap.ui.widgets").hover)

return {
  setup = function()
    local dap = require("dap")

    local node_debug_folder = u.get_home() .. "/dev/microsoft/vscode-node-debug2"
    if vim.fn.isdirectory(node_debug_folder) == 0 then
      f.run_script("install_node_debugger", u.get_home())
    end

    local delve = u.get_home() .. "/go/bin/dlv"
    if vim.fn.filereadable(delve) == 0 then
      os.execute("go install github.com/go-delve/delve/cmd/dlv@latest")
    end

    dap.adapters.go = function(callback, config)
      local stdout = vim.loop.new_pipe(false)
      local handle
      local pid_or_err
      local port = 38697
      local opts = {
        stdio = { nil, stdout },
        args = { "dap", "-l", "127.0.0.1:" .. port },
        detached = true,
      }
      handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
        stdout:close()
        handle:close()
        if code ~= 0 then
          print("dlv exited with code", code)
        end
      end)
      assert(handle, "Error running dlv: " .. tostring(pid_or_err))
      stdout:read_start(function(err, chunk)
        assert(not err, err)
        if chunk then
          vim.schedule(function()
            require("dap.repl").append(chunk)
          end)
        end
      end)
      vim.defer_fn(function()
        callback({ type = "server", host = "127.0.0.1", port = port })
      end, 100)
    end

    dap.configurations.go = {
      {
        type = "go",
        name = "Debug",
        request = "launch",
        program = "${file}",
      },
      {
        type = "go",
        name = "Debug test",
        request = "launch",
        mode = "test",
        program = "${file}",
      },
      {
        type = "go",
        name = "Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}",
      },
    }

    dap.adapters.node2 = {
      type = "executable",
      command = "node",
      args = { os.getenv("HOME") .. "/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js" },
    }

    dap.configurations.javascript = {
      {
        name = "Launch",
        type = "node2",
        request = "launch",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
      },
      {
        -- For this to work you need to make sure the node process is started with the `--inspect` flag.
        name = "Attach to process",
        type = "node2",
        request = "attach",
        processId = require("dap.utils").pick_process,
      },
    }

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

    vim.keymap.set("n", "<localleader>dc", dap.continue)
    vim.keymap.set("n", "<localleader>db", dap.toggle_breakpoint)
    vim.keymap.set("n", "<localleader>dn", dap.step_over)
    vim.keymap.set("n", "<localleader>di", dap.step_into)
    vim.keymap.set("n", "<localleader>do", dap.step_out)
    vim.keymap.set("n", "<localleader>dcb", dap.clear_breakpoints)
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
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      -- Expand lines larger than the window
      -- Requires >= 0.7
      expand_lines = vim.fn.has("nvim-0.7"),
      -- Layouts define sections of the screen to place windows.
      -- The position can be "left", "right", "top" or "bottom".
      -- The size specifies the height/width depending on position. It can be an Int
      -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
      -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
      -- Elements are the elements shown in the layout (in order).
      -- Layouts are opened in order so that earlier layouts take priority in window sizing.
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
          size = 0.3, -- 40 columns
          position = "right",
        },
        {
          elements = {
            "repl",
          },
          size = 0.15, -- 25% of total lines
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
        max_type_length = nil, -- Can be integer or nil.
      },
    })
  end,
}
