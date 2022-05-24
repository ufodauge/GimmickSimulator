-- libs
local Lume = require 'lib.lume'

local DebuffList = {}

local Public = {}
function Public:getInstance()
  if DebuffList._instance == nil then
    DebuffList._instance = DebuffList:new()
  end

  return DebuffList._instance
end

local function printWithBorder( text, x, y, lim, align, color )
  lim, align = lim or 400, align or 'right'
  -- F79A00
  local r, g, b = color.r or (0xF7 / 255), color.g or (0x9A / 255), color.b or (0x00 / 255)
  love.graphics.setColor( r, g, b, 1 )
  love.graphics.setFont( FONT_HUD )
  love.graphics.printf( text, x + 1, y + 1, lim, align )
  love.graphics.printf( text, x - 1, y + 1, lim, align )
  love.graphics.printf( text, x + 1, y - 1, lim, align )
  love.graphics.printf( text, x - 1, y - 1, lim, align )
  love.graphics.setColor( 1, 1, 1, 1 )
  love.graphics.printf( text, x, y, lim, align )
end

function DebuffList:update( dt )
end

function DebuffList:draw( _x, _y, _scale, _target )
  _x, _y, _scale = _x or 0, _y or 0, _scale or 1
  _target = _target or self._target

  for i, debuff in ipairs( { _target:getDebuffs() } ) do
    local w = debuff:getWidth()
    local scale = _scale * HUD_DEBUFF_LIST_ICON_WIDTH / w
    local x = _x + HUD_DEBUFF_LIST_ICON_WIDTH * (i - 1)
    local y = _y
    debuff:draw( x, y, scale )

    local remaintime = debuff:getRemainTime()
    printWithBorder( ('%d'):format( remaintime + 1 ), x, y + scale * debuff:getHeight(), HUD_DEBUFF_LIST_ICON_WIDTH, 'center', { r = 0x00, g = 0x00, b = 0x00 } )
  end
end

function DebuffList:delete()
  self = nil
end

function DebuffList:setTarget( target )
  self._target = target
end

function DebuffList:new( args )
  args = args or {}
  local obj = {}

  obj._target = nil

  -- obj._debuffs = {}

  return setmetatable( obj, {
    __index = DebuffList,
    __tostring = function()
      return 'DebuffList'
    end
  } )
end

return Public
