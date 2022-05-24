-- Class
local GameInstance = require 'class.gameinstance'

local Marker = {}
setmetatable( Marker, { __index = GameInstance } )

function Marker:update( dt )
    self._timer = self._timer + dt

    if self._timer >= self._triggertiming then
        self._func()
        self:delete()
        self = nil
    end
end

function Marker:delete()
    self:_superDelete()
    self = nil
end

function Marker:new( args )
    local obj = GameInstance:new( args )
    obj._superDelete = obj.delete

    obj._x, obj._y = args.target:getPosition()
    obj._y = obj._y + args.target:getHeight() / 2
    obj._target = args.target
    obj._triggertiming = args.triggertiming
    obj._func = args.func or function()

    end
    obj._timer = 0

    return setmetatable( obj, {
        __index = Marker,
        __tostring = function()
            return 'Marker'
        end
    } )
end

return Marker
