local FieldMarker = GameInstance:extend( 'FieldMarker' )

function FieldMarker:init( settings )
    self.super:init( self )

    self.x = settings.x
    self.y = -settings.y
    self.duration = settings.duration

    self:setScale( settings.scale )

    -- 1, 2, 3, 4, A, B, C, D
    -- 使ってない
    self.marker = settings.marker
    self.timer = 0

    self:setImage( settings.image )
end


function FieldMarker:update( dt )
    if self.duration then
        self.timer = self.timer + dt
        if self.timer > self.duration then
            self:delete()
        end
    end

end


function FieldMarker:delete()
    self.super:delete( self ) -- selfを明示的に書いてあげる必要あり
end


return FieldMarker
