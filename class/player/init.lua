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
    self._keyManager:update( dt )
    self._mouseManager:update( dt )
    self:moveCameraTo( self._x, self._y )
    self:zoomCameraTo( self._zoomScale, true )
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
  local denominator = math.sqrt( self._dx * self._dx + self._dy * self._dy )
  if denominator == 0 then
    return
  end

  self._targetrot = math.atan2( self._dy, self._dx )

  local dx = self._dx * PLAYER_SPEED / denominator
  local dy = self._dy * PLAYER_SPEED / denominator

  self._x = self._x + dx
  self._y = self._y + dy
  self._dx, self._dy = 0, 0
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
  table.insert( self._debuffs, debuff )
end

function Player:new( args )
  local obj = GameInstance:new( args )
  obj.superDelete = obj.delete

  setmetatable( obj, { __index = Player } )

  obj._speed = PLAYER_SPEED
  obj._playable = args.playable or false
  obj._next = args.next
  obj._zoomScale = args.zoomScale or 1
  obj._rot = 0
  obj._targetrot = math.pi / 2
  obj._dx = 0
  obj._dy = 0

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
  obj._keyManager = KeyManager:new()
  obj._keyManager:add( keyW, keyS, keyA, keyD )

  local mouseLeft = Mouse:new( 'left', function( self, dt, f )
    if f > 0 then
      local xb, yb = obj._mouseManager:getPositionBefore()
      local mx, my = love.mouse.getPosition()
      local x, y = love.graphics.getWidth() / 2,
                   love.graphics.getHeight() / 2 + PLAYER_CAMERA_TILT
      local rotA = math.atan2( y - yb, x - xb )
      local rotB = math.atan2( y - my, x - mx )
      obj:rotateCamera( rotB - rotA )
    end
  end )
  local mouseScroll = Mouse:new( 'wheel', function( self, x, y )
    -- 目的倍率が遠いほど速くズームする
    obj._zoomScale = obj:getCameraZoomScale() + y * 0.1
  end )
  obj._mouseManager = MouseManager:new()
  obj._mouseManager:add( mouseLeft, mouseScroll )

  obj:setCameraCenter( love.graphics.getWidth() / 2,
                       love.graphics.getHeight() / 2 + PLAYER_CAMERA_TILT )

  return obj
end

return Player
