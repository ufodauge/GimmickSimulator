-- Class
local GameInstance = require 'class.gameinstance'

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
local TestBG = {}
setmetatable( TestBG, { __index = GameInstance } )

function TestBG:init( ... )
    local obj = GameInstance:init( ... )
    obj.super_delete = obj.delete

    setmetatable( obj, { __index = TestBG } )

    return obj
end


function TestBG:update( dt )

end


function TestBG:delete()
    self:super_delete()
    self = nil
end


return TestBG
