-- libs
local Lume = require 'lib.lume'

-- Class
local GameInstance = require 'class.gameinstance'

local SpellGauge = {}
setmetatable( SpellGauge, { __index = GameInstance } )

local Public = {}
function Public:getInstance()
    if SpellGauge._instance == nil then
        SpellGauge._instance = SpellGauge:new()
    end

    return SpellGauge._instance
end

local function _printWithBorder( text, x, y, lim, align )
    lim, align = lim or 400, align or 'right'
    -- F79A00
    local r, g, b = 0xF7 / 255, 0x9A / 255, 0x00 / 255
    love.graphics.setColor( r, g, b, 1 )
    love.graphics.printf( text, x + 1, y + 1, 400, 'right' )
    love.graphics.printf( text, x - 1, y + 1, 400, 'right' )
    love.graphics.printf( text, x + 1, y - 1, 400, 'right' )
    love.graphics.printf( text, x - 1, y - 1, 400, 'right' )
    love.graphics.setColor( 1, 1, 1, 1 )
    love.graphics.printf( text, x, y, 400, 'right' )
end

function SpellGauge:update( dt )
    if self._started then
        self._timer = self._timer + dt
    end

    if self._timer >= self._limit then
        self._timer = 0
        self._started = false
    end
end

function SpellGauge:draw()
    if self._started then
        love.graphics.setColor( 1, 1, 1, 1 )
        love.graphics.draw( HUD_SPELLGAUGE_BASE_IMAGE, HUD_SPELLGAUGE_BASE_IMAGE_X, HUD_SPELLGAUGE_BASE_IMAGE_Y )
        love.graphics.draw( HUD_SPELLGAUGE_SPELL_IMAGE, HUD_SPELLGAUGE_BASE_IMAGE_X + HUD_SPELLGAUGE_SPELL_IMAGE_RELATED_TO_BASE_X,
                            HUD_SPELLGAUGE_BASE_IMAGE_Y + HUD_SPELLGAUGE_SPELL_IMAGE_RELATED_TO_BASE_Y, 0, self._timer / self._limit, 1 )

        love.graphics.setFont( FONT_HUD )

        _printWithBorder( self._mes, HUD_SPELLGAUGE_BASE_IMAGE_X, HUD_SPELLGAUGE_BASE_IMAGE_Y + 20 )
    end
end

function SpellGauge:delete()
    self:_superDelete()
    self = nil
end

function SpellGauge:spell( args )
    self._mes = args.mes
    self._limit = args.time
    self._timer = 0
    self._started = true
end

function SpellGauge:new( args )
    args = args or {}
    local obj = GameInstance:new( args )
    obj._superDelete = obj.delete

    setmetatable( obj, { __index = SpellGauge } )
    obj._isHud = true

    obj._limit = args.time or 100
    obj._mes = args.mes or 'Spell Gauge'

    obj._timer = 0
    obj._started = false

    return obj
end

return Public
