local DummyClass = GameInstance:extend( 'DummyClass' )

function DummyClass:init()
    DummyClass.super:init( self )
end


function DummyClass:update( dt )
end


function DummyClass:draw()
    love.graphics.setColor( 1, 1, 1, 1 )
end


function DummyClass:delete()
    self.super.delete( self ) -- selfを明示的に書いてあげる必要あり
end


return DummyClass
