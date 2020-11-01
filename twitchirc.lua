--[[
    a minimal twitch chatbot

    usage:
        twitchirc.lua [<credentials.lua>] [<oauth> <channel> <botname>]

        if <credentials_file> is listed
        then the other 3 arguments are not necessary

    credentials.lua:
        (Everything should be lowercase!!)
        if you are going to use a credentials file make it contain:
            oauth = "oauth:your-long-oauth-token-here"
            channel = "the_channel_to_join"
            botname = "the_bot_to_use"
--]]

if #arg == 1 then
    loadfile(arg[1])()
elseif #arg == 3 then
    oauth = arg[1]
    botname = arg[2]
    channel = arg[3]
else
    print("You need to supply one or three arguments")
    print("twitchirc.lua <credentials_file>")
    print("twitchirc.lua <oauth> <channel> <botname>")
    os.exit(1)
end

-- Create a tcp socket
socket = require("socket")
irc = socket.tcp()

-- This enables console color support on Windows (for some reason)
os.execute("")

-- Custom defined variables
replacements = {['||channel||'] = channel}

-- Commands (supports "||user||", "||msg||" and the replacements defined above)
commands = {
    ['test'] = '||user|| just typed "||msg||" in channel ||channel||!'
--  ['command'] = 'some response here!'
}

-- Queue of messages to send
--messages = {} 

-- Console text formatting
style = {
    ["red"] = "\27[31m",
    ["green"] = "\27[32m",
    ["yellow"] = "\27[33m",
    ["blue"] = "\27[34m",
    ["magenta"] = "\27[35m",
    ["clear"] = "\27[0m",

    ["bright"] = "\27[1m", ["underline"] = "\27[4m", ["reversed"] = "\27[7m"
}

-- Color output / text formatting
string.stylize = function (msg, ...)
    local arg = {...}
    local final = {}

    for i = 1, #arg do
        table.insert(final, i, style[arg[i]])
    end

    table.insert(final, #final + 1, msg)
    table.insert(final, #final + 1, "\27[0m")
    return table.concat(final)
end

-- Initialize connection
function irc_initialize()
    local connect = irc:connect(socket.dns.toip("irc.chat.twitch.tv"), 6667)
    irc:send(("PASS %s\r\n"):format(oauth))
    irc_send_raw(("NICK %s"):format(botname))
    irc_send_raw(("JOIN #%s"):format(channel))
    irc_send_msg("Connected!")

    -- Starts loop
    update()
end

-- Send raw message
function irc_send_raw(msg)
    print(("%s %s"):format(("[SENDIRC]"):stylize("red", "bright"), msg))
    irc:send(("%s\r\n"):format(msg))
end

-- Send Twitch chat message
function irc_send_msg(msg)
    print(("%s %s: %s"):format(("[SENDMSG]"):stylize("blue", "bright"), botname:stylize("underline"), msg))
    irc:send(("PRIVMSG #%s :%s\r\n"):format(channel, msg))
end

-- Update loop to receive IRC data
function update()
    while true do
        local line = irc:receive()
        if line then
            --print(line)
            if line:match("(%w+)") == "PING" then
                print(("%s %s"):format(("[RECVIRC]"):stylize("magenta", "bright"), line))
                irc_send_raw("PONG")
            elseif line:find("PRIVMSG ") then
                process(line)
            end
        end
    end
end

-- Process chat messages
function process(line)
    local user = line:match(":(.-)!")
    local message = line:match(("PRIVMSG #%s :(.+)"):format(channel))
    --table.insert(messages, #messages + 1, message)

    --if #messages > 5 then messages:remove(1) end

    local command = message:match("(%w+)")
    
    if commands[command] then
        print(("%s %s: %s"):format(("[RECVCMD]"):stylize("yellow"), user:stylize("underline"), message))
        local msg = commands[command]
        for k, v in pairs(replacements) do msg = msg:gsub(k, v) end
        msg = msg:gsub("||user||", user):gsub("||msg||", message)

        irc_send_msg(msg)
    else
        print(("%s %s: %s"):format(("[RECVMSG]"):stylize("green", "bright"), user:stylize("underline"), message))
    end
end

-- Initialize IRC
irc_initialize()
