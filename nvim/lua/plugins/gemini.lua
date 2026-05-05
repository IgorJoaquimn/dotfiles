return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
            terminal = { enabled = true },
            picker = { enabled = true },
        },
    },
    {
        "marcinjahn/gemini-cli.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "folke/snacks.nvim",
        },
        cmd = { "Gemini" },
        opts = {
            -- You can add your configuration here
            -- See the plugin's documentation for available options
        },
        keys = {
            { "<leader>gc", "<cmd>Gemini<cr>", desc = "Gemini Chat" },
        },
    },
}
