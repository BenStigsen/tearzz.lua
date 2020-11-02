--[[
    a minimal cursor module

    to-do:
        simplify cursor.move()

    usage:
        require("cursor")

        cursor:set(<x>, <y>)
        cursor:move(<x>, <y>)
        cursor:reset()
        cursor:reset_x()
        cursor:reset_y()
        cursor:print(<text>)
        cursor:print_at(<text>, <x>, <y>)
--]]

-- This enables console navigation support on Windows (for some reason)
os.execute("")

cursor = {x = 0, y = 0}

cursor.set = function (cursor, _x, _y)
    cursor.x = _x
    cursor.y = _y
    io.write(("\27[%dC\27[%dB"):format(_x, _y))
    io.flush()
end

cursor.move = function (cursor, steps_x, steps_y)
    cursor.x = cursor.x + steps_x
    cursor.y = cursor.y + steps_y
    
    local output = ""
    if steps_x > 0 then 
        output = "\27[%dC"
    elseif steps_x < 0 then
        output = "\27[%dD"
    end

    if steps_y > 0 then
        output = output .. "\27[%dB"
    elseif steps_y < 0 then
        output = output .. "\27[%dA"
    end

    if output ~= "" then
        if steps_x ~= 0 and steps_y ~= 0 then
            io.write(output:format(math.abs(steps_x), math.abs(steps_y)))
        elseif steps_x == 0 and steps_y ~= 0 then
            io.write(output:format(math.abs(steps_y)))
        else
            io.write(output:format(math.abs(steps_x)))
        end
    end

    io.flush()
end

cursor.reset = function (cursor)
    io.write("\27[1000D\27[1000A")
    io.flush()
    cursor = {x = 0, y = 0}
end

cursor.reset_x = function (cursor)
    io.write("\27[1000D")
    io.flush()
    cursor.x = 0
end

cursor.reset_y = function (cursor)
    io.write("\27[1000A")
    io.flush()
    cursor.y = 0
end

cursor.print = function (cursor, msg)
    io.write(msg)
    io.flush()
end

cursor.print_at = function (cursor, msg, x, y)
    local old = cursor
    cursor:reset()
    io.write(("\27[%dC\27[%dB%s"):format(x, y, msg))
    io.flush()
    cursor = old
end
