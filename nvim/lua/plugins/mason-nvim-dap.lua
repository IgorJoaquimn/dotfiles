return {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = { 'williamboman/mason.nvim', 'mfussenegger/nvim-dap'},
    config = function ()
        require('mason-nvim-dap').setup({
            -- Lista de adaptadores que o Mason deve garantir que estejam instalados
            ensure_installed = { "codelldb" },

            -- Esta função configura automaticamente os adaptadores para o nvim-dap
            automatic_installation = true,
        })
    end
}
