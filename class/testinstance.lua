-- Class
local GameInstance = require 'class.gameinstance'
local KeyManager = require 'class.keyboard.manager'
local Keyboard = require 'class.keyboard'
local MouseManager = require 'class.mouse.manager'
local Mouse = require 'class.mouse'

-- x, y: 座標
-- width, height: 幅と高さ
-- scale: 拡大率
-- rot: 回転角
-- drawPriority: 描画優先度
-- update( dt ): 更新
-- draw(): 描画
-- getPosition(): 座標を返す
-- getSize(): 幅と高さを返す
-- getScale(): 拡大率を返す
-- getRotation(): 回転角を返す
-- getDrawPriority(): 描画優先度を返す
-- getImage(): 画像を返す
-- getOrigin(): 左上の位置を返す
-- disableAutoDraw(): 自動描画を無効化する
-- enableAutoDraw(): 自動描画を有効化する
-- delete(): 削除
local Test = {}
setmetatable( Test, { __index = GameInstance } )

function Test:update( dt )
    self._keyManager:update( dt )
    self._mouseManager:update( dt )
    self:moveCameraTo( self._x, self._y )
end


function Test:delete()
    self:_superDelete()
    self = nil
end


function Test:moveForward()
    local rot = self:cameraRotation() + math.pi / 2
    local x = math.cos( rot ) * self._speed
    local y = math.sin( rot ) * self._speed
    self:move( x, y )
end


function Test:moveBackward()
    local rot = self:cameraRotation() - math.pi / 2
    local x = math.cos( rot ) * self._speed
    local y = math.sin( rot ) * self._speed
    self:move( x, y )
end


function Test:moveLeft()
    local rot = self:cameraRotation() + math.pi
    local x = math.cos( rot ) * self._speed
    local y = math.sin( rot ) * self._speed
    self:move( x, y )
end


function Test:moveRight()
    local rot = self:cameraRotation()
    local x = math.cos( rot ) * self._speed
    local y = math.sin( rot ) * self._speed
    self:move( x, y )
end


function Test:new( ... )
    local obj = GameInstance:new( ... )
    obj._superDelete = obj.delete

    obj._speed = 10

    obj._keyManager = KeyManager:new()
    obj._keyManager:add( Keyboard:new( 'w', function()
        obj:moveForward()
    end
, 'repeat' ) )
    obj._keyManager:add( Keyboard:new( 'd', function()
        obj:moveRight()
    end
, 'repeat' ) )
    obj._keyManager:add( Keyboard:new( 's', function()
        obj:moveBackward()
    end
, 'repeat' ) )
    obj._keyManager:add( Keyboard:new( 'a', function()
        obj:moveLeft()
    end
, 'repeat' ) )
    obj._keyManager:add( Keyboard:new( 'q', function()
        obj:rotate( -1 * math.pi / 180 )
    end
, 'repeat' ) )
    obj._keyManager:add( Keyboard:new( 'e', function()
        obj:rotate( 1 * math.pi / 180 )
    end
, 'repeat' ) )
    obj._keyManager:add( Keyboard:new( 'left', function()
        obj:rotateCamera( 1 * math.pi / 180 )
    end
, 'repeat' ) )
    obj._keyManager:add( Keyboard:new( 'right', function()
        obj:rotateCamera( -1 * math.pi / 180 )
    end
, 'repeat' ) )

    obj._keyManager:add( Keyboard:new( 'up', function()
        obj:zoomCamera( 1.01 )
    end
, 'repeat' ) )
    obj._keyManager:add( Keyboard:new( 'down', function()
        obj:zoomCamera( 0.99 )
    end
, 'repeat' ) )

    obj._mouseManager = MouseManager:new()
    obj._mouseManager:add( Mouse:new( 1, function()
        local xb, yb = obj._mouseManager:getPositionBefore()
        local mx, my = love.mouse.getPosition()
        local x, y = love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 + 150
        local rotA = math.atan2( y - yb, x - xb )
        local rotB = math.atan2( y - my, x - mx )
        obj:rotateCamera( rotB - rotA )
    end
, 'repeat' ) )

    obj:setCameraCenter( love.graphics.getWidth() / 2, love.graphics.getHeight() / 2 + 150 )

    setmetatable( obj, { __index = Test } )

    return obj
end


return Test
