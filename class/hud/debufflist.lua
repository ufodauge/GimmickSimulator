-- libs
local Lume = require 'lib.lume'

-- Class
local GameInstance = require 'class.gameinstance'

local DebuffList = {}
setmetatable( DebuffList, { __index = GameInstance } )

local Public = {}
function Public:getInstance()
    if DebuffList._instance == nil then
        DebuffList._instance = DebuffList:new()
    end

    return DebuffList._instance
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

function DebuffList:update( dt )
    for i, v in ipairs( self._debuffs ) do
        if v == nil then
            self:remove( v )
        end
    end
end

function DebuffList:draw()
    for i, v in ipairs( self._debuffs ) do
        local w = v:getWidth()
        local x = self._x + w * (i - 1)
        local y = self._y
        v:draw( x, y, HUD_DEBUFF_ICON_WIDTH / w )
    end
end

function DebuffList:updateObserver( event )
    if event.name == 'reset' then
        self:removeDebuffs()
    end
end

function DebuffList:delete()
    self:_superDelete()
    self = nil
end

function DebuffList:add( debuff )
    Lume.push( self._debuffs, debuff )
end

function DebuffList:remove( debuff )
    Lume.remove( self._debuffs, debuff )
end

function DebuffList:removeDebuffs()
    Lume.clear( self._debuffs )
end

function DebuffList:new( args )
    args = args or {}
    local obj = GameInstance:new( args )
    obj._superDelete = obj.delete

    obj._isHud = true
    obj._x = args.x or HUD_DEBUFF_LIST_IMAGE_X
    obj._y = args.y or HUD_DEBUFF_LIST_IMAGE_Y

    obj._debuffs = {}

    return setmetatable( obj, {
        __index = DebuffList,
        __tostring = function()
            return 'DebuffList'
        end
    } )
end

return Public
