local Mouse = {}

local KEY_TYPE_LEFT = 1
local KEY_TYPE_RIGHT = 2
local KEY_TYPE_MIDDLE = 3

local KEY_PRESSED_MAX_FRAME = 600
local KEY_PRESSED_MIN_FRAME = -600

function Mouse:update( dt )
    if self.key == 'wheel' then
        if self.wheeldetected then
            self:func( self.wheelx, self.wheely )
            self.wheeldetected = false
            self.wheelx, self.wheely = 0, 0
        end
    else

        if love.mouse.isDown( self.key ) then
            self.pressedframes = self.pressedframes <= 0 and 1 or math.min( self.pressedframes + 1, KEY_PRESSED_MAX_FRAME )
        else
            self.pressedframes = self.pressedframes > 0 and 0 or math.max( self.pressedframes - 1, KEY_PRESSED_MIN_FRAME )
        end

        -- 前提キーがあるならその押下判定を、ないなら無条件で true
        local premisekeyCondition = self.premisekey and love.keyboard.isDown( self.premisekey ) or true

        if premisekeyCondition then
            self:func( dt, self.pressedframes )
        end
    end

end

function Mouse:updateWheelMoves( x, y )
    self.wheeldetected = true
    self.wheelx, self.wheely = x, y
end

function Mouse:new( key, func, premisekey )
    local obj = {}

    obj.pressedframes = KEY_PRESSED_MIN_FRAME

    if key == 'left' then
        obj.key = KEY_TYPE_LEFT
    elseif key == 'right' then
        obj.key = KEY_TYPE_RIGHT
    elseif key == 'middle' then
        obj.key = KEY_TYPE_MIDDLE
    else
        obj.key = key
    end
    obj.func = func
    obj.wheeldetected = false
    obj.wheelx, obj.wheely = 0, 0

    obj.premisekey = premisekey or nil

    return setmetatable( obj, {
        __index = Mouse,
        __tostring = function()
            return 'Mouse'
        end
    } )
end

return Mouse
