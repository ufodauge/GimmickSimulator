local GameInstance = require 'class.gameinstance'

local FieldObject = {}
setmetatable( FieldObject, { __index = GameInstance } )

function FieldObject:delete()
  self:superDelete()
  self = nil
end

function FieldObject:draw()
  if self:getImage() then
    local x0, y0 = self:getOrigin()
    local w, h = self:getSize()

    local tx, ty = x0 + w / 2, -(y0 + h / 2)

    love.graphics.push()
    love.graphics.translate( tx, ty )
    love.graphics.scale( self:getScale() )
    love.graphics.rotate( -self:getRotation() )
    love.graphics.setColor( 1, 1, 1, 1 )
    love.graphics.draw( self:getImage(), -w / 2, -h / 2 )
    love.graphics.setColor( 1, 0, 0, 1 )
    love.graphics.circle( 'line', 0, 0, GAMEINSTANCE_HITBOX_RADIUS )
    love.graphics.setColor( 1, 1, 1, 1 )
    love.graphics.pop()
  end
end

function FieldObject:new( ... )
  local obj = GameInstance:new( ... )
  obj.superDelete = obj.delete

  return setmetatable( obj, {
    __index = FieldObject,
    __tostring = function()
      return 'FieldObject'
    end
  } )
end

return FieldObject
