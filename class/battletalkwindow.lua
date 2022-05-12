local BattleTalkWindow = Class( 'BattleTalkWindow' )

-- local functions
-- 影付きでテキスト出力
local function print_with_shadow( text, x, y, width )
    love.graphics.setColor( 0.2, 0.2, 0.2, 1 )
    love.graphics.printf( text, x + 1, y + 1, width, 'center' )
    love.graphics.printf( text, x - 1, y + 1, width, 'center' )
    love.graphics.printf( text, x + 1, y - 1, width, 'center' )
    love.graphics.printf( text, x - 1, y - 1, width, 'center' )
    love.graphics.setColor( 1, 1, 1, 1 )
    love.graphics.printf( text, x, y, width, 'center' )
end


function BattleTalkWindow:init()
    self.x, self.y = 440, 120
    self.width = 400
    self.seriph = ''

    self.displaying = false

    self.displaytimer = 0
    self.displaytimerMax = 4
end


function BattleTalkWindow:update( dt )

    if not self.displaying then
        return
    end

    self.displaytimer = self.displaytimer + dt

    if self.displaytimerMax < self.displaytimer then
        self.displaytimer = 0
        self.displaying = false
        self.seriph = ''
    end
end


function BattleTalkWindow:setSeriph( seriph )
    self.seriph = seriph
end


function BattleTalkWindow:display()
    self.displaying = true
end


function BattleTalkWindow:draw()
    if not self.displaying then
        return
    end

    love.graphics.setColor( 1, 1, 1, 1 )
    love.graphics.setFont( FONT_HUD )
    print_with_shadow( self.seriph, self.x, self.y, self.width )
end


function BattleTalkWindow:delete()

end


return BattleTalkWindow
