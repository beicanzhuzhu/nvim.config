-- these plugins is options, your can turn on and turn off these plugins there

local optional_plugins = {

    require("plugins.optional.noice"),

}

-- if run in neovide
if not vim.g.neovide then
    vim.notify("Not running in Neovide, loading smear-cursor...")
    table.insert(optional_plugins, require("plugins.optional.smear-cursor"))
else
    vim.notify("Running in Neovide, disable smear-cursor.")
end

-- if set LLM_LEY
if vim.env.LLM_KEY ~= "" and vim.env.LLM_KEY ~= nil then
    print("Enable llm.nvim")
    table.insert(optional_plugins, require("plugins.optional.llm"))
else
    vim.notify("You can set LLM_KEY to use llm.nvim plugin")
end

return optional_plugins
