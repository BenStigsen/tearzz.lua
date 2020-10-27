--[[
    a syntax highlighter (plain text to syntax highlighted html)

    usage:
        highlight.lua <file_to_convert> <file_to_output>

        if <file_to_output> is "stdout" it will print to console
--]]

if #arg < 2 then
    print("You need to supply two arguments")
    print("highlight.lua <file_to_highlight> <file_to_output>")
    os.exit(1)
end

replacements = {
    {
        -- String
        {
            "%b\"\"",
            "%b''",
        },
        "<span class=\"string\">%0</span>"
    },
    {
        -- Comment
        {
            -- Block
            "/%*.-%*/",
            "%-%-%[%[.-%-%-%]%]",

            -- Single
            "//[^\n]-\n",
            "#[^\n]-\n",
            "[^>]%-%-[^\n]-\n",
        },
        "<span class=\"comment\">%0</span>"
    },
    {
        -- Function
        {
            "(%w+)(%s+%*?[_%w%d]-%()",
        },
        "<span class=\"function\">%1</span>%2"
    },
    {
        -- Functioncall
        {
            "(%w+)%(",
        },
        "<span class=\"call\">%1</span>("
    },
    {
        -- Keywords
        {
            "(import )",
            "(require )",
            "(#include )",
            "(#define )",
            "(if )",
            "(for )",
            "(with )",
            "(in )",
            "(then[^\n]-)\n",
            "(do[^\n]-)\n"
        },
        "<span class=\"keyword\">%1</span>"
    },
    {
        -- Number
        {
            "%d+%.%d+%D",
            "[^>]%d+[^<]",
        },
        "<span class=\"number\">%0</span>"
    },
}

file_in = io.open(arg[1], "r")
content = file_in:read("*a")
file_in:close()

for i = 1, #replacements do
    for j = 1, #replacements[i][1] do
        content, _ = content:gsub(replacements[i][1][j], replacements[i][2])
    end
end

if arg[2] == "stdout" then
    print(content)
else
    file_out = io.open(arg[2], "w")
    file_out:write(content)
    file_out:close()
end
