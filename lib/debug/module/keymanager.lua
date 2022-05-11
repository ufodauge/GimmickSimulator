local Private = {}
local Public = {}

local meta = {}
function meta:have( key )
    return self[key] ~= nil
end


local keyrepeatTypes = { 'repeat' }
local triggerTypes = { 'pressed', 'released' }
keyrepeatTypes = setmetatable( keyrepeatTypes, { __index = meta } )
triggerTypes = setmetatable( triggerTypes, { __index = meta } )

function Public:getInstance()
    if Private.instance == nil then
        Private.instance = Private.new()
    end

    assert( Private.instance ~= nil, 'GameInstance:getInstance() is not called yet.' )
    return Private.instance
end


local function judgeActionType( action_type )

    action_type = action_type or 'pressed'
    if action_type == 'pressed' then
        -- pass
    elseif action_type == 'released' then
        -- pass
    else
        error( 'incorrect action_type was called' )
    end
end


-- キー入力の登録をする
-- key:     入力するキー
-- premisekey:  前提となるキー
-- func:    入力されたときに呼び出される関数
-- (rep:    リピート入力を有効化するか否か)
-- (act:    "pressed" or "released")
function Private:register( properties )
    for i, property in ipairs( properties ) do
        -- 引数の確認および修正
        local action_type = property.act or 'pressed'
        local repeat_type = property.rep and 'repeat' or 'unrepeat'
        judgeActionType( action_type )

        self.key_updator[property.key] = self.key_updator[property.key] or {
            key = property.key,
            -- 押下フレーム（状態遷移図に基づく）
            frame_count = 0
        }

        if property.premisekey then
            property.func = function()
                if love.keyboard.isDown( property.premisekey ) then
                    property.func()
                end
            end


        end

        self.key_updator[property.key]['func_' .. action_type .. '_' .. repeat_type] = property.func
    end
end


-- key:     入力するキー
-- func:    入力されたときに呼び出される関数
-- (prem:   前提となるキー)
-- (rep:    "repeat")
-- (act:    "pressed" or "released")
function Private:add( key, func, ... )
    local args = ...
    local premisekey = nil
    local keyrepeat = false
    local trigger = 'pressed'
    for index, value in ipairs( args ) do
        if keyrepeatTypes:have( value ) then
            keyrepeat = true
        elseif triggerTypes:have( value ) then
            trigger = value
        elseif type( value ) == 'string' then
            premisekey = value
        end
    end

end


function Private:update( dt )
    for i, key in ipairs( self.keys ) do
        key:update( dt )
    end
    -- for k, keys in pairs( self.key_updator ) do
    --     -- pressed function
    --     if love.keyboard.isDown( keys.key ) then
    --         keys.frame_count = keys.frame_count <= 0 and 1 or keys.frame_count + 1
    --     else
    --         keys.frame_count = keys.frame_count >= 1 and 0 or keys.frame_count - 1
    --     end

    --     -- pressed on the frame
    --     if keys.frame_count == 1 and keys.func_pressed_unrepeat then
    --         keys.func_pressed_unrepeat( dt )
    --     end

    --     -- pressed before
    --     if keys.frame_count >= 1 and keys.func_pressed_repeat then
    --         keys.func_pressed_repeat( dt )
    --     end

    --     -- released on the frame
    --     if keys.frame_count == 0 and keys.func_released_unrepeat then
    --         keys.func_released_unrepeat( dt )
    --     end

    --     -- released before
    --     if keys.frame_count <= 0 and keys.func_released_repeat then
    --         keys.func_released_repeat( dt )
    --     end
    -- end
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
