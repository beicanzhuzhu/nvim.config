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

return optional_plugins
