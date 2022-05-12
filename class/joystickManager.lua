local JoystickManager = Class('JoystickManager')

local function judge_action_type(action_type)
    action_type = action_type or 'pressed'
    if action_type == 'pressed' then
        -- pass
    elseif action_type == 'released' then
        -- pass
    else
        error('incorrect action_type was called')
    end
end

-- 初期化処理
function JoystickManager:init(joystick)
    JoystickManager.joysticks = joystick or love.joystick.getJoysticks()

    if not JoystickManager.joysticks[1] then
        print('No Joystick Connection')
    else
        print('A Joystick Connection Detected')
    end

    self.inputs_table = {}
end

function love.joystickadded(joystick)
    JoystickManager.joysticks = joystick

    print('A Joystick Connection Detected')
end

function love.joystickremoved(joystick)
    JoystickManager.joysticks = joystick

    if not JoystickManager.joysticks[1] then
        print('No Joystick Connection')
    end
end

-- キー入力の登録をする
-- key:     入力するキー
-- func:    具体的な機能
-- (rep:    リピート入力を有効化するか否か)
-- (act:    "pressed" or "released")
function JoystickManager:register(properties)
    for i, property in ipairs(properties) do
        -- 引数の確認および修正
        local action_type = property.act or 'pressed'
        local repeat_type = property.rep and 'repeat' or 'unrepeat'
        judge_action_type(action_type)

        self.key_updator[property.key] =
            self.key_updator[property.key] or
            {
                key = property.key,
                -- 押下フレーム（状態遷移図に基づく）
                frame_count = 0
            }

        self.key_updator[property.key]['func_' .. action_type .. '_' .. repeat_type] = property.func

        print('----------')
        print('\tkey : ' .. property.key .. '\n\trepeat : ' .. repeat_type .. '\n\ttype : ' .. action_type)
        print('----------')
    end
end

function JoystickManager:update(dt)
    for k, keys in pairs(self.inputs_table) do
        -- pressed function
        if JoystickManager.joysticks[1]:isGamepadDown(keys.button) then
            keys.frame_count = keys.frame_count <= 0 and 1 or keys.frame_count + 1
        else
            keys.frame_count = keys.frame_count >= 1 and 0 or keys.frame_count - 1
        end

        -- pressed on the frame
        if keys.frame_count == 1 and keys.func_pressed_unrepeat then
            keys.func_pressed_unrepeat(dt)
        end

        -- pressed before
        if keys.frame_count >= 1 and keys.func_pressed_repeat then
            keys.func_pressed_repeat(dt)
        end

        -- released on the frame
        if keys.frame_count == 0 and keys.func_released_unrepeat then
            keys.func_released_unrepeat(dt)
        end

        -- released before
        if keys.frame_count <= 0 and keys.func_released_repeat then
            keys.func_released_repeat(dt)
        end
    end
end

-- for debugging
function JoystickManager:getFrameCount(button)
    return self.inputs_table[button].frame_count
end

return JoystickManager
