local Private = {}
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


function Public:getInstance()
    if Private.instance == nil then
        Private.instance = Private.new()
    end

    assert( Private.instance ~= nil, 'GameInstance:getInstance() is not called yet.' )
    return Private.instance
end


function Private:update( dt )
    if self.counting then
        self.frames = self.frames + 1
        self.fps = 1 / dt
    end
end


function Private:stop()
    self.counting = false
end


function Private:start()
    self.counting = true
end


function Private:getFrame()
    return self.frames
end


function Private:getFps()
    return self.fps
end


function Private:reset()
    self.frames = 0
end


function Private:toggle()
    self.active = not self.active
end


function Private:getActive()
    return self.active
end


function Private:printFrames( x, y )
    if self:getActive() then
        printOutlined( ('Frames: %.2f'):format( self:getFrame() ), x, y )
    end
end


function Private:printFps( x, y )
    if self:getActive() then
        printOutlined( 'FPS: ' .. tostring( self:getFps() ), x, y )
    end
end


-- 初期化処理
function Private.new()
    local obj = {}

    obj.frames = 0
    obj.counting = true

    setmetatable( obj, { __index = Private } )

    return obj
end


return Public
