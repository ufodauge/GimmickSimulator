-- lib
local Lume = require 'lib.lume'

-- Class
local GameInstance = require 'class.gameinstance'
local KeyManager = require 'class.keyboard.manager'
local Keyboard = require 'class.keyboard'
local MouseManager = require 'class.mouse.manager'
local Mouse = require 'class.mouse'

local Player = {}
setmetatable( Player, { __index = GameInstance } )

function Player:update( dt )
  if self:isPlayable() then
    if not self:isStunned() or not self:isBlowing() then
      self._keyManager:update( dt )
    end
    self._mouseManager:update( dt )
    if self:isCameraRotatable() then
      self:moveCameraTo( self._x, self._y )
      self:zoomCameraTo( self._zoomScale, true )
    end
  end

  if self:isStunned() then
    self._stun = self._stun - dt
  end
  if self:isBlowing() then
    self._blow = self._blow - dt
  end

  self:move()
  self:updateDirention( dt )
end

function Player:delete()
  self:superDelete()
  self = nil
end

-- 付け焼刃実装
function Player:updateDirention( dt )
  local diff = self._targetrot - self._rot - math.pi / 2
  local amplitude = 0

  if diff < -math.pi then
    diff = diff + 2 * math.pi
  elseif diff > math.pi then
    diff = diff - 2 * math.pi
  end

  if math.abs( diff ) <= math.pi / 180 then
    amplitude = 0
  elseif math.abs( diff ) >= dt * math.pi then
    amplitude = diff > 0 and dt * PLAYER_ROT_SPEED or -dt * PLAYER_ROT_SPEED
  else
    amplitude = diff
  end

  self:rotateTo( self._rot + amplitude )
end

function Player:move()
  -- 吹き飛ばし時：移動は制御され、回転もできない
  if self:isBlowing() then
    local dx = self._blowdx * (self._blow / self._blowstart) /
                   love.timer.getFPS()
    local dy = self._blowdy * (self._blow / self._blowstart) /
                   love.timer.getFPS()

    self._x = self._x + dx
    self._y = self._y + dy
  else
    local denominator = math.sqrt( self._dx * self._dx + self._dy * self._dy )
    if denominator == 0 then
      return
    end

    local dx = self._dx * PLAYER_SPEED / denominator
    local dy = self._dy * PLAYER_SPEED / denominator

    self._x = self._x + dx
    self._y = self._y + dy
    self._targetrot = math.atan2( self._dy, self._dx )
  end

  self._dx, self._dy = 0, 0
end

function Player:stun( sec )
  self._stun = sec
end

function Player:isStunned()
  return self._stun > 0
end

function Player:blowBack( dx, dy, sec )
  self._blow = sec
  self._blowstart = sec
  self._blowdx = dx
  self._blowdy = dy
end

function Player:isBlowing()
  return self._blow > 0
end

function Player:moveForward()
  local rot = self:getCameraRotation() + math.pi / 2
  self._dx = self._dx + math.cos( rot ) * self._speed
  self._dy = self._dy + math.sin( rot ) * self._speed
end

function Player:moveBackward()
  local rot = self:getCameraRotation() - math.pi / 2
  self._dx = self._dx + math.cos( rot ) * self._speed
  self._dy = self._dy + math.sin( rot ) * self._speed
end

function Player:moveLeft()
  local rot = self:getCameraRotation() + math.pi
  self._dx = self._dx + math.cos( rot ) * self._speed
  self._dy = self._dy + math.sin( rot ) * self._speed
end

function Player:moveRight()
  local rot = self:getCameraRotation()
  self._dx = self._dx + math.cos( rot ) * self._speed
  self._dy = self._dy + math.sin( rot ) * self._speed
end

function Player:playable()
  self._playable = true
end

function Player:nonplayable()
  self._playable = false
end

function Player:isPlayable()
  return self._playable
end

function Player:addDebuff( debuff )
  Lume.push( self._debuffs, debuff )
end

function Player:removeDebuff( debuff )
  Lume.remove( self._debuffs, debuff )
end

function Player:removeDebuffs()
  Lume.clear( self._debuffs )
end

function Player:getDebuffs()
  return unpack( self._debuffs )
end

function Player:getIcon()
  return self._icon
end

function Player:toggleCameraRotatable()
  self._cameraRotatable = not self._cameraRotatable
end

function Player:isCameraRotatable()
  return self._cameraRotatable
end

function Player:new( args )
  local obj = GameInstance:new( args )
  obj.superDelete = obj.delete

  obj._icon = args.icon
  obj._speed = PLAYER_SPEED
  obj._playable = args.playable or false
  obj._next = args.next
  obj._zoomScale = args.zoomScale or 1
  obj._rot = 0
  obj._targetrot = math.pi / 2
  obj._dx = 0
  obj._dy = 0
  obj._camerarotatable = false
  obj._stun = 0
  obj._blow = 0
  obj._blowstart = 0
  obj._blowdx, obj._blowdy = 0, 0

  obj._debuffs = {}

  local keyW = Keyboard:new( 'w', function( self, dt, f )
    if f > 0 then
      obj:moveForward()
    end
  end )
  local keyS = Keyboard:new( 's', function( self, dt, f )
    if f > 0 then
      obj:moveBackward()
    end
  end )
  local keyA = Keyboard:new( 'a', function( self, dt, f )
    if f > 0 then
      obj:moveLeft()
    end
  end )
  local keyD = Keyboard:new( 'd', function( self, dt, f )
    if f > 0 then
      obj:moveRight()
    end
  end )
  local keyC = Keyboard:new( 'c', function( self, dt, f )
    if f == 0 then
      obj:toggleCameraRotatable()
    end
  end )
  obj._keyManager = KeyManager:new()
  obj._keyManager:add( keyW, keyS, keyA, keyD, keyC )

  local mouseLeft = Mouse:new( 'left', function( self, dt, f )
    if f > 0 and obj:isCameraRotatable() then
      local xb, yb = obj._mouseManager:getPositionBefore()
      local mx, my = love.mouse.getPosition()
      local x, y = love.graphics.getWidth() / 2,
                   love.graphics.getHeight() / 2 + PLAYER_CAMERA_TILT
      local rotA = math.atan2( y - yb, x - xb )
      local rotB = math.atan2( y - my, x - mx )
      obj:rotateCamera( rotB - rotA )
      obj:setCameraCenter( love.graphics.getWidth() / 2,
                           love.graphics.getHeight() / 2 + PLAYER_CAMERA_TILT )
    end

    if obj:isCameraRotatable() then
      obj:setCameraCenter( love.graphics.getWidth() / 2,
                           love.graphics.getHeight() / 2 + PLAYER_CAMERA_TILT )
    else
      obj:moveCameraTo( 0, 0 )
      obj:zoomCameraTo( 0.75 )
      obj:rotateCameraTo( 0 )
      obj:setCameraCenter( love.graphics.getWidth() / 2,
                           love.graphics.getHeight() / 2 )
    end
  end )
  local mouseScroll = Mouse:new( 'wheel', function( self, x, y )
    -- 目的倍率が遠いほど速くズームする
    obj._zoomScale = obj:getCameraZoomScale() + y * 0.12
  end )
  obj._mouseManager = MouseManager:new()
  obj._mouseManager:add( mouseLeft, mouseScroll )

  obj:setCameraCenter( love.graphics.getWidth() / 2,
                       love.graphics.getHeight() / 2 + PLAYER_CAMERA_TILT )

  return setmetatable( obj, {
    __index = Player,
    __tostring = function()
      return 'Player'
    end
  } )

end

return Player
