--[[
    a webpage creator, merge.lua, highlight.lua and markdown.lua combined

    usage:
        webpage.lua <file_html_template> <file_to_output>

        if <file_to_output> is "stdout" it will print to console
--]]

if #arg < 2 then
    print("You need to supply two arguments")
    print("webpage.lua <file_html_template> <file_to_output>")
    os.exit(1)
end

function file_read(filename)
	local file_in = io.open(filename, "r")
	local data = file_in:read("*a")
	file_in:close()
	return data
end

replacements_markdown = {
    {"\r\n", "\n"},

    -- Heading
    {"###### ([^\n]*)", "<h6>%1</h6>"},
    {"##### ([^\n]*)", "<h5>%1</h5>"},
    {"#### ([^\n]*)", "<h4>%1</h4>"},
    {"### ([^\n]*)", "<h3>%1</h3>"},
    {"## ([^\n]*)", "<h2>%1</h2>"},
    {"# ([^\n]*)", "<h1>%1</h1>"},

    -- Quote
    {"> ([^\n]*)", "<p><blockquote>%1</blockquote></p>"},

    -- Horizontal line
    {"\n\n(%-%-%-%--)\n", "\n\n<hr>\n\n"},

    -- Paragraph
    {"\n[^<\n]+\n", "<p>%0</p>"},

    -- Image
    {"!%[(.-)%]%((.-)%)", "<img src=\"%2\" alt=\"%1\">"},

    -- Link
    {"%[(.-)%]%((.-)%)", "<a href=\"%2\">%1</a>"},

    -- Bold and italic
    {"%*%*%*([^\n]-[^\n])%*%*%*", "<i><b>%1</b></i>"},
    {"%*%*([^\n]-[^\n])%*%*", "<b>%1</b>"},
    {"%*([^\n]-[^\n])%*", "<i>%1</i>"},
    {"_([^\n]-[^\n])_", "<i>%1</i>"},

    -- Strikethrough
    {"~~([^\n]-[^\n])~~", "<strike>%1</strike>"},

    -- Code
    {"```(%w-)<.-\n(.-)```", '<pre><code class="%1">%2</code></pre>'},
    {"```(%w-)\n(.-)```", '<pre><code class="%1">%2</code></pre>'},
	{"`(.-)`", "<code>%1</code>"}
}

replacements_highlight = {
    -- String
    {{"%b\"\"", "%b''"}, "<span class=\"string\">%0</span>"},

    -- Comment
    {
        {
            -- Block
            "/%*.-%*/", "%-%-%[%[.-%-%-%]%]",

            -- Single
            "//[^\n]-\n", "#[^\n]-\n", "[^>]%-%-[^\n]-\n"
        }, "<span class=\"comment\">%0</span>"
    },

    -- Function
    {{"(%w+)(%s+%*?[_%w%d]-%()"}, "<span class=\"function\">%1</span>%2"},

    -- Functioncall
    {{"(%w+)%("}, "<span class=\"call\">%1</span>("},
    
    -- Keywords
    {
        {
            "%Wimport ", "^import ", "%Wrequire ", "^require", 
            "#include ", "#define ", "%Wthen%s", "%Wdo%s", "%Wend",
            "%Wif ", "^if", "%Wfor ", "^for", "%Wwith ", "%Win "
        }, "<span class=\"keyword\">%0</span>"
    },

    -- Number
    {
        {"%W%d-%.%d+%D", "^%d-%.%d+%D", "[^>%w]%d%d-[^<]"}, 
        "<span class=\"number\">%0</span>"
    }
}

function to_pattern(content)
	local replacements = {
		{"%%", "%%"},  {"%.", "%%."},
		{"%(", "%%("}, {"%)", "%%)"}, {"%[", "%%["}, {"%]", "%%]"},
		{"%+", "%%+"}, {"%-", "%%-"}, {"%*", "%%*"}, {"%?", "%%?"}
	}
	for i = 1, #replacements do 
		content = content:gsub(replacements[i][1], replacements[i][2]) 
	end
	return content
end

function markdown_to_html(content)
	for i = 1, #replacements_markdown do
	    content, _ = content:gsub(replacements_markdown[i][1], replacements_markdown[i][2])
	end
	return content
end

function highlight_code(content)
	for codeblock in content:gmatch("```%w-\n.-```") do
		local new = codeblock
		for i = 1, #replacements_highlight do
		    for j = 1, #replacements_highlight[i][1] do
		        new, _ = new:gsub(replacements_highlight[i][1][j], replacements_highlight[i][2])
		    end
		end

		content, _ = content:gsub(to_pattern(codeblock), new)
	end

	return content
end

html = file_read(arg[1])

while true do
	filename = html:match('%[> merge file: "([^"]-)" <%]')
	if not filename or filename == "" then break end

	markdown = file_read(filename)
	markdown = highlight_code(markdown)
	markdown = markdown_to_html(markdown)

	html = html:gsub('%[> merge file: "' .. filename .. '" <%]', markdown)
end

if arg[2] == "stdout" then
    print(html)
else
    file_out = io.open(arg[2], "w")
    file_out:write(html)
    file_out:close()
end
