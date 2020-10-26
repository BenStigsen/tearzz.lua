--[[
    An opinionated markdown to html converter

    usage:
        markdown.lua <file_to_convert> <file_to_output>

        if <file_to_output> is "stdout" it will print to console
--]]

if #arg < 2 then
    print("You need to supply two arguments")
    print("markdown.lua <file_to_convert> <file_to_output>")
    os.exit(1)
end

replacements = {
    {"\r\n"                         , "\n"},

    -- Heading
    {"###### ([^\n]*)"              , "<h6>%1</h6>"},
    {"##### ([^\n]*)"               , "<h5>%1</h5>"},
    {"#### ([^\n]*)"                , "<h4>%1</h4>"},
    {"### ([^\n]*)"                 , "<h3>%1</h3>"},
    {"## ([^\n]*)"                  , "<h2>%1</h2>"},
    {"# ([^\n]*)"                   , "<h1>%1</h1>"},

    -- Quote
    {"> ([^\n]*)"                   , "<p><blockquote>%1</blockquote></p>"},

    -- Horizontal line
    {"\n\n(%-%-%-%--)\n"            , "\n\n<hr>\n\n"},

    -- Paragraph
    {"\n([^<\n]+)\n"                , "\n<p>%1</p>\n"},

    -- Image
    {"!%[(.-)%]%((.-)%)"            , "<img src=\"%2\" alt=\"%1\">"},

    -- Link
    {"%[(.-)%]%((.-)%)"             , "<a href=\"%2\">%1</a>"},

    -- Bold and italic
    {"%*%*%*([^\n]-[^\n])%*%*%*"    , "<i><b>%1</b></i>"},
    {"%*%*([^\n]-[^\n])%*%*"        , "<b>%1</b>"},
    {"%*([^\n]-[^\n])%*"            , "<i>%1</i>"},
    {"_([^\n]-[^\n])_"              , "<i>%1</i>"},

    -- Strikethrough
    {"~~([^\n]-[^\n])~~"            , "<strike>%1</strike>"},

    -- Codeblock
    {"```(%w-)\n(.-)```"            , "<pre><code class=\"%1\">%2</code></pre>"},

    -- In-line code
    {"`(.-)`"                       , "<code>%1</code>"},
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
