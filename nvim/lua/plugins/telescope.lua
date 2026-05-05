-- plugins/telescope.lua:
return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        { '<leader>pf', function() require('telescope.builtin').find_files() end, desc = "Find Files" },
        { '<C-p>', function() require('telescope.builtin').git_files() end, desc = "Git Files" },
        { '<leader>ps', function() 
            require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ") })
        end, desc = "Grep String" },
    },
    config = function()
        require('telescope').setup({
            defaults = {
                file_ignore_patterns = {
                    "node_modules/",
                    ".git/",
                    "%.git/",
                    "dist/",
                    "build/",
                    "target/",
                    "%.DS_Store",
                    "%.pyc",
                    "__pycache__/",
                },
            },
            pickers = {
                find_files = {
                    file_ignore_patterns = {
                        "node_modules/",
                        ".git/",
                        "%.git/",
                        "dist/",
                        "build/",
                        "target/",
                        "%.DS_Store",
                        "%.pyc",
                        "__pycache__/",
                    },
                    hidden = false, -- Set to true if you want to see hidden files
                },
            },
        })
    end,
}
