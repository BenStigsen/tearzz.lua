--[[
    a minimal cursor module

    to-do:
        cursor:print_at(<x>, <y>, <text>) should be independent

    usage:
        require("cursor")

        cursor:set(<x>, <y>)
        cursor:move(<x>, <y>)
        cursor:reset()
        cursor:print(<text>)
        cursor:print_at(<x>, <y>, <text>)
--]]

-- This enables console navigation support on Windows (for some reason)
os.execute("")

cursor = {x = 0, y = 0}

cursor.set = function (cursor, _x, _y)
    if _x > 0 then 
        io.write(("\27[%dD\27[%dC"):format(cursor.x, _x))
    else
        io.write(("\27[%dD"):format(cursor.x))
    end

    if _y > 0 then 
        io.write(("\27[%dA\27[%dB"):format(cursor.y, _y))
    else
        io.write(("\27[%dA"):format(cursor.y))
    end

    io.flush()
    cursor.x, cursor.y = _x, _y
    return cursor
end

cursor.move = function (cursor, _x, _y)
    if _x < 0 then 
        io.write(("\27[%dD"):format(_x))
    elseif _x > 0 then 
        io.write(("\27[%dC"):format(_x)) 
    end

    if _y < 0 then 
        io.write(("\27[%dA"):format(_y)) 
    elseif _y > 0 then 
        io.write(("\27[%dB"):format(_y)) 
    end

    io.flush()
    cursor.x, cursor.y = cursor.x + _x, cursor.y + _y
    return cursor
end

cursor.reset = function (cursor)
    if cursor.x ~= 0 then io.write(("\27[%dD"):format(cursor.x)) end
    if cursor.y ~= 0 then io.write(("\27[%dA"):format(cursor.y)) end

    io.flush()
    cursor.x, cursor.y = 0, 0
    return cursor
end

cursor.print = function (cursor, msg)
    local length = msg:len()
    io.write(("%s\27[%dD"):format(msg, length))
    io.flush()
    return cursor
end

cursor.print_at = function (cursor, x, y, msg)
    local length = msg:len()
    local _x, _y = cursor.x, cursor.y

    return cursor:set(x, y):print(msg):set(_x, _y)
end
