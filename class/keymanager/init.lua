local path = ...
path = path .. '.'

Keyboard = require( path .. 'module.keyboard' )

local KeyManager = {}

-- key:     入力するキー
-- func:    入力されたときに呼び出される関数
-- (prem:   前提となるキー)
-- (rep:    "repeat")
-- (act:    "pressed" or "released")
function KeyManager:add( key, func, ... )
    table.insert( self.keys, Keyboard.new( key, func, ... ) )
end


function KeyManager:update( dt )
    for i, key in ipairs( self.keys ) do
        key:update( dt )
    end
end


-- 初期化処理
function KeyManager:new()

    local obj = {}

    obj.keys = {}

    setmetatable( obj, { __index = KeyManager } )

    return obj
end


return KeyManager
