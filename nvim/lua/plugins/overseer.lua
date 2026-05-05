return {
    'stevearc/overseer.nvim',
    keys = {
        { "<leader>rt", "<CMD>OverseerRun<CR>", desc = "Overseer Run" },
        { "<leader>ro", "<CMD>OverseerOpen<CR>", desc = "Overseer Open" },
    },
    opts = {},
    config = function ()
        require("overseer").setup({
            templates = { "builtin", "user.cpp_build" },
        })
    end
}
