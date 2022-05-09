local Class = require 'lib.30log.30log'

local KeyManager = Class( 'KeyManager' )

local function judge_action_type( action_type )
    action_type = action_type or 'pressed'
    if action_type == 'pressed' then
        -- pass
    elseif action_type == 'released' then
        -- pass
    else
        error( 'incorrect action_type was called' )
    end
end


-- 初期化処理
function KeyManager:init()
    self.key_updator = {}
    self.post_process = function()
    end


    self.pre_process = function()
    end


end


-- キー入力の登録をする
-- key:     入力するキー
-- premisekey:  前提となるキー
-- func:    入力されたときに呼び出される関数
-- (rep:    リピート入力を有効化するか否か)
-- (act:    "pressed" or "released")
function KeyManager:register( properties )
    for i, property in ipairs( properties ) do
        -- 引数の確認および修正
        local action_type = property.act or 'pressed'
        local repeat_type = property.rep and 'repeat' or 'unrepeat'
        judge_action_type( action_type )

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

        print( '----------' )
        print( '\tkey : ' .. property.key .. '\n\trepeat : ' .. repeat_type .. '\n\ttype : ' .. action_type )
        print( '----------' )
    end
end


function KeyManager:setPreProcess( func )
    self.pre_process = func
end


function KeyManager:setPostProcess( func )
    self.post_process = func
end


-- function KeyManager:register(key, func, rep, action_type)
--     -- 引数の確認および修正
--     action_type = action_type or 'pressed'
--     repeat_type = rep and 'repeat' or 'unrepeat'
--     judge_action_type(action_type)

--     self.key_updator[key] =
--         self.key_updator[key] or
--         {
--             key = key,
--             -- 押下フレーム（状態遷移図に基づく）
--             frame_count = 0
--         }

--     self.key_updator[key]['func_' .. action_type .. '_' .. repeat_type] = func

--     print('----------')
--     print('\tkey : ' .. key .. '\n\trepeat : ' .. repeat_type .. '\n\ttype : ' .. action_type)
--     print('----------')
-- end

function KeyManager:update( dt )
    self.pre_process()

    for k, keys in pairs( self.key_updator ) do
        -- pressed function
        if love.keyboard.isDown( keys.key ) then
            keys.frame_count = keys.frame_count <= 0 and 1 or keys.frame_count + 1
        else
            keys.frame_count = keys.frame_count >= 1 and 0 or keys.frame_count - 1
        end

        -- pressed on the frame
        if keys.frame_count == 1 and keys.func_pressed_unrepeat then
            keys.func_pressed_unrepeat( dt )
        end

        -- pressed before
        if keys.frame_count >= 1 and keys.func_pressed_repeat then
            keys.func_pressed_repeat( dt )
        end

        -- released on the frame
        if keys.frame_count == 0 and keys.func_released_unrepeat then
            keys.func_released_unrepeat( dt )
        end

        -- released before
        if keys.frame_count <= 0 and keys.func_released_repeat then
            keys.func_released_repeat( dt )
        end
    end

    self.post_process()
end


-- for debugging
function KeyManager:getFrameCount( key )
    return self.key_updator[key].frame_count
end


return KeyManager
