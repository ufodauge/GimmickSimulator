-- Class
local GIManager = require 'class.gimanager'
local GameInstance = require 'class.gimanager.instance'
local KeyManager = require 'class.keymanager'

local gim = GIManager:getInstance()

-- x, y: 座標
-- width, height: 幅と高さ
-- scale: 拡大率
-- rot: 回転角
-- drawPriority: 描画優先度
-- update( dt ): 更新
-- draw(): 描画
-- setImage( ImageObject ): 画像を設定
-- setPosition( x, y ): 座標を設定
-- setSize( width, height ): 幅と高さを設定
-- setScale( scale ): 拡大率を設定
-- setRotation( rot ): 回転角を設定
-- setDrawPriority( drawPriority ): 描画優先度を設定
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

function Test:init()
    Test.super:init( self )
    gim:setGameInstance( self )

    self.keyManager = KeyManager:new()
    self.keyManager:addKeys( {
        {
            key = 'w',
            func = function()
                self:move( 0, 10 )
            end
,
            rep = true,
            act = 'pressed'
        },
        {
            key = 'd',
            func = function()
                self:move( 10, 0 )
            end
,
            rep = true,
            act = 'pressed'
        },
        {
            key = 's',
            func = function()
                self:move( 0, -10 )
            end
,
            rep = true,
            act = 'pressed'
        },
        {
            key = 'a',
            func = function()
                self:move( -10, 0 )
            end
,
            rep = true,
            act = 'pressed'
        },
        {
            key = 'i',
            func = function()
                self:delete()
            end
,
            rep = true,
            act = 'pressed'
        }
    } )
end


function Test:move( x, y )
    self.x = self.x + x
    self.y = self.y + y
end


function Test:update( dt )
    self.keyManager:update( dt )
end


function Test:delete()
    Test.super:delete()
    self = nil
end


return Test
