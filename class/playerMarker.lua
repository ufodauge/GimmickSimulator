local PlayerMarker = GameInstance:extend( 'PlayerMarker' )

function PlayerMarker:init()
    PlayerMarker.super:init( self )
end


function PlayerMarker:update( dt )
end


function PlayerMarker:draw()
    love.graphics.setColor( 1, 1, 1, 1 )
end


function PlayerMarker:delete()
    self.super.delete( self ) -- selfを明示的に書いてあげる必要あり
end


return PlayerMarker
