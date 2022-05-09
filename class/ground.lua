local Ground = GameInstance:extend( 'Ground' )

function Ground:init()
    self.super:init( self )

end


function Ground:update( dt )
end


function Ground:getWidth()
    return self.image:getWidth()
end


function Ground:getHeight()
    return self.image:getHeight()
end


function Ground:delete()
    self.super:delete( self ) -- selfを明示的に書いてあげる必要あり
end


return Ground
