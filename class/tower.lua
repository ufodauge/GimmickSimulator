local Tower = GameInstance:extend( 'Tower' )

function Tower:init( image, duration, settings )
    self.super:init( self )
    self.fielrMarker = FieldMarker( { image = image, x = settings.x, y = settings.y } )

    self.timer = 0
    self.duration = duration
end


function Tower:update( dt )
    self.timer = self.timer + dt
    if self.timer > self.duration then
        self:delete()
    end
end


function Tower:delete()
    self.fielrMarker:delete()
    self.super:delete( self ) -- selfを明示的に書いてあげる必要あり
end


return Tower
