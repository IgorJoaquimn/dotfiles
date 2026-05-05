return {
    -- Colorscheme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,

        config = function()
            vim.cmd("colorscheme catppuccin")
        end
    },

    'nvim-lua/plenary.nvim',
}
