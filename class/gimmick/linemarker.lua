-- Class
local GameInstance = require 'class.gameinstance'

local LineMarker = {}
setmetatable( LineMarker, { __index = GameInstance } )

function LineMarker:update( dt )
  self._timer = self._timer + dt
  self:updatePositions()

  if self._timer >= self._triggertiming then
    self.func()
    self:delete()
    self = nil
  end
end

function LineMarker:updatePositions()
  self._tx, self._ty = self._target:getPosition()

  self._x = (self._sx + self._tx) / 2
  self._y = (self._sy + self._ty) / 2
  self._rot = math.atan2( self._ty - self._sy, self._tx - self._sx )
  self._h = math.sqrt( (self._tx - self._sx) ^ 2 + (self._ty - self._sy) ^ 2 )
end

function LineMarker:delete()
  self:_superDelete()
  self = nil
end

function LineMarker:draw()
  local x, y = self:getPosition()

  love.graphics.push()
  love.graphics.setColor( 1, 1, 1, 1 )

  love.graphics.translate( self._x, -self._y )
  love.graphics.rotate( -self._rot )
  love.graphics
      .draw( self._image, -self._h / 2, -self._w / 2, self._h, self._w )
  love.graphics.pop()
end

function LineMarker:new( args )
  local obj = GameInstance:new( args )
  obj._superDelete = obj.delete

  obj._sx, obj._sy = args.sx, args.sy
  obj._target = args.target
  obj._tx, obj._ty = args.target:getPosition()
  obj._w = obj:getWidth()

  obj:updatePositions()

  obj._triggertiming = args.triggertiming
  obj._func = args.func or function()

  end
  obj._timer = 0

  return setmetatable( obj, { __index = LineMarker } )
end

return LineMarker
