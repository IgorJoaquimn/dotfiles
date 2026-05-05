return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
            { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
        },
        build = "make tiktoken", -- Only on MacOS or Linux
        keys = {
            -- Basic chat
            { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Copilot Chat Toggle" },
            
            -- Agent-like actions
            { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "Copilot Explain Code" },
            { "<leader>ccr", "<cmd>CopilotChatReview<cr>", desc = "Copilot Review Code" },
            { "<leader>ccf", "<cmd>CopilotChatFix<cr>", desc = "Copilot Fix Code" },
            { "<leader>cco", "<cmd>CopilotChatOptimize<cr>", desc = "Copilot Optimize Code" },
            { "<leader>ccR", "<cmd>CopilotChatRefactor<cr>", desc = "Copilot Refactor Code" },
            { "<leader>ccd", "<cmd>CopilotChatDocs<cr>", desc = "Copilot Generate Docs" },
            { "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "Copilot Generate Tests" },
            { "<leader>ccg", "<cmd>CopilotChatCommit<cr>", desc = "Copilot Generate Commit" },
            
            -- Visual mode actions (agent-like editing)
            { "<leader>cce", "<cmd>CopilotChatExplain<cr>", mode = "v", desc = "Copilot Explain Selection" },
            { "<leader>ccr", "<cmd>CopilotChatReview<cr>", mode = "v", desc = "Copilot Review Selection" },
            { "<leader>ccf", "<cmd>CopilotChatFix<cr>", mode = "v", desc = "Copilot Fix Selection" },
            { "<leader>cco", "<cmd>CopilotChatOptimize<cr>", mode = "v", desc = "Copilot Optimize Selection" },
            { "<leader>ccR", "<cmd>CopilotChatRefactor<cr>", mode = "v", desc = "Copilot Refactor Selection" },
            { "<leader>ccd", "<cmd>CopilotChatDocs<cr>", mode = "v", desc = "Copilot Document Selection" },
            { "<leader>cct", "<cmd>CopilotChatTests<cr>", mode = "v", desc = "Copilot Test Selection" },
            
            -- Custom prompts (most agent-like)
            { "<leader>ccp", function()
                local input = vim.fn.input("Quick Chat: ")
                if input ~= "" then
                    require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
                end
            end, desc = "Copilot Quick Chat" },
            
            { "<leader>ccv", function()
                local input = vim.fn.input("Quick Chat (Visual): ")
                if input ~= "" then
                    require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
                end
            end, mode = "v", desc = "Copilot Quick Chat Visual" },
            
            -- Apply/Accept changes keybinds
            { "<leader>cca", "<cmd>CopilotChatAccept<cr>", desc = "Copilot Accept Changes" },
            { "<leader>ccx", function()
                -- Apply the diff from the chat to the current buffer
                local chat = require("CopilotChat")
                chat.apply_diff()
            end, desc = "Copilot Apply Diff" },
        },
        config = function()
            require("CopilotChat").setup({
            question_header = "## User ",
            answer_header = "## Copilot ",
            error_header = "## Error ",
            
            -- Agent-like behavior settings
            auto_follow_cursor = false, -- Don't follow cursor automatically
            auto_insert_mode = false, -- Don't enter insert mode automatically
            clear_chat_on_new_prompt = false, -- Keep conversation history
            
            -- Enhanced prompts for agent-like behavior
            prompts = {
                Explain = {
                    prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.",
                },
                Review = {
                    prompt = "/COPILOT_REVIEW Review the selected code. Identify bugs, potential improvements, and suggest specific changes with line numbers.",
                    callback = function(response, source)
                        -- Agent-like: automatically open quickfix with suggestions
                        vim.fn.setreg("+", response)
                        print("Review copied to clipboard")
                    end,
                },
                Fix = {
                    prompt = "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to fix the problem. Provide the complete corrected code.",
                },
                Optimize = {
                    prompt = "/COPILOT_GENERATE Optimize the selected code to improve performance and readability. Provide the complete optimized code.",
                },
                Docs = {
                    prompt = "/COPILOT_GENERATE Please add documentation comment for the selection. Show the code with added documentation.",
                },
                Tests = {
                    prompt = "/COPILOT_GENERATE Please generate tests for my code. Provide complete test code.",
                },
                Refactor = {
                    prompt = "/COPILOT_GENERATE Refactor the selected code to improve structure and maintainability. Provide the complete refactored code.",
                },
                FixDiagnostic = {
                    prompt = "Please assist with the following diagnostic issue in file:",
                    selection = function(source)
                        return require("CopilotChat.select").diagnostics(source)
                    end,
                },
                Commit = {
                    prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
                    selection = function(source)
                        return require("CopilotChat.select").gitdiff(source)
                    end,
                },
                CommitStaged = {
                    prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
                    selection = function(source)
                        return require("CopilotChat.select").gitdiff(source, true)
                    end,
                },
            },
            
            -- default mappings
            mappings = {
                complete = {
                    insert = '<Tab>',
                },
                close = {
                    normal = 'q',
                    insert = '<C-c>',
                },
                reset = {
                    normal = '<C-l>',
                    insert = '<C-l>',
                },
                submit_prompt = {
                    normal = '<CR>',
                    insert = '<C-s>',
                },
                toggle_sticky = {
                    normal = 'grr',
                },
                clear_stickies = {
                    normal = 'grx',
                },
                accept_diff = {
                    normal = '<leader>ad',
                    insert = '<leader>ad',
                },
                jump_to_diff = {
                    normal = 'gj',
                },
                quickfix_answers = {
                    normal = 'gqa',
                },
                quickfix_diffs = {
                    normal = 'gqd',
                },
                yank_diff = {
                    normal = 'gy',
                    register = '"', -- Default register to use for yanking
                },
                show_diff = {
                    normal = 'gd',
                    full_diff = false, -- Show full diff instead of unified diff when showing diff window
                },
                show_info = {
                    normal = 'gi',
                },
                show_context = {
                    normal = 'gc',
                },
                show_help = {
                    normal = 'gh',
                },
            },
        })
    end,
}
}
