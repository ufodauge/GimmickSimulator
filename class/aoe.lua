local Lume = require 'lib.lume'

local AOE = GameInstance:extend( 'AOE' ) -- AOE ではなくなってしまった　反省

function AOE:init( type, display, trigger, settings )
    self.super:init( self )

    self:setType( type )
    self:setPosition( settings.x, settings.y )
    self:setSize( settings.w, settings.h )
    self:setRadius( settings.rad )
    self:setHole( settings.hole )
    self:setAngle( settings.angle )
    self:setRot( settings.rot )
    self:setEffect( settings.effect )

    self:setDisplayTiming( display )
    self:setTriggerTiming( trigger )

    self.color = { r = AOE_COLOR_RED, g = AOE_COLOR_GREEN, b = AOE_COLOR_BLUE, a = AOE_COLOR_ALPHA }
    self.colorTriggering = { r = AOE_COLOR_TRIGGERING_RED, g = AOE_COLOR_TRIGGERING_GREEN, b = AOE_COLOR_TRIGGERING_BLUE, a = AOE_COLOR_TRIGGERING_ALPHA }

    self.triggeredFrame = 0
end


-- type: 'circle', 'rectangle', 'sector'
function AOE:setType( type )
    self.type = type

    self.x = 0
    self.y = 0

    if type == 'circle' then
        self.radius = 0
        self.hole = 0
    elseif type == 'rectangle' then
        self.width = 0
        self.height = 0
        self.rot = 0
    elseif type == 'sector' then
        self.radius = 0
        self.rot = 0
        self.angle = 0
        self.hole = 0
    end

    self.timer = 0
end


function AOE:setPosition( x, y )
    self.x = x
    self.y = y
end


function AOE:setSize( width, height )
    self.width = width
    self.height = height
end


function AOE:setRadius( radius )
    self.radius = radius
end


function AOE:setHole( hole )
    self.hole = hole
end


function AOE:setAngle( angle )
    self.angle = angle
end


function AOE:setRot( rot )
    self.rot = rot
end


function AOE:setEffect( effect )
    self.effect = effect
end


function AOE:setDisplayTiming( display_timing )
    self.display_timing = display_timing
end


function AOE:setTriggerTiming( trigger_timing )
    self.trigger_timing = trigger_timing
end


function AOE:update( dt )
    if self.started then
        self.timer = self.timer + dt
    end

    if self.timer >= self.trigger_timing then
        self:trigger()
    end

    if self:isTriggering() and self.effect then
        self.effect()
    end

end


function AOE:draw()
    if self.timer >= self.display_timing and self.timer < self.trigger_timing then
        love.graphics.setColor( self.color.r, self.color.g, self.color.b, self.color.a )
        if self.type == 'circle' then
            self:drawCircle()
        elseif self.type == 'rectangle' then
            self:drawRectangle()
        elseif self.type == 'sector' then
            self:drawSector()
        end

    elseif self.timer >= self.trigger_timing and self.timer < self.trigger_timing + AOE_TRIGGERING_DURATION then
        love.graphics.setColor( self.colorTriggering.r, self.colorTriggering.g, self.colorTriggering.b, self.colorTriggering.a )
        if self.type == 'circle' then
            self:drawCircle()
        elseif self.type == 'rectangle' then
            self:drawRectangle()
        elseif self.type == 'sector' then
            self:drawSector()
        end

    end
end


function AOE:drawCircle()
    local x, y = self:getPosition()

    if self.hole and self.hole > 0 then
        local stencil = function()
            love.graphics.circle( 'fill', x, y, self.hole )
        end


        love.graphics.stencil( stencil, 'replace', 1 )
    end

    love.graphics.setStencilTest( 'equal', 0 )
    love.graphics.circle( 'fill', x, y, self.radius )
    love.graphics.setStencilTest()
end


function AOE:drawRectangle()
    if self.rot and self.rot > 0 then
        love.graphics.push()
        love.graphics.translate( self.x, self.y )
        love.graphics.rotate( self.rot )
        love.graphics.rectangle( 'fill', -self.width / 2, -self.height / 2, self.width, self.height )
        love.graphics.pop()
    else
        love.graphics.rectangle( 'fill', self.x - self.width / 2, self.y - self.height / 2, self.width, self.height )
    end
end


-- 検証してない
function AOE:drawSector()
    if self.rot and self.rot > 0 then
        love.graphics.push()
        love.graphics.translate( self.x, self.y )
        love.graphics.rotate( self.rot )

        love.graphics.arc( 'fill', 0, 0, self.radius, self.angle, math.pi * 2 - self.angle )

        love.graphics.pop()
    else
        love.graphics.arc( 'fill', self.x, self.y, self.radius, self.angle, math.pi * 2 - self.angle )
    end
end


function AOE:start()
    self.timer = 0
    self.started = true
end


function AOE:stop()
    self.timer = 0
    self.started = false
end


function AOE:trigger()
    self.triggeredFrame = self.triggeredFrame + 1
end


function AOE:isTriggering()
    return self.triggeredFrame == 1
end


function AOE:isTriggered()
    return self.triggeredFrame > 0
end


-- 当たり判定が壊れている？
function AOE:isInTheArea( x, y )
    if self.type == 'circle' then
        return self:isInTheCircle( x, y )
    elseif self.type == 'rectangle' then
        return self:isInTheRectangle( x, y )
    elseif self.type == 'sector' then
        return self:isInTheSector( x, y )
    end
end


function AOE:isInTheCircle( x, y )
    local x, y = self:getPosition()
    local radius = self.radius

    return (x - self.x) ^ 2 + (y - self.y) ^ 2 <= radius ^ 2
end


function AOE:isInTheRectangle( x, y )
    local x, y = self:getPosition()
    local width, height = self:getSize()

    return x >= self.x - width / 2 and x <= self.x + width / 2 and y >= self.y - height / 2 and y <= self.y + height / 2
end


function AOE:isInTheSector( x, y )
    local x, y = self:getPosition()
    local radius = self.radius

    local dx = x - self.x
    local dy = y - self.y

    local distance = math.sqrt( dx ^ 2 + dy ^ 2 )

    if distance > radius then
        return false
    end

    local angle = math.atan2( dy, dx )

    if angle < 0 then
        angle = angle + math.pi * 2
    end

    return angle >= self.angle and angle <= math.pi * 2 - self.angle
end


-- 当たり判定実装部分ここまで

function AOE:reset()
    self.timer = 0
    self.triggeredFrame = 0
end


function AOE:delete()
    AOE.super:delete( self ) -- selfを明示的に書いてあげる必要あり
end


return AOE
