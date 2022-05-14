local path = ...
path = path .. '.'

local Class = require 'lib.30log.30log'
local Camera = require( path .. 'module.camera' )

local GameInstance = Class( 'GameInstance' )

local GAMEINSTANCE_HITBOX_RADIUS = 2

function GameInstance:init( x, y, drawPriority, image, scale, rot )
    if type( x ) == 'table' then
        self._x = x.x or 0
        self._y = x.y or 0
        self._scale = x.scale or 1
        self._rot = x.rot or 0
        self._image = x.image or nil
        self._drawPriority = x.drawPriority or 0

        self._width = x.image and x.image:getWidth() or 0
        self._height = x.image and x.image:getHeight() or 0
    else
        -- 描画優先度の指定
        -- 高いほど上側に描画される
        self._drawPriority = drawPriority or 0

        -- 初期位置
        -- この位置は基本的にオブジェクトの中心で考える
        self._x, self._y = x or 0, y or 0
        self._scale = scale or 1
        self._rot = rot or 0

        self._image = image or nil
        self._width = image and image:getWidth() or 0
        self._height = image and image:getHeight() or 0
    end

    self._camera = Camera:getInstance()
end


function GameInstance:attachCamera()
    self._camera:attach()
end


function GameInstance:detachCamera()
    self._camera:detach()
end


function GameInstance:moveCameraTo( x, y )
    self._camera:moveTo( x, y )
end


function GameInstance:position()
    return self._x, self._y
end


function GameInstance:size()
    return self._width, self._height
end


function GameInstance:scale()
    return self._scale
end


function GameInstance:rotation()
    return self._rot
end


-- オブジェクトの左上の位置を返す
function GameInstance:origin()
    return self._x - self._width / 2, self._y - self._height / 2
end


function GameInstance:image()
    return self._image
end


function GameInstance:drawPriority()
    return self._drawPriority
end


function GameInstance:update( dt )

end


function GameInstance:draw()
    if self:image() then
        local x0, y0 = self:origin()
        local w, h = self:size()

        local tx, ty = x0 + w / 2, -(y0 + h / 2)

        love.graphics.push()
        love.graphics.translate( tx, ty )
        love.graphics.scale( self:scale() )
        love.graphics.rotate( self:rotation() )
        love.graphics.setColor( 1, 1, 1, 1 )
        love.graphics.draw( self:image(), -w / 2, -h / 2 )
        love.graphics.pop()
    end
end


function GameInstance:debugDraw()
    local x0, y0 = self:origin()
    local x, y = self:position()
    local w, h = self:size()

    local tx, ty = x0 + w / 2, -(y0 + h / 2)

    love.graphics.push()
    love.graphics.translate( tx, ty )
    love.graphics.scale( self:scale() )
    love.graphics.rotate( self:rotation() )
    love.graphics.setColor( 1, 0, 0, 1 )
    love.graphics.rectangle( 'line', -w / 2, -h / 2, w, h )
    love.graphics.setColor( 1, 1, 1, 0.25 )
    love.graphics.rectangle( 'fill', -w / 2, -h / 2, w, h )
    love.graphics.pop()

    love.graphics.setColor( 1, 0, 0, 1 )
    love.graphics.circle( 'line', x, -y, GAMEINSTANCE_HITBOX_RADIUS )
end


function GameInstance:delete( obj )
    setmetatable( obj, { __mode = 'kv' } )
    obj = nil
end


return GameInstance
