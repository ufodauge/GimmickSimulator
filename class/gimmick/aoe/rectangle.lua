-- Class
local GameInstance = require 'class.gameinstance'

local GimmickAoE = {}
setmetatable( GimmickAoE, { __index = GameInstance } )

function GimmickAoE:update( dt )
    self._timer = self._timer + dt

    if self._timer >= self.trigger_timing then
        self:trigger()
    end
end

function GimmickAoE:draw()
    local x, y = self:getPosition()

    if self._ir and self._ir > 0 then
        local stencil = function()
            love.graphics.circle( 'fill', x, y, self._ir )
        end
        love.graphics.stencil( stencil, 'replace', 1 )
    end

    love.graphics.setStencilTest( 'equal', 0 )
    love.graphics.circle( 'fill', x, y, self.radius )
    love.graphics.setStencilTest()
end

function GimmickAoE:delete()
    self:superDelete()
    self = nil
end

function GimmickAoE:new( args )
    local obj = GameInstance:new( args )
    setmetatable( obj, { __index = GimmickAoE } )

    obj.superDelete = obj.delete

    obj._x = args.x or 0
    obj._y = args.y or 0

    obj._timer = 0 -- AoEが設置されてからの時間
    obj._prediction = args.prediction or 0 -- 予兆が消えるまでの時間
    obj._triggertiming = 0 -- 当たり判定が確定するまでの時間

    obj._triggertiming = obj._prediction and obj._prediction + AOE_TIMELAG_BETWEEN_UNDISPLAYED_AND_TRIGGERED

    obj._color = { r = AOE_COLOR_RED, g = AOE_COLOR_GREEN, b = AOE_COLOR_BLUE, a = AOE_COLOR_ALPHA }
    obj._colorTriggering = { r = TRIGGERED_AOE_COLOR_RED, g = TRIGGERED_AOE_COLOR_GREEN, b = TRIGGERED_AOE_COLOR_BLUE, a = TRIGGERED_AOE_COLOR_ALPHA }

    return obj
end

return GimmickAoE
