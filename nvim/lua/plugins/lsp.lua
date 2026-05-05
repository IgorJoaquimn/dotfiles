-- Alternative LSP setup with blink.cmp (more modern and stable)
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "j-hui/fidget.nvim",
        {
            "saghen/blink.cmp",
            dependencies = "rafamadriz/friendly-snippets",
            version = "v0.*",
            opts = {
                keymap = {
                    preset = 'none',
                    -- Accept the selected suggestion
                    ['<C-Space>'] = { 'select_and_accept' },
                    
                    -- Navigation with arrow keys
                    ['<Up>'] = { 'select_prev', 'fallback' },
                    ['<Down>'] = { 'select_next', 'fallback' },
                    
                    -- Alternative navigation (keeping your C-p/C-n as backup)
                    ['<C-p>'] = { 'select_prev', 'fallback' },
                    ['<C-n>'] = { 'select_next', 'fallback' },
                    
                    -- Other useful keys
                    ['<C-e>'] = { 'hide' },                        -- Hide completion
                    ['<Esc>'] = { 'hide', 'fallback' },            -- Escape to hide
                    
                    -- Documentation scrolling
                    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
                    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
                },
                appearance = {
                    use_nvim_cmp_as_default = true,
                    nerd_font_variant = 'mono'
                },
                sources = {
                    default = { 'lsp', 'path', 'snippets', 'buffer' },
                },
                completion = {
                    documentation = {
                        auto_show = true,
                        auto_show_delay_ms = 500,
                    }
                }
            }
        }
    },

    config = function()
        -- LSP capabilities with blink.cmp
        local capabilities = require('blink.cmp').get_lsp_capabilities()
        
        -- Plugin setups
        require("fidget").setup({})
        require("mason").setup()

        -- Simple LSP server setup (Neovim 0.11+ way)
        local function setup_server(server, opts)
            opts = opts or {}
            opts.capabilities = capabilities
            -- Define configuration and enable the server
            vim.lsp.config(server, opts)
            vim.lsp.enable(server)
        end

        -- LSP servers to install and configure
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "rust_analyzer", "gopls" },
            handlers = {
                -- Default handler
                function(server_name)
                    setup_server(server_name)
                end,

                -- Zig LSP
                zls = function()
                    setup_server("zls", {
                        root_dir = function(fname)
                            return vim.fs.root(fname, { ".git", "build.zig", "zls.json" })
                        end,
                    })
                end,

                -- Lua LSP
                ["lua_ls"] = function()
                    setup_server("lua_ls", {
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "vim" },
                                }
                            }
                        }
                    })
                end,
            }
        })

        -- Diagnostics configuration
        vim.diagnostic.config({
            virtual_text = false,
            signs = true,
            update_in_insert = false,
        })

        -- Keymaps for LSP (using LspAttach for better compatibility with 0.11+)
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                local bufnr = args.buf
                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
                end

                map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                map("n", "gd", vim.lsp.buf.definition, "Go to definition")
                map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
                map("n", "gj", function() vim.diagnostic.goto_next({ float = { source = true } }) end, "Next diagnostic")
                map("n", "gk", function() vim.diagnostic.goto_prev({ float = { source = true } }) end, "Prev diagnostic")
            end,
        })
    end
}
