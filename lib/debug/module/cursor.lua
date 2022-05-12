local path = ...
path = path:gsub( path:gsub( '(%w+%.)', '' ), '' )
local Observer = require( path .. 'observer' )

local Cursor = {}
local Public = {}

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


local instance = nil

function Public:getInstance()
    if instance == nil then
        instance = Cursor.new()
    end

    assert( instance ~= nil, 'Cursor:getInstance() is not called yet.' )
    return instance
end


function Cursor:print( x, y, textheight )
    printOutlined( '>', x, y + (self.currentIndex - 1) * textheight )
end


function Cursor:getObserver()
    return self.observer
end


function Cursor.new()
    local obj = {}

    obj.currentIndex = 1

    obj.observer = Observer.new( function( entryManager )
        obj.currentIndex = entryManager:getCurrent():getIndex()
    end
 )

    setmetatable( obj, { __index = Cursor } )

    return obj
end


return Public
