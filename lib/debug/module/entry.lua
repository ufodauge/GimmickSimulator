local Entry = {}

local function printOutlined( text, x, y, ... )
    local args = ...
    local limit, align = args[1], args[2]

    love.graphics.setColor( 0.2, 0.2, 0.2, 1 )
    if limit then
        love.graphics.printf( text, x + 1, y + 1, limit, align )
        love.graphics.printf( text, x - 1, y + 1, limit, align )
        love.graphics.printf( text, x + 1, y - 1, limit, align )
        love.graphics.printf( text, x - 1, y - 1, limit, align )
        love.graphics.printf( text, x, y, limit, align )
    else
        love.graphics.print( text, x + 1, y + 1 )
        love.graphics.print( text, x - 1, y + 1 )
        love.graphics.print( text, x + 1, y - 1 )
        love.graphics.print( text, x - 1, y - 1 )
        love.graphics.print( text, x, y )
    end
    love.graphics.setColor( 1, 1, 1, 1 )
end


function Entry:getName()
    return self.name
end


function Entry:getPath()
    return self.path
end


function Entry:remove()
    self = nil
end


function Entry:prev()
    if self.prev then
        return self.prev
    else
        return self
    end
end


function Entry:next()
    if self.next then
        return self.next
    else
        return self
    end
end


function Entry:getIndex()
    return self.index
end


function Entry:print( x, y )
    printOutlined( self.name, x, y )
end


function Entry:execute()
    -- none
end


function Entry.new( name )
    local obj = {}

    obj.name = name

    obj.prev = nil
    obj.next = nil
    obj.index = 1
    obj.parent = nil

    setmetatable( obj, { __index = Entry } )

    return obj
end


return Entry
