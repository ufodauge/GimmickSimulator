-- Class
local GameInstance = require 'class.gameinstance'

local CircleAoE = {}
setmetatable( CircleAoE, { __index = GameInstance } )

function CircleAoE:update( dt )
    self._timer = self._timer + dt

    if self._timer >= self._triggertiming then
        self:trigger()
    end
end

function CircleAoE:trigger()

end

function CircleAoE:isTriggering()
    return self._timer >= self._triggertiming and self._timer < self._triggertiming + TRIGGERED_AOE_DURATION
end

function CircleAoE:isPredicting()
    return self._timer <= self._prediction
end

function CircleAoE:draw()
    local x, y = self:getPosition()

    love.graphics.push()
    if self:isTriggering() then
        love.graphics.setColor( self._colorTriggering.r, self._colorTriggering.g, self._colorTriggering.b, self._colorTriggering.a )
    elseif self:isPredicting() then
        love.graphics.setColor( self._color.r, self._color.g, self._color.b, self._color.a )
    else
        love.graphics.setColor( 0, 0, 0, 0 )
    end

    if self._ir and self._ir > 0 then
        local stencil = function()
            love.graphics.circle( 'fill', x, -y, self._ir )
        end
        love.graphics.stencil( stencil, 'replace', 1 )
    end

    love.graphics.setStencilTest( 'equal', 0 )
    love.graphics.circle( 'fill', x, -y, self._r )
    love.graphics.setStencilTest()
    love.graphics.pop()
end

function CircleAoE:delete()
    self:superDelete()
    self = nil
end

function CircleAoE:new( args )
    local obj = GameInstance:new( args )
    obj.superDelete = obj.delete

    setmetatable( obj, { __index = CircleAoE } )

    obj._x = args.x or 0
    obj._y = args.y or 0
    obj._r = args.r or 100 -- 円の半径
    obj._ir = args.ir or 0 -- ダイナモとして使う際の内円の半径

    obj._timer = 0 -- AoEが設置されてからの時間
    obj._prediction = args.prediction or 0 -- 予兆が消えるまでの時間
    obj._triggertiming = 0 -- 当たり判定が確定するまでの時間

    obj._triggertiming = obj._prediction and obj._prediction + AOE_TIMELAG_BETWEEN_UNDISPLAYED_AND_TRIGGERED

    obj._color = { r = AOE_COLOR_RED, g = AOE_COLOR_GREEN, b = AOE_COLOR_BLUE, a = AOE_COLOR_ALPHA }
    obj._colorTriggering = { r = TRIGGERED_AOE_COLOR_RED, g = TRIGGERED_AOE_COLOR_GREEN, b = TRIGGERED_AOE_COLOR_BLUE, a = TRIGGERED_AOE_COLOR_ALPHA }

    return obj
end

return CircleAoE
