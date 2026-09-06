local M = {}

local last_args = ""

local function cargo_root()
  return vim.fs.root(0, "Cargo.toml") or vim.fn.getcwd()
end

local function rust_env(root)
  local paths = {}
  local libdir = vim.fn.system({ "rustc", "--print", "target-libdir" }):gsub("%s+$", "")
  if vim.v.shell_error == 0 and libdir ~= "" then
    table.insert(paths, libdir)
  end
  local deps = vim.fs.joinpath(root, "target", "debug", "deps")
  if vim.uv.fs_stat(deps) then
    table.insert(paths, deps)
  end
  if #paths == 0 then
    return nil
  end
  local existing = vim.uv.os_getenv("LD_LIBRARY_PATH")
  return {
    LD_LIBRARY_PATH = table.concat(paths, ":") .. (existing and ":" .. existing or ""),
  }
end

local function launch(program, args)
  local root = cargo_root()
  require("dap").run({
    name = "Launch cargo",
    type = "codelldb",
    request = "launch",
    program = program,
    args = args,
    cwd = root,
    stopOnEntry = false,
    breakpointMode = "file",
    initCommands = { "settings set target.inline-breakpoint-strategy always" },
    sourceLanguages = { "rust" },
    env = rust_env(root),
  })
end

local function pick_executable(cargo_args, callback)
  local root = cargo_root()
  local cmd = vim.list_extend({ "cargo" }, cargo_args)
  table.insert(cmd, "--message-format=json")
  vim.notify("Building a debug build for debugging. This might take some time...")
  vim.system(cmd, { cwd = root, text = true }, function(sc)
    if sc.code ~= 0 then
      vim.schedule(function()
        vim.notify("cargo failed:\n" .. (sc.stderr or ""), vim.log.levels.ERROR)
      end)
      return
    end
    local executables = {}
    for line in (sc.stdout or ""):gmatch("[^\r\n]+") do
      local ok, artifact = pcall(vim.json.decode, line)
      if ok and type(artifact) == "table" and artifact.reason == "compiler-artifact" then
        local is_bin = vim.list_contains(artifact.target.crate_types, "bin")
        local is_build_script = vim.list_contains(artifact.target.kind, "custom-build")
        local is_test = (artifact.profile.test == true and artifact.executable ~= nil)
          or vim.list_contains(artifact.target.kind, "test")
        if
          (cargo_args[1] == "build" and is_bin and not is_build_script)
          or (cargo_args[1] == "test" and is_test)
        then
          table.insert(executables, artifact.executable)
        end
      end
    end
    vim.schedule(function()
      if #executables == 0 then
        vim.notify("No compilation artifacts found.", vim.log.levels.ERROR)
        return
      end
      if #executables == 1 then
        callback(executables[1])
        return
      end
      vim.ui.select(executables, { prompt = "Select executable: " }, function(choice)
        if choice then
          callback(choice)
        end
      end)
    end)
  end)
end

function M.debug()
  pick_executable({ "build" }, function(exe)
    last_args = vim.fn.input({ prompt = "Program args: ", default = last_args })
    launch(exe, require("dap.utils").splitstr(last_args))
  end)
end

function M.debug_test()
  pick_executable({ "test", "--no-run" }, function(exe)
    launch(exe, {})
  end)
end

function M.continue()
  local dap = require("dap")
  if dap.session() then
    dap.continue()
  elseif vim.bo.filetype == "rust" then
    M.debug()
  else
    dap.continue()
  end
end

return M
