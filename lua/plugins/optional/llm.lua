local AI_URL = vim.g.AI_URL
local AI_KEY = vim.env.LLM_KEY

return {
    "Kurama622/llm.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
    config = function()
        local tools = require("llm.tools")
        require("llm").setup({
            models = {
                {
                    name = "Deepseek-v3",
                    url = AI_URL,
                    model = "deepseek-v3",
                    api_type = "openai",
                    fetch_key = function()
                        return AI_KEY
                    end,
                    max_tokens = 4096,
                    temperature = 0.3,
                    top_p = 0.7,
                },
                {
                    name = "Deepseek-v3-offical",
                    url = "https://api.deepseek.com/chat/completions",
                    model = "deepseek-chat",
                    api_type = "openai",
                    fetch_key = function()
                        return vim.env.DEEPSEEK_KEY
                    end,
                    max_tokens = 4096,
                    temperature = 0.3,
                    top_p = 0.7,
                },
                {
                    name = "Deepseek-r1",
                    url = AI_URL,
                    model = "deepseek-r1",
                    api_type = "openai",
                    fetch_key = function()
                        return AI_KEY
                    end,
                    max_tokens = 4096,
                    temperature = 0.3,
                    top_p = 0.7,
                    enable_thinking = true,
                    thinking_budget = 512,
                },
                {
                    name = "GPT-4.1-mini",
                    url = AI_URL,
                    model = "gpt-4.1-mini",
                    api_type = "openai",
                    fetch_key = function()
                        return AI_KEY
                    end,
                    max_tokens = 4096,
                    temperature = 0.3,
                    top_p = 0.7,
                },
                {
                    name = "GPT-4o-latest",
                    url = AI_URL,
                    model = "chatgpt-4o-latest",
                    api_type = "openai",
                    fetch_key = function()
                        return AI_KEY
                    end,
                    max_tokens = 4096,
                    temperature = 0.3,
                    top_p = 0.7,
                },
                {
                    name = "Grok-3",
                    url = AI_URL,
                    model = "grok-3",
                    api_type = "openai",
                    fetch_key = function()
                        return AI_KEY
                    end,
                    max_tokens = 4096,
                    temperature = 0.3,
                    top_p = 0.7,
                },
            },

            prompt = "You are a helpful code assistant and the user may use pinyin,but you need to spesk chinese",

            prefix = {
                user = { text = " ", hl = "Title" },
                assistant = { text = "  ", hl = "Added" },
            },

            history_path = vim.fn.stdpath("data") .. "/llm-history",
            save_session = true,
            max_history = 30,
            max_history_name_length = 20,
            -- stylua: ignore
            keys = {
                -- The keyboard mapping for the input window.
                ["Input:Submit"]      = { mode = { "n", "i" }, key = "<cr>" },
                ["Input:Cancel"]      = { mode = { "n", "i" }, key = "<C-c>" },
                ["Input:Resend"]      = { mode = { "n", "i" }, key = "<C-r>" },

                -- only works when "save_session = true"
                ["Input:HistoryNext"] = { mode = { "n", "i" }, key = "<C-j>" },
                ["Input:HistoryPrev"] = { mode = { "n", "i" }, key = "<C-k>" },

                ["Input:ModelsNext"]  = { mode = { "n" }, key = "<S-j>" },
                ["Input:ModelsPrev"]  = { mode = { "n" }, key = "<S-k>" },

                -- The keyboard mapping for the output window in "split" style.
                ["Output:Ask"]        = { mode = "n", key = "i" },
                ["Output:Cancel"]     = { mode = "n", key = "<C-c>" },
                ["Output:Resend"]     = { mode = "n", key = "<C-r>" },

                -- The keyboard mapping for the output and input windows in "float" style.
                ["Session:Toggle"]    = { mode = "n", key = "<leader>ac" },
                ["Session:Close"]     = { mode = "n", key = { "<esc>", "<C-q>" } },

                -- Scroll
                ["PageUp"]            = { mode = { "i", "n" }, key = "<C-b>" },
                ["PageDown"]          = { mode = { "i", "n" }, key = "<C-f>" },
                ["HalfPageUp"]        = { mode = { "i", "n" }, key = "<C-u>" },
                ["HalfPageDown"]      = { mode = { "i", "n" }, key = "<C-d>" },
                ["JumpToTop"]         = { mode = "n", key = "gg" },
                ["JumpToBottom"]      = { mode = "n", key = "G" },

                -- Switch from the output window to the input window.
                ["Focus:Input"]       = { mode = "n", key = { "i", "<C-w>" } },
                -- Switch from the input window to the output window.
                ["Focus:Output"]      = { mode = { "n", "i" }, key = "<C-w>" },
            },
            app_handler = {
                WordTranslate = {
                    handler = tools.flexi_handler,
                    prompt =
                    [[You are a translation expert. Your task is to translate all the text provided by the user into Chinese.

NOTE:
- All the text input by the user is part of the content to be translated, and you should ONLY FOCUS ON TRANSLATING THE TEXT without performing any other tasks.
- RETURN ONLY THE TRANSLATED RESULT.]],
                    opts = {
                        exit_on_move = true,
                        enter_flexible_window = false,
                    },
                },
                CodeExplain = {
                    handler = tools.flexi_handler,
                    prompt = "Explain the following code, please only return the explanation, and answer in Chinese",
                    opts = {
                        enter_flexible_window = true,
                    },
                },
                Translate = {
                    handler = tools.qa_handler,
                    opts = {
                        component_width = "60%",
                        component_height = "50%",
                        query = {
                            title = " 󰊿 Trans ",
                            hl = { link = "Define" },
                        },
                        input_box_opts = {
                            size = "15%",
                            win_options = {
                                winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                            },
                        },
                        preview_box_opts = {
                            size = "85%",
                            win_options = {
                                winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                            },
                        },
                    },

                },
                Ask = {
                    handler = tools.disposable_ask_handler,
                    opts = {
                        position = {
                            row = 2,
                            col = 0,
                        },
                        title = " Ask ",
                        inline_assistant = true,
                        language = "Chinese",

                        -- [optinal] set your llm model
                        url = AI_URL,
                        model = AI_MODEL,
                        api_type = "openai",
                        fetch_key = function()
                            return AI_KEY
                        end,

                        -- display diff
                        display = {
                            mapping = {
                                mode = "n",
                                keys = { "d" },
                            },
                            action = nil,
                        },
                        -- accept diff
                        accept = {
                            mapping = {
                                mode = "n",
                                keys = { "Y", "y" },
                            },
                            action = nil,
                        },
                        -- reject diff
                        reject = {
                            mapping = {
                                mode = "n",
                                keys = { "N", "n" },
                            },
                            action = nil,
                        },
                        -- close diff
                        close = {
                            mapping = {
                                mode = "n",
                                keys = { "<esc>" },
                            },
                            action = nil,
                        },
                    },
                },
            },
        })
    end,
    -- keys = {
    --     { "<leader>ac", mode = "n", "<cmd>LLMSessionToggle<cr>" },
    --     { "<leader>ae", mode = "v", "<cmd>LLMAppHandler CodeExplain<cr>" },
    --     { "<leader>at", mode = "x", "<cmd>LLMAppHandler WordTranslate<cr>" },
    --     { "<leader>at", mode = "n", "<cmd>LLMAppHandler Translate<cr>" },
    --     { "<leader>aa", mode = "n", "<cmd>LLMAppHandler Ask<cr>" },
    -- },
}
