local function human_size(bytes)
    local units = { "B", "K", "M", "G", "T" }
    local i = 1
    local n = bytes
    while n >= 1024 and i < #units do
        n = n / 1024
        i = i + 1
    end
    if i == 1 then
        return string.format("%5d%s", n, units[i])
    end
    return string.format("%5.1f%s", n, units[i])
end

local PERM = { "---", "--x", "-w-", "-wx", "r--", "r-x", "rw-", "rwx" }
local function perms_str(mode, ftype)
    local t = ftype == "directory" and "d" or ftype == "link" and "l" or "-"
    local u = PERM[bit.band(bit.rshift(mode, 6), 7) + 1]
    local g = PERM[bit.band(bit.rshift(mode, 3), 7) + 1]
    local o = PERM[bit.band(mode, 7) + 1]
    return t .. u .. g .. o
end

local uv = vim.uv or vim.loop

local function stat_transform(item)
    if not item.file then return end
    local s = uv.fs_stat(item.file)
    if not s then return end
    item.perms = perms_str(s.mode, s.type)
    item.size = human_size(s.size)
end

vim.api.nvim_set_hl(0, "SnacksPickerPermsType", { default = true, link = "Directory" })
vim.api.nvim_set_hl(0, "SnacksPickerPermsRead", { default = true, link = "DiagnosticOk" })
vim.api.nvim_set_hl(0, "SnacksPickerPermsWrite", { default = true, link = "DiagnosticWarn" })
vim.api.nvim_set_hl(0, "SnacksPickerPermsExec", { default = true, link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "SnacksPickerPermsNone", { default = true, link = "Comment" })
vim.api.nvim_set_hl(0, "SnacksPickerSize", { default = true, link = "Number" })

local PERM_HL = {
    ["-"] = "SnacksPickerPermsNone",
    ["r"] = "SnacksPickerPermsRead",
    ["w"] = "SnacksPickerPermsWrite",
    ["x"] = "SnacksPickerPermsExec",
    ["d"] = "SnacksPickerPermsType",
    ["l"] = "SnacksPickerPermsType",
}

local BLANK = string.rep(" ", #"-rw-r--r--" + 1 + 6 + 2)

local function format_file_stat(item, picker)
    local ret = {}
    if item.perms then
        for i = 1, #item.perms do
            local c = item.perms:sub(i, i)
            ret[#ret + 1] = { c, PERM_HL[c] }
        end
        ret[#ret + 1] = { " " }
        ret[#ret + 1] = { item.size, "SnacksPickerSize" }
        ret[#ret + 1] = { "  " }
    else
        ret[#ret + 1] = { BLANK }
    end
    vim.list_extend(ret, Snacks.picker.format.file(item, picker))
    return ret
end

return {
    {
        "folke/snacks.nvim",
        lazy = false,
        priority = 1000,
        keys = {
            -- explorer
            { "<leader>e",        function() Snacks.explorer() end,                                       desc = "Explorer" },
            { "<leader>fe",       function() Snacks.explorer() end,                                       desc = "Explorer" },
            -- lazygit
            { "<leader>gg",       function() Snacks.lazygit() end,                                        desc = "Lazygit" },
            { "<leader>gG",       function() Snacks.lazygit({ cwd = vim.fn.getcwd() }) end,               desc = "Lazygit (cwd)" },
            -- find
            { "<leader><leader>", function() Snacks.picker.files() end,                                   desc = "Find Files" },
            { "<leader>,",        function() Snacks.picker.buffers() end,                                 desc = "Switch Buffer" },
            { "<leader>/",        function() Snacks.picker.grep() end,                                    desc = "Live Grep" },
            { "<leader>:",        function() Snacks.picker.command_history() end,                         desc = "Command History" },
            { "<leader>fb",       function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
            { "<leader>fg",       function() Snacks.picker.git_files() end,                               desc = "Find Files (git)" },
            { "<leader>fh",       function() Snacks.picker.help() end,                                    desc = "Help" },
            { "<leader>fc",       function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
            { "<leader>fr",       function() Snacks.picker.recent() end,                                  desc = "Recent" },
            -- git
            { "<leader>gc",       function() Snacks.picker.git_log() end,                                 desc = "Commits" },
            { "<leader>gs",       function() Snacks.picker.git_status() end,                              desc = "Status" },
            -- search
            { '<leader>s"',       function() Snacks.picker.registers() end,                               desc = "Registers" },
            { "<leader>sa",       function() Snacks.picker.autocmds() end,                                desc = "Auto Commands" },
            { "<leader>sb",       function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
            { "<leader>sc",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
            { "<leader>sC",       function() Snacks.picker.commands() end,                                desc = "Commands" },
            { "<leader>sd",       function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
            { "<leader>sD",       function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
            { "<leader>sg",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
            { "<leader>sh",       function() Snacks.picker.help() end,                                    desc = "Help Pages" },
            { "<leader>sH",       function() Snacks.picker.highlights() end,                              desc = "Search Highlight Groups" },
            { "<leader>sj",       function() Snacks.picker.jumps() end,                                   desc = "Jumplist" },
            { "<leader>sk",       function() Snacks.picker.keymaps() end,                                 desc = "Key Maps" },
            { "<leader>sl",       function() Snacks.picker.loclist() end,                                 desc = "Location List" },
            { "<leader>sm",       function() Snacks.picker.marks() end,                                   desc = "Jump to Mark" },
            { "<leader>sR",       function() Snacks.picker.resume() end,                                  desc = "Resume" },
            { "<leader>sq",       function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
            { "<leader>sw",       function() Snacks.picker.grep_word() end,                               desc = "Word under Cursor",       mode = { "n", "x" } },
            { "<leader>uC",       function() Snacks.picker.colorschemes() end,                            desc = "Colorscheme with Preview" },
            -- terminal
            { "<C-/>",            function() Snacks.terminal() end,                                       desc = "Terminal",                mode = { "n", "t" } },
            { "<C-_>",            function() Snacks.terminal() end,                                       desc = "which_key_ignore",        mode = { "n", "t" } },
            { "<leader>ft",       function() Snacks.terminal() end,                                       desc = "Terminal" },
            { "<leader>sn",       function() Snacks.notifier.show_history() end,                          desc = "Notification History" },
            { "<leader>ss",       function() Snacks.picker.lsp_symbols() end,                             desc = "Goto Symbol" },
            { "<leader>sS",       function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "Goto Symbol (Workspace)" },
            -- zoom
            { "<leader>wz",       function() Snacks.zen.zoom() end,                                       desc = "Zoom" },
        },
        opts = {
            terminal = { win = { wo = { winbar = "", winhighlight = "Normal:Normal" } } },
            notifier = { enabled = true },
            input = { enabled = true },
            picker = {
                ui_select = true,
                layout = {
                    preset = "ivy",
                },
                sources = {
                    files = { format = format_file_stat, transform = stat_transform, layout = { preset = "ivy", hidden = { "preview" } } },
                    recent = { format = format_file_stat, transform = stat_transform, layout = { preset = "ivy", hidden = { "preview" } } },
                    git_files = { format = format_file_stat, transform = stat_transform, layout = { preset = "ivy", hidden = { "preview" } } },
                    smart = { format = format_file_stat, transform = stat_transform, layout = { preset = "ivy", hidden = { "preview" } } },
                    buffers = { layout = { preset = "ivy", hidden = { "preview" } } },
                },
            },
            explorer = { enabled = true },
            lazygit = {
                enabled = true,
                theme = {
                    activeBorderColor = { fg = "MatchParen", bold = true },
                    cherryPickedCommitBgColor = { fg = "Identifier" },
                    cherryPickedCommitFgColor = { fg = "Function" },
                    defaultFgColor = { fg = "Normal" },
                    inactiveBorderColor = { fg = "FloatBorder" },
                    optionsTextColor = { fg = "Function" },
                    searchingActiveBorderColor = { fg = "MatchParen", bold = true },
                    selectedLineBgColor = { bg = "Visual" },
                    unstagedChangesColor = { fg = "DiagnosticError" },
                },
            },
            statuscolumn = { enabled = true },
            zen = { enabled = true },
            dashboard = {
                enabled = true,
                preset = {
                    header = table.concat({
                        [[                               __                ]],
                        [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
                        [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
                        [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
                        [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
                        [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
                    }, "\n"),
                    keys = {
                        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
                        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
                        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
                        {
                            icon = " ",
                            key = "c",
                            desc = "Config",
                            action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })",
                        },
                        { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
                    footer = "",
                },
            },
        },
    },
}
