--[[
    a minimal cursor module

    to-do:
        simplify cursor.move()
        simplify cursor.set()
        fix increment being added when x or y is 0

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
    io.write(("\27[%dD\27[%dA\27[%dC\27[%dB"):format(cursor.x, cursor.y, _x, _y))
    io.flush()
    cursor.x, cursor.y = _x, _y
    return cursor
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
    return cursor
end

cursor.reset = function (cursor)
    io.write(("\27[%dD\27[%dA"):format(cursor.x, cursor.y))
    io.flush()
    cursor.x, cursor.y = 0, 0
    return cursor
end

cursor.reset_x = function (cursor)
    io.write("\27[1000D")
    io.flush()
    cursor.x = 0
    return cursor
end

cursor.reset_y = function (cursor)
    io.write("\27[1000A")
    io.flush()
    cursor.y = 0
    return cursor
end

cursor.print = function (cursor, msg)
    local length = msg:len()
    io.write(("%s\27[%dD"):format(msg, length))
    io.flush()
    return cursor
end

cursor.print_at = function (cursor, msg, x, y)
    local length = msg:len()
    io.write(("\27[%dD\27[%dA\27[%dC\27[%dB%s"):format(cursor.x, cursor.y, x, y, msg))
    io.write(("\27[%dD\27[%dA\27[%dC\27[%dB"):format(x + length, y, cursor.x, cursor.y))
    io.flush()
    return cursor
end

string.count = function (str, pattern)
    return select(2, str:gsub(pattern, ""))
end
