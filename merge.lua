--[[
    a file merger that will look for the specified files,
    read them and then merge

    usage:
        merge.lua <file_in> <file_to_output>

        if <file_to_output> is "stdout" it will print to console

    example:
        file.txt contains:
            'Hello [> merge file: "test.txt" <]'
        
        test.txt contains:
            'World'

        then <file_to_output> would contain:
            'Hello World'
--]]

if #arg < 2 then
    print("You need to supply two arguments")
    print("merge.lua <file_in> <file_to_output>")
    os.exit(1)
end

function file_read(filename)
    local file_in = io.open(filename, "r")
    local data = file_in:read("*a")
    file_in:close()
    return data
end

content = file_read(arg[1])

while true do
    filename = content:match('%[> merge file: "([^"]-)" <%]')
    if not filename or filename == "" then break end

    content = content:gsub('%[> merge file: "' .. filename .. '" <%]', file_read(filename))
end

if arg[2] == "stdout" then
    print(content)
else
    file_out = io.open(arg[2], "w")
    file_out:write(content)
    file_out:close()
end
