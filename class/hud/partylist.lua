-- libs
local Lume = require 'lib.lume'

-- Class
local DebuffListHUD = require( 'class.hud.debufflist' ):getInstance() -- キャンバスをコピーする

local PartyList = {}

local Public = {}
function Public:getInstance()
  if PartyList._instance == nil then
    PartyList._instance = PartyList:new()
  end

  return PartyList._instance
end

function PartyList:update( dt )
end

function PartyList:draw( _x, _y, _scale )
  -- パーティリスト左上の座標
  _x, _y = _x or 0, _y or 0
  _scale = _scale or 1

  self._canvas:renderTo( function()
    love.graphics.clear()
    love.graphics.setBlendMode( 'alpha' )
    love.graphics.setColor( 1, 1, 1, 1 )
    for i, player in ipairs( self._players ) do
      love.graphics.draw( HUD_PARTY_LIST_BG_IMAGE, 0, (i - 1) * HUD_PARTY_LIST_BG_HEIGHT )
      love.graphics.draw( HUD_PARTY_LIST_HP_GAUGE_IMAGE, HUD_PARTY_LIST_HP_GAUGE_REL_X, (i - 1) * HUD_PARTY_LIST_BG_HEIGHT + HUD_PARTY_LIST_HP_GAUGE_REL_Y )
      love.graphics.draw( player:getIcon(), HUD_PARTY_LIST_ICON_REL_X, (i - 1) * HUD_PARTY_LIST_BG_HEIGHT + HUD_PARTY_LIST_ICON_REL_Y )
      DebuffListHUD:draw( HUD_PARTY_LIST_DEBUFF_REL_X, (i - 1) * HUD_PARTY_LIST_BG_HEIGHT, 0.8, player )
    end
  end )
  love.graphics.setBlendMode( 'alpha', 'premultiplied' )
  love.graphics.setColor( 1, 1, 1, 1 )
  love.graphics.draw( self._canvas, _x, _y, 0, _scale, _scale )
  love.graphics.setBlendMode( 'alpha' )
end

function PartyList:delete()
  Lume.clear( self )
  self = nil
end

function PartyList:add( ... )
  Lume.push( self._players, ... )
end

function PartyList:remove( ... )
  local args = { ... }
  for i, player in ipairs( args ) do
    Lume.remove( self._players, player )
  end
end

function PartyList:removeDebuffs()
  Lume.clear( self._players )
end

function PartyList:new( args )
  args = args or {}
  local obj = {}

  obj._players = {}
  obj._canvas = love.graphics.newCanvas( HUD_PARTY_LIST_WIDTH, HUD_PARTY_LIST_HEIGHT )

  return setmetatable( obj, {
    __index = PartyList,
    __tostring = function()
      return 'PartyList'
    end
  } )
end

return Public
