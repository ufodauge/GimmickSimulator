local Mouse = {}

local keyrepeattypes = { 'repeat' }
local triggertypes = { 'pressed', 'released' }

local meta = {}
function meta:has( key )
    for i, k in ipairs( self ) do
        if k == key then
            return true
        end
    end
    return false
end

setmetatable( keyrepeattypes, { __index = meta } )
setmetatable( triggertypes, { __index = meta } )

function Mouse:update( dt )
    if self.key == 'wheel' then
        if self.wheeldetected then
            self.func( self.wheelx, self.wheely )
            self.wheeldetected = false
            self.wheelx, self.wheely = 0, 0
        end
    else

        if love.mouse.isDown( self.key ) then
            self.pressedframes = self.pressedframes <= 0 and 1 or math.min( self.pressedframes + 1, 128 )
        else
            self.pressedframes = self.pressedframes > 0 and 0 or math.max( self.pressedframes - 1, -127 )
        end

        -- 前提キーがあるならその押下判定を、ないなら無条件で true
        local premisekeyCondition = self.premisekey and love.keyboard.isDown( self.premisekey ) or true
        local triggertypeCondition = (self.trigger == 'pressed' and self.pressedframes > 0) or (self.trigger == 'released' and self.pressedframes <= 0)
        local keyrepeattypeCondition = self.keyrepeat and (self.pressedframes >= 1 or self.pressedframes <= 0) or
                                           (self.pressedframes == 1 or self.pressedframes == 0)

        if premisekeyCondition and triggertypeCondition and keyrepeattypeCondition then
            self.func( dt )
        end
    end

end

function Mouse:updateWheelMoves( x, y )
    self.wheeldetected = true
    self.wheelx, self.wheely = x, y
end

function Mouse:new( key, func, ... )
    local args = { ... }

    local obj = {}

    obj.pressedframes = 0

    obj.key = key
    obj.func = func
    obj.wheeldetected = false
    obj.wheelx, obj.wheely = 0, 0

    obj.premisekey = nil
    obj.keyrepeat = false
    obj.trigger = 'pressed'
    for index, value in ipairs( args ) do
        if keyrepeattypes:has( value ) then
            obj.keyrepeat = true
        elseif triggertypes:has( value ) then
            obj.trigger = value
        elseif type( value ) == 'string' then
            obj.premisekey = value
        end
    end

    setmetatable( obj, { __index = Mouse } )

    return obj
end

return Mouse
