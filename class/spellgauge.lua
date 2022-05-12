local SpellGauge = Class( 'SpellGauge' )

-- local functions
-- 影付きでテキスト出力
local function print_with_shadow( text, x, y )
    love.graphics.setColor( 0.2, 0.2, 0.2, 1 )
    love.graphics.print( text, x + 1, y + 1 )
    love.graphics.print( text, x - 1, y + 1 )
    love.graphics.print( text, x + 1, y - 1 )
    love.graphics.print( text, x - 1, y - 1 )
    love.graphics.setColor( 1, 1, 1, 1 )
    love.graphics.print( text, x, y )
end


function SpellGauge:init()
    self.spelling = false
    self.spellTime = 0
    self.spellMaxTime = 0.5
    self.spellName = ''

    self.spellRate = 0

    self.x, self.y = 150, 80
end


function SpellGauge:update( dt )
    if self.spelling then
        self.spellTime = self.spellTime + dt
        self.spellRate = self.spellTime / self.spellMaxTime

        if self.spellTime > self.spellMaxTime then
            self.spelling = false
            self.spellTime = 0
            self.spellName = ''

            -- 詠唱発動
            self:spell()

            -- 詠唱終了
            self.spelling = false
            self.spellTime = 0
            self.spellName = ''
        end
    end
end


function SpellGauge:draw()
    if self.spelling then
        love.graphics.setColor( 1, 1, 1, 1 )
        love.graphics.draw( HUD_SPELLGAUGE_BASE_IMAGE, self.x, self.y )
        love.graphics.draw( HUD_SPELLGAUGE_SPELL_IMAGE, HUD_SPELLGAUGE_SPELL_IMAGE_LEFT, self.x + HUD_SPELLGAUGE_SPELL_IMAGE_LEFT_X,
                            self.y + HUD_SPELLGAUGE_SPELL_IMAGE_LEFT_Y )
        love.graphics.draw( HUD_SPELLGAUGE_SPELL_IMAGE, HUD_SPELLGAUGE_SPELL_IMAGE_MIDDLE, self.x + HUD_SPELLGAUGE_SPELL_IMAGE_LEFT_X + 1,
                            self.y + HUD_SPELLGAUGE_SPELL_IMAGE_LEFT_Y, 0, self.spellRate * HUD_SPELLGAUGE_SPELL_IMAGE_MIDDLE_MAX_WIDTH, 1 )
        love.graphics.draw( HUD_SPELLGAUGE_SPELL_IMAGE, HUD_SPELLGAUGE_SPELL_IMAGE_RIGHT,
                            self.x + HUD_SPELLGAUGE_SPELL_IMAGE_LEFT_X + 1 + self.spellRate * HUD_SPELLGAUGE_SPELL_IMAGE_MIDDLE_MAX_WIDTH,
                            self.y + HUD_SPELLGAUGE_SPELL_IMAGE_LEFT_Y )

        love.graphics.setColor( 1, 1, 1, 1 )
        love.graphics.setFont( FONT_HUD )
        print_with_shadow( self.spellName, self.x, self.y )
    end
end


function SpellGauge:spell()
    -- 詠唱発動
    self.effect()
end


function SpellGauge:startSpell( name, effect, spellmaxtime )
    self.spelling = true
    self.spellName = name
    self.spellMaxTime = spellmaxtime

    -- 詠唱エフェクト
    self.effect = effect
end


function SpellGauge:delete()

end


return SpellGauge
