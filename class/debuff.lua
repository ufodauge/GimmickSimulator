local Debuff = Class( 'Debuff' )

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


-- name: デバフの名前
-- duration: デバフの持続時間
-- effect: デバフの処理
-- type: デバフの種類( 'onEnd' or 'onUpdate' )
-- marker: デバフによるマーカー ( image )
function Debuff:init( name, icon, effect, duration, type, marker, markerduration )
    self.name = name
    self.image = icon
    self.effect = effect
    self.duration = duration
    self.type = type or 'onEnd'
    self.marker = marker
    self.markerduration = markerduration or 5
end


function Debuff:update( dt )
    self.duration = self.duration - dt
    self.markerduration = self.markerduration - dt
    if self.duration < 0 then
        if self.type == 'onEnd' then
            self:effect()
        end

        self:delete()
    end
end


function Debuff:draw( x, y, scale )
    love.graphics.draw( self.image, x, y, 0, scale, scale )

    -- デバフの持続時間を表示
    love.graphics.setColor( 1, 1, 1, 1 )
    love.graphics.setFont( FONT_HUD )
    print_with_shadow( math.ceil( self.duration ), x, y + HUD_DEBUFF_ICON_SIZE + 20, HUD_DEBUFF_ICON_SIZE )
end


function Debuff:getMarker()
    return self.marker
end


function Debuff:getName()
    return self.name
end


function Debuff:isMarkerDisplaying()
    return self.markerduration > 0
end


function Debuff:__tostring()
    return self.name
end


function Debuff:delete()
    self.deleted = true

    setmetatable( self, { __mode = 'k' } )
end


return Debuff
