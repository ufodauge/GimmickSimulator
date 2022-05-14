-- Class
local GameInstance = require 'class.gameinstance'
local KeyManager = require 'class.keymanager'

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
local Test = GameInstance:extend( 'Test' )

function Test:init( ... )
    Test.super:init( ... )

    self.keyManager = KeyManager:new()
    self.keyManager:add( 'w', function()
        self:move( 0, 10 )
    end
, 'repeat' )
    self.keyManager:add( 'd', function()
        self:move( 10, 0 )
    end
, 'repeat' )
    self.keyManager:add( 's', function()
        self:move( 0, -10 )
    end
, 'repeat' )
    self.keyManager:add( 'a', function()
        self:move( -10, 0 )
    end
, 'repeat' )
    self.keyManager:add( 'q', function()
        self:rotate( -1 * math.pi / 180 )
    end
, 'repeat' )
    self.keyManager:add( 'e', function()
        self:rotate( 1 * math.pi / 180 )
    end
, 'repeat' )
    self.keyManager:add( 'i', function()
        self:delete()
    end
 )
end


function Test:move( x, y )
    self._x = self._x + x
    self._y = self._y + y
end


function Test:rotate( rot )
    self._rot = self._rot + rot
end


function Test:update( dt )
    self.keyManager:update( dt )
    self:moveCameraTo( self._x, self._y )
end


function Test:delete( obj )
    Test.super:delete( obj )
    obj = nil
end


return Test
