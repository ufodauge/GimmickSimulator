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
  _x, _y = _x or 0, _y or 0
  _scale = _scale or 1

  for i, player in ipairs( self._players ) do
    -- 本来はここにパーティリスト
    DebuffListHUD:draw( _x + 80, _y + 80 * (i - 1), _scale, player )
  end
end

function PartyList:delete()
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

  return setmetatable( obj, {
    __index = PartyList,
    __tostring = function()
      return 'PartyList'
    end
  } )
end

return Public
