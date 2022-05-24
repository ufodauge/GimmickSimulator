local Lume = require 'lib.lume'

local KeyManager = require 'class.keyboard.manager'
local Keyboard = require 'class.keyboard'
local DebuffListHUD = require( 'class.hud.debufflist' ):getInstance()

local PlayerManager = {}

local Public = {}
function Public:getInstance()
  if PlayerManager._singleton == nil then
    PlayerManager._singleton = PlayerManager:new()
  end

  assert( PlayerManager._singleton ~= nil, 'PlayerManager:getInstance() is not called yet.' )
  return PlayerManager._singleton
end

function PlayerManager:update( dt )
  self._keyManager:update( dt )
end

function PlayerManager:getPlayers()
  return unpack( self._players )
end

function PlayerManager:isChangable()
  return self._changable
end

function PlayerManager:updateObserver( event )
  if event.name == 'reset' then
    self._changable = true
    for i, player in ipairs( self._players ) do
      player:removeDebuffs()
    end
  elseif event.name == 'start' then
    self._changable = false
  end
end

function PlayerManager:add( player )
  Lume.push( self._players, player )
end

function PlayerManager:remove( player )
  Lume.remove( self._players, player )
end

function PlayerManager:delete()
  for i, player in pairs( self._players ) do
    if player.delete then
      player:delete()
      player = nil
    end
  end
  Lume.clear( self._players )
end

function PlayerManager:new()
  local obj = {}

  obj._players = {}
  obj._current = 1
  obj._started = false
  obj._changable = true

  local keyG = Keyboard:new( 'g', function( self, dt, f )
    if f == 0 and obj:isChangable() then
      obj._players[obj._current]:nonplayable()
      obj._current = #obj._players == obj._current and 1 or obj._current + 1
      obj._players[obj._current]:playable()
      DebuffListHUD:setTarget( obj._players[obj._current] )
    end
  end )
  obj._keyManager = KeyManager:new()
  obj._keyManager:add( keyG )

  return setmetatable( obj, {
    __index = PlayerManager,
    __tostring = function()
      return 'PlayerManager'
    end
  } )
end

return Public
