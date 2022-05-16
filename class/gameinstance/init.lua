local path = ...
path = path .. '.'

local Camera = require( path .. 'module.camera' )

local GameInstance = {}

local GAMEINSTANCE_HITBOX_RADIUS = 2

function GameInstance:attachCamera()
    if self:isHud() then
        return
    end
    self._camera:attach()
end

function GameInstance:detachCamera()
    if self:isHud() then
        return
    end
    self._camera:detach()
end

function GameInstance:moveCameraTo( x, y )
    self._camera:moveTo( x, y )
end

function GameInstance:moveCamera( dx, dy )
    self._camera:move( dx, dy )
end

function GameInstance:cameraPosition()
    return self._camera:position()
end

function GameInstance:setCameraCenter( x, y )
    self._camera:setCameraCenter( x, y )

end

function GameInstance:rotateCamera( angle )
    self._camera:rotate( angle )
end

function GameInstance:cameraRotation()
    return self._camera:rotation()
end

function GameInstance:zoomCamera( ds )
    self._camera:zoom( ds )
end

function GameInstance:cameraZoomScale()
    return self._camera:zoom()
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

function GameInstance:isHud()
    return self._isHud
end

function GameInstance:move( x, y )
    self._x = self._x + x
    self._y = self._y + y
end

function GameInstance:rotate( rot )
    self._rot = self._rot + rot
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

function GameInstance:delete()
    setmetatable( self, { __mode = 'kv' } )
    self = nil
end

function GameInstance:new( tbl )
    local obj = {}

    obj._x = tbl.x or 0
    obj._y = tbl.y or 0
    obj._scale = tbl.scale or 1
    obj._rot = tbl.rot or 0
    obj._image = tbl.image or nil
    obj._drawPriority = tbl.drawPriority or 0

    obj._width = tbl.image and tbl.image:getWidth() or 0
    obj._height = tbl.image and tbl.image:getHeight() or 0

    obj._isHud = tbl.isHud or false
    obj._mesh = tbl.mesh or nil

    obj._camera = Camera:getInstance()

    setmetatable( obj, { __index = GameInstance } )

    return obj
end

return GameInstance
