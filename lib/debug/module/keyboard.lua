local Keyboard = {}

local keyrepeattypes = { 'repeat' }
local triggertypes = { 'pressed', 'released' }

local meta = {}
function meta:have( key )
    return self[key] ~= nil
end


keyrepeattypes = setmetatable( keyrepeattypes, { index = meta } )
triggertypes = setmetatable( triggertypes, { index = meta } )

function Keyboard:update( dt )
    if love.keyboard.isDown( self.key ) then
        self.pressedframes = self.pressedframes <= 0 and 1 or math.min( self.pressedframes + 1, 128 )
    else
        self.pressedframes = self.pressedframes > 0 and 0 or math.max( self.pressedframes - 1, -127 )
    end

    -- 前提キーがあるならその押下判定を、ないなら無条件で true
    local premisekeyCondition = self.premisekey and love.keyboard.isDown( self.premisekey ) or true
    local triggertypeCondition = (self.triggertype == 'pressed' and self.pressedframes > 0) or (self.triggertype == 'released' and self.pressedframes <= 0)
    local keyrepeattypeCondition = self.keyrepeattype and (self.pressedframes > 1 or self.pressedframes < -1) or true

    if premisekeyCondition and triggertypeCondition and keyrepeattypeCondition then
        self.func( dt )
    end

end


function Keyboard.new( key, func, ... )
    local args = ...

    local obj = {}

    obj.pressedframes = 0

    obj.premisekey = nil
    obj.keyrepeat = false
    obj.trigger = 'pressed'
    for index, value in ipairs( args ) do
        if keyrepeattypes:have( value ) then
            obj.keyrepeat = true
        elseif triggertypes:have( value ) then
            obj.triggertype = value
        elseif type( value ) == 'string' then
            obj.premisekey = value
        end
    end

    return setmetatable( obj, { __index = Keyboard } )
end


return Keyboard
