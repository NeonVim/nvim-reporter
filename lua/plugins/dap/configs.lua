-- Launch or attach to a running Javascript process
local function javascript(dap)
  dap.configurations.javascript = {
    {
      type = 'node2';
      name = 'Launch',
      request = 'launch';
      program = '${file}';
      cwd = vim.fn.getcwd();
      sourceMaps = true;
      protocol = 'inspector';
      console = 'integratedTerminal';
    },
    {
      type = 'node2';
      name = 'Attach',
      request = 'attach';
      program = '${file}';
      cwd = vim.fn.getcwd();
      sourceMaps = true;
      protocol = 'inspector';
      console = 'integratedTerminal';
    },
  }
end

-- Attach to a Chrome browser running in debug mode
local chrome = {
  type = 'chrome',
  name = 'Debug (Chrome)',
  request = 'attach',
  program = 'app.js',
  cwd = vim.fn.getcwd(),
  sourceMaps = true,
  protocol = 'inspector',
  port = 9222,
  webRoot = "${worspaceFolder}",
}

local function vue(dap)
  dap.configurations.vue = {
    chrome,
  }
end

local function javascriptreact(dap)
  dap.configurations.javascriptreact = {
    chrome,
  }
end

local function go(dap)
  dap.configurations.go = {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = "${file}",
    },
    {
      type = "go",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
    },
    -- Build the binary (go build -gcflags=all="-N -l") and run it + pick it
    {
      type = "go",
      name = "Attach",
      mode = "local",
      request = "attach",
      processId = require('plugins.dap.utils').pick_process,
    },
  }
end

return {
  javascript = javascript,
  javascriptreact = javascriptreact,
  vue = vue,
  go = go
}