function EventListener()

    local dap = require "dap"
    local ui = require "dapui"
    dap.listeners.before.attach.dapui_config = function()
        ui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
        ui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
    end
end

return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "leoluz/nvim-dap-go",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
        },
        keys = {
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
            { "<leader>dc", function() require("dap").continue() end, desc = "DAP Continue" },
            { "<leader>d1", function() require("dap").run_to_cursor() end, desc = "DAP Run to Cursor" },
            { "<leader>d2", function() require("dap").step_into() end, desc = "DAP Step Into" },
            { "<leader>d3", function() require("dap").step_over() end, desc = "DAP Step Over" },
            { "<leader>d4", function() require("dap").step_out() end, desc = "DAP Step Out" },
            { "<leader>d5", function() require("dap").step_back() end, desc = "DAP Step Back" },
            { "<leader>d6", function() require("dap").restart() end, desc = "DAP Restart" },
            { "<leader>?", function() require("dapui").eval(nil, { enter = true }) end, desc = "DAP Eval" },
        },
        config = function()
            local dap = require "dap"

            require("dapui").setup()
            require("dap-go").setup()

            -- Adapters
            -- C, C++, Rust
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = os.getenv("HOME") .. "/.local/share/nvim/mason/bin/codelldb",
                    args = { "--port", "${port}" },
                },
            }

            local codelldb = {
                type = 'codelldb',
                request = 'launch',
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd()..'/', 'file')
                end,
                cwd = '${workspaceFolder}',
                terminal = 'integrated'
            }

            dap.configurations.c = {codelldb}
            dap.configurations.cpp = {codelldb}
            dap.configurations.rust = {codelldb}

            dap.configurations.python = {
                {
                    type = 'python';
                    request = 'launch';
                    name = "Launch file";
                    program = "${file}";
                },
            }

            EventListener()
        end,
    },
}
