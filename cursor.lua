--[[
    a minimal cursor module

    to-do:
        add cursor:get_pos()

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
    io.write(("\27[%d;%dH"):format(_y + 1, _x + 1))
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

cursor.print_at = function (cursor, _x, _y, msg)
    local length = msg:len()

    if _x < cursor.x then
        io.write(("\27[%dD"):format(cursor.x - _x))
    elseif _x > cursor.x then 
        io.write(("\27[%dC"):format(_x - cursor.x))
    end

    if _y < cursor.y then 
        io.write(("\27[%dA"):format(cursor.y - _y)) 
    elseif _y > cursor.y then 
        io.write(("\27[%dB"):format(_y - cursor.y)) 
    end

    io.write(msg)
    _x = _x + length

    if _x > cursor.x then
        io.write(("\27[%dD"):format(_x - cursor.x))
    elseif _x < cursor.x then
        io.write(("\27[%dC"):format(cursor.x - _x))
    end

    if _y > cursor.y then
        io.write(("\27[%dA"):format(_y - cursor.y)) 
    elseif _y < cursor.y then 
        io.write(("\27[%dB"):format(cursor.y - _y)) 
    end

    io.flush()

    return cursor
end
