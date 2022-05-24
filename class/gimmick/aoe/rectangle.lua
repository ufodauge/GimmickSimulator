-- lib
local Lume = require 'lib.lume'

-- Class
local GameInstance = require 'class.gameinstance'

local RectangleAoE = {}
setmetatable( RectangleAoE, { __index = GameInstance } )

function RectangleAoE:update( dt )
    self._timer = self._timer + dt

    if self._timer >= self._triggertiming then
        self:trigger()
    end
end

function RectangleAoE:trigger()

end

function RectangleAoE:isTriggering()
    return self._timer >= self._triggertiming and self._timer < self._triggertiming + TRIGGERED_AOE_DURATION
end

function RectangleAoE:isPredicting()
    return self._timer <= self._prediction
end

function RectangleAoE:calcFadeOpaccity()
    -- local fadein = -(self._timer - AOE_FADEIN_DURATION)
    -- local fadeout = (self._timer - self._prediction - AOE_FADEOUT_DURATION)
    -- if fadein >= 0 then
    --     self._opacityrate = AOE_FADEIN_DURATION - fadein / AOE_FADEIN_DURATION
    -- elseif fadeout >= 0 then
    --     self._opacityrate = AOE_FADEOUT_DURATION - fadeout / AOE_FADEOUT_DURATION
    -- end

    -- 1 >= rate >= 0
end

function RectangleAoE:draw()
    local x, y = self:getPosition()

    love.graphics.push()

    if self:isTriggering() then
        love.graphics.setColor( self._colorTriggering.r, self._colorTriggering.g, self._colorTriggering.b, self._colorTriggering.a )
    elseif self:isPredicting() then
        love.graphics.setColor( self._color.r, self._color.g, self._color.b, self._color.a )
    else
        love.graphics.setColor( 0, 0, 0, 0 )
    end

    love.graphics.translate( self._x, -self._y )
    love.graphics.rotate( -self._rot )
    love.graphics.rectangle( 'fill', -self._h / 2, -self._w / 2, self._h, self._w )
    love.graphics.pop()
end

function RectangleAoE:delete()
    self:superDelete()
    self = nil
end

function RectangleAoE:new( args )
    local obj = GameInstance:new( args )
    obj.superDelete = obj.delete

    assert( args.sx and args.sy and args.tx and args.ty, 'RectangleAoE:new() requires sx, sy, tx, ty' )

    obj._x = (args.sx + args.tx) / 2
    obj._y = (args.sy + args.ty) / 2
    obj._rot = math.atan2( args.ty - args.sy, args.tx - args.sx )
    obj._w = args.w
    obj._h = math.sqrt( (args.tx - args.sx) ^ 2 + (args.ty - args.sy) ^ 2 )

    obj._timer = 0 -- AoEが設置されてからの時間
    obj._prediction = args.prediction or 0 -- 予兆が消えるまでの時間
    obj._triggertiming = 0 -- 当たり判定が確定するまでの時間
    obj._opacityrate = 0 -- 透明度との積を取り、フェードを表現

    obj._triggertiming = obj._prediction and obj._prediction + AOE_TIMELAG_BETWEEN_UNDISPLAYED_AND_TRIGGERED

    obj._color = { r = AOE_COLOR_RED, g = AOE_COLOR_GREEN, b = AOE_COLOR_BLUE, a = AOE_COLOR_ALPHA }
    obj._colorTriggering = { r = TRIGGERED_AOE_COLOR_RED, g = TRIGGERED_AOE_COLOR_GREEN, b = TRIGGERED_AOE_COLOR_BLUE, a = TRIGGERED_AOE_COLOR_ALPHA }

    return setmetatable( obj, {
        __index = RectangleAoE,
        __tostring = function()
            return 'RectangleAoE'
        end
    } )
end

return RectangleAoE
