-- -pi < x < pi
-- examle:
--
--     if self.aiming_direction:get() < 0 then
--         self.aiming_direction:set( self.aiming_direction:get() + dt * math.pi )
--     else
--         self.aiming_direction:set( self.aiming_direction:get() - dt * math.pi )
--     end
local Angle = Class( 'Angle' )

local function angle_fix( angle )
    if angle < -math.pi then
        angle = angle + 2 * math.pi
    elseif angle > math.pi then
        angle = angle - 2 * math.pi
    end
    return angle
end


function Angle:init( angle )
    self:set( angle )
end


function Angle:set( angle )
    self.angle = angle_fix( angle )
end


function Angle:get()
    return self.angle
end


function Angle:__add( other )
    local angle = angle_fix( self.angle + other.angle )

    return Angle( angle )
end


function Angle:__sub( other )
    local angle = angle_fix( self.angle - other.angle )

    return Angle( angle )
end


function Angle:__unm()
    return Angle( -self.angle )
end


function Angle:__tostring()
    return 'Angle(' .. self.angle .. ')'
end


function Angle:__pow( other )
    return Angle( self.angle ^ other )
end


return Angle
