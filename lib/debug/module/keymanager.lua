local Private = {}
local Public = {}

function Public:getInstance()
    if Private.instance == nil then
        Private.instance = Private.new()
    end

    assert( Private.instance ~= nil, 'GameInstance:getInstance() is not called yet.' )
    return Private.instance
end


-- key:     入力するキー
-- func:    入力されたときに呼び出される関数
-- (prem:   前提となるキー)
-- (rep:    "repeat")
-- (act:    "pressed" or "released")
function Private:add( key, func, ... )
    table.insert( self.keys, Keyboard.new( key, func, ... ) )

end


function Private:update( dt )
    for i, key in ipairs( self.keys ) do
        key:update( dt )
    end
end


-- for debugging
function Private:getFrameCount( key )
    return self.key_updator[key].frame_count
end


-- 初期化処理
function Private.new()
    local obj = {}

    obj.key_updator = {}
    obj.post_process = function()
    end


    obj.pre_process = function()
    end


    setmetatable( obj, { __index = Private } )

    return obj
end


return Public
