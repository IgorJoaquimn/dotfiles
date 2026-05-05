return {
    'rcarriga/nvim-notify',
    config = function()
        require('notify').setup({
            background_colour = 'Normal',
            stages = 'fade',
            timeout = 3000,
            max_width = 50,
            minimum_width = 20,
            render = 'compact',
        })
        vim.notify = require('notify')
    end,
}
