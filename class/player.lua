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
    end
end

function Player:delete()
    self:_superDelete()
    self = nil
end

function Player:moveForward()
    local rot = self:cameraRotation() + math.pi / 2
    self:move( math.cos( rot ) * self._speed, math.sin( rot ) * self._speed )
end

function Player:moveBackward()
    local rot = self:cameraRotation() - math.pi / 2
    self:move( math.cos( rot ) * self._speed, math.sin( rot ) * self._speed )
end

function Player:moveLeft()
    local rot = self:cameraRotation() + math.pi
    self:move( math.cos( rot ) * self._speed, math.sin( rot ) * self._speed )
end

function Player:moveRight()
    local rot = self:cameraRotation()
    self:move( math.cos( rot ) * self._speed, math.sin( rot ) * self._speed )
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

function Player:next( player )
    self._next = player
end

function Player:new( ... )
    local obj = GameInstance:new( ... )

    setmetatable( obj, { __index = Player } )
    obj._superDelete = obj.delete

    local args = ...
    obj._speed = PLAYER_SPEED
    obj._playable = args.playable or false
    obj._next = args.next

    local keyW = Keyboard:new( 'w', function()
        obj:moveForward()
    end, 'repeat' )
    local keyS = Keyboard:new( 's', function()
        obj:moveBackward()
    end, 'repeat' )
    local keyA = Keyboard:new( 'a', function()
        obj:moveLeft()
    end, 'repeat' )
    local keyD = Keyboard:new( 'd', function()
        obj:moveRight()
    end, 'repeat' )
    local keyG = Keyboard:new( 'g', function()
        obj._next:playable()
        obj:nonplayable()
    end )
    obj._keyManager = KeyManager:new()
    obj._keyManager:add( keyW, keyS, keyA, keyD, keyG )

    local mouseLeft = Mouse:new( 1, function()
        local xb, yb = obj._mouseManager:getPositionBefore()
        local mx, my = love.mouse.getPosition()
        local x, y = love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 + PLAYER_CAMERA_TILT
        local rotA = math.atan2( y - yb, x - xb )
        local rotB = math.atan2( y - my, x - mx )
        obj:rotateCamera( rotB - rotA )
    end, 'repeat' )
    local mouseScroll = Mouse:new( 'wheel', function( x, y )
        obj:zoomCamera( 1 + y * 0.1 )
    end )
    obj._mouseManager = MouseManager:new()
    obj._mouseManager:add( mouseLeft, mouseScroll )

    obj:setCameraCenter( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 + PLAYER_CAMERA_TILT )

    return obj
end

return Player
