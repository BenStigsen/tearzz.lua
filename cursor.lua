--[[
    a minimal cursor module

    to-do:
        add cursor:get_pos()
        add get_dimensions()

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
    io.write("\27[1;1H")
    io.flush()
    
    cursor.x, cursor.y = 0, 0
    
    return cursor
end

cursor.print = function (cursor, msg)
    msg = msg:gsub("\n", ("\n\027[%dC"):format(cursor.x))

    io.write(msg)
    io.flush()
    
    return cursor
end

cursor.print_at = function (cursor, _x, _y, msg)
    local length = msg:len()

    io.write(("\27[%d;%dH"):format(_y + 1, _x + 1))
    io.write(msg)
    io.write(("\27[%d;%dH"):format(cursor.x + 1, cursor.y + 1))
    io.flush()

    return cursor
end
