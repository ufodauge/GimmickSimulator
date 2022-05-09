local Class = require 'lib.30log.30log'

local GameInstance = Class( 'GameInstance' )

local GAMEINSTANCE_HITBOX_RADIUS = 2

function GameInstance:init()
    -- 描画優先度の指定
    -- 高いほど上側に描画される
    self.drawPriority = 0

    -- 初期位置
    -- この位置は基本的にオブジェクトの中心で考える
    self.x, self.y = 0, 0
    self.width, self.height = 0, 0
    self.scale = 1
    self.rot = 0
end


function GameInstance:update( dt )

end


function GameInstance:setDrawPriority( drawPriority )
    self.drawPriority = drawPriority

end


function GameInstance:setPosition( x, y )
    self.x, self.y = x, y
end


function GameInstance:getPosition()
    return self.x, self.y
end


function GameInstance:setSize( w, h )
    self.width, self.height = w, h
end


function GameInstance:getSize()
    return self.width, self.height
end


function GameInstance:setScale( scale )
    self.scale = scale
end


function GameInstance:getScale()
    return self.scale
end


-- オブジェクトの左上の位置を返す
function GameInstance:getOrigin()
    return self.x - self.width / 2, self.y - self.height / 2
end


function GameInstance:setImage( ImageObject )
    self.ImageObject = ImageObject
    self.width, self.height = ImageObject:getWidth(), ImageObject:getHeight()
end


function GameInstance:draw()
    if self.ImageObject then
        local x0, y0 = self:getOrigin()
        local w, h = self:getSize()

        love.graphics.push()
        love.graphics.translate( x0 + w / 2, y0 + h / 2 )
        love.graphics.scale( self.scale )
        love.graphics.rotate( self.rot )
        love.graphics.setColor( 1, 1, 1, 1 )
        love.graphics.draw( self.ImageObject, -w / 2, -h / 2 )
        love.graphics.pop()
    end
end


function GameInstance:debugDraw()
    local x0, y0 = self:getOrigin()
    local x, y = self:getPosition()
    local w, h = self:getSize()

    love.graphics.push()
    love.graphics.translate( x0 + w / 2, y0 + h / 2 )
    love.graphics.scale( self.scale )
    love.graphics.rotate( self.rot )
    love.graphics.setColor( 1, 0, 0, 1 )
    love.graphics.rectangle( 'line', -w / 2, -h / 2, w, h )
    love.graphics.setColor( 1, 1, 1, 0.25 )
    love.graphics.rectangle( 'fill', -w / 2, -h / 2, w, h )
    love.graphics.pop()

    love.graphics.setColor( 1, 0, 0, 1 )
    love.graphics.circle( 'line', x, y, GAMEINSTANCE_HITBOX_RADIUS )

end


function GameInstance:delete()
    self = nil
end


return GameInstance
