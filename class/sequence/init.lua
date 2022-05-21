local Lume = require 'lib.lume'
local GameInstance = require 'class.gameinstance'

local Sequence = {}
setmetatable( Sequence, { __index = GameInstance } )

function Sequence:update( dt )
    if self._started then
        self._timer = self._timer + dt
    end

    if self._timer >= self._timing then
        self:trigger()
    end

    if self:isTriggering() and self._func then
        self._func()
    end
end

function Sequence:start()
    self._timer = 0
    self._started = true
end

function Sequence:stop()
    self._timer = 0
    self._started = false
end

function Sequence:trigger()
    self._triggeredframe = self._triggeredframe + 1
end

function Sequence:isTriggering()
    return self._triggeredframe == 1
end

function Sequence:isTriggered()
    return self._triggeredframe > 0
end

function Sequence:reset()
    self._timer = 0
    self._triggeredframe = 0
end

function Sequence:delete()
    self:superDelete()
    self = nil
end

function Sequence:new( func, timing, args )
    local obj = GameInstance:new( args )
    obj.superDelete = obj.delete

    setmetatable( obj, { __index = Sequence } )

    obj._func = func
    obj._timer = 0
    obj._timing = timing
    obj._triggeredframe = 0

    return obj
end

return Sequence
