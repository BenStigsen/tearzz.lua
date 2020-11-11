--[[
    a minimal terminal text styling module
    
    to-do:
        add more colors and styles (https://en.wikipedia.org/wiki/ANSI_escape_code)

    usage:
        require("stylize")

        ("Hello World"):stylize("red", "bold", "underline", etc)

        string.stylize("Hello World", "red", "bold", "underline", etc)
--]]

-- This enables console color support on Windows (for some reason)
os.execute("")

-- Console text formatting
local style = {
    -- Foreground colors         -- Bright
    ["black"]       = "\27[30m", ["bblack"]     = "\27[30;1m",
    ["red"]         = "\27[31m", ["bred"]       = "\27[31;1m",
    ["green"]       = "\27[32m", ["bgreen"]     = "\27[32;1m",
    ["yellow"]      = "\27[33m", ["byellow"]    = "\27[33;1m",
    ["blue"]        = "\27[34m", ["bblue"]      = "\27[34;1m",
    ["magenta"]     = "\27[35m", ["bmagenta"]   = "\27[35;1m",
    ["cyan"]        = "\27[36m", ["bcyan"]      = "\27[36;1m",
    ["white"]       = "\27[37m", ["bwhite"]     = "\27[37;1m",

    -- Background colors         -- Bright
    ["bgblack"]     = "\27[40m", ["bgbblack"]   = "\27[40;1m",
    ["bgred"]       = "\27[41m", ["bgbred"]     = "\27[31;1m",
    ["bggreen"]     = "\27[42m", ["bgbgreen"]   = "\27[32;1m",
    ["bgyellow"]    = "\27[43m", ["bgbyellow"]  = "\27[33;1m",
    ["bgblue"]      = "\27[44m", ["bgbblue"]    = "\27[34;1m",
    ["bgmagenta"]   = "\27[45m", ["bgbmagenta"] = "\27[35;1m",
    ["bgcyan"]      = "\27[46m", ["bgbcyan"]    = "\27[36;1m",
    ["bgwhite"]     = "\27[47m", ["bgbcyan"]    = "\27[47;1m",

    -- Styling
    ["bold"]        = "\27[1m", 
    ["underline"]   = "\27[4m", 
    ["reversed"]    = "\27[7m",

    ["reset"]       = "\27[0m"
}

string.stylize = function (text, ...)
    local arg = {...}
    local final = {}

    for i = 1, #arg do
        table.insert(final, i, style[arg[i]])
    end

    table.insert(final, #final + 1, text)
    table.insert(final, #final + 1, "\27[0m")
    return table.concat(final)
end
