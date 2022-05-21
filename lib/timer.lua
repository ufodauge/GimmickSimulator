local Timer = {}

function Timer:after( time, func )
    local t = { time = time, func = func, start = love.timer.getTime() }
    table.insert( self.functions, t )
    return t
end

function Timer:update( dt )
    for i, t in pairs( self.functions ) do
        if love.timer.getTime() - t.start >= t.time then
            t.func()
            table.remove( self.functions, i )
        end
    end
end

function Timer:new()
    local obj = {}
    setmetatable( obj, { __index = Timer } )

    obj.functions = {}

    return obj
end

return Timer

