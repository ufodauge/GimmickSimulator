-- Class
local GameInstance = require 'class.gameinstance'
local PlayerManager = require( 'class.hud.debufflist' ):getInstance()

local Debuff = {}
setmetatable( Debuff, { __index = GameInstance } )

function Debuff:update( dt )
  self._timer = self._timer + dt

  if self._timer >= self._triggertiming then
    self._func()
    self._target:removeDebuff( self )
    self:delete()
  end
end

function Debuff:draw( x, y, scale )
  if not x then
    return
  end

  love.graphics.draw( self._image, x, y, 0, scale )
end

function Debuff:delete()
  self:_superDelete()
  self = nil
end

function Debuff:getRemainTime()
  return self._triggertiming - self._timer
end

function Debuff:new( args )
  local obj = GameInstance:new( args )
  obj._superDelete = obj.delete

  obj._isHud = true
  obj._timer = 0
  obj._target = args.target or nil
  assert( obj._target, 'argument \'target\' is nil' )

  obj._triggertiming = args.triggertiming
  obj._func = args.func or function()

  end

  return setmetatable( obj, {
    __index = Debuff,
    __tostring = function()
      return 'Debuff'
    end
  } )
end

return Debuff
