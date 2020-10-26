--[[
    Convert simple markdown to HTML

    Usage:
        markdown.lua <file_to_convert> <file_to_output>

        if <file_to_output> is "stdout" it will print to console
--]]

if #arg < 2 then
    print("You need to supply two arguments")
    print("lumen <file_to_convert> <file_to_output>")
    os.exit(1)
end

replacements = {
    {"\r\n"                 , "\n"},

    -- Horizontal line
    {"\n\n(%-%-%-+%s+)"     , "\n\n<hr>\n\n"},
    {"\n\n(___+%s+)"        , "\n\n<hr>\n\n"},
    {"\n\n(***+%s+)"        , "\n\n<hr>\n\n"},

    -- Bold and italic
    {"___(.-)___"           , "<i><b>%1</b></i>"},
    {"__(.-)__"             , "<b>%1</b>"},
    {"_(.-)_"               , "<i>%1</i>"},

    {"%*%*%*(.-)%*%*%*"     , "<i><b>%1</b></i>"},
    {"%*%*(.-)%*%*"         , "<b>%1</b>"},
    {"%*(.-)%*"             , "<i>%1</i>"},

    -- Strikethrough
    {"~~(.-)~~"             , "<strike>%1</strike>"},

    -- Heading
    {"###### ([^\n]*)"      , "<h6>%1</h6>"},
    {"##### ([^\n]*)"       , "<h5>%1</h5>"},
    {"#### ([^\n]*)"        , "<h4>%1</h4>"},
    {"### ([^\n]*)"         , "<h3>%1</h3>"},
    {"## ([^\n]*)"          , "<h2>%1</h2>"},
    {"# ([^\n]*)"           , "<h1>%1</h1>"},

    {"([^\n]+)\n===+"       , "<h1>%1</h1>"},
    {"([^\n]+)\n%-%-%-+"    , "<h2>%1</h2>"},

    -- Image
    {"!%[(.-)%]%((.-)%)"    , "<p><img src=\"%2\" alt=\"%1\"></p>"},

    -- Link
    {"%[(.-)%]%((.-)%)"     , "<p><a href=\"%2\">%1</a></p>"},

    -- Codeblock
    {"```(%w-)\n(.-)```"    , "<pre><code class=\"%1\">%2</code></pre>"},

    -- In-line code
    {"`(.-)`"               , "<code>%1</code>"},

    -- Quote
    {"> ([^\n]-)\n"         , "<blockquote><p>%1</p></blockquote>"}
}

file_in = io.open(arg[1], "r")
content = file_in:read("*a")
file_in:close()

for i = 1, #replacements do
    content, _ = content:gsub(replacements[i][1], replacements[i][2])
end

if arg[2] == "stdout" then
    print(content)
else
    file_out = io.open(arg[2], "w")
    file_out:write(content)
    file_out:close()
end
