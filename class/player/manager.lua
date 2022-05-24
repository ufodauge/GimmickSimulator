local KeyManager = require 'class.keyboard.manager'
local Keyboard = require 'class.keyboard'

local PlayerManager = {}

function PlayerManager:update( dt )
    self._keyManager:update( dt )
end

function PlayerManager:getPlayers()
    return unpack( self._players )
end

function PlayerManager:add( player )
    table.insert( self._players, player )
end

function PlayerManager:remove( player )
    for i, g in pairs( self._players ) do
        if g == player then
            table.remove( self._players, i )
        end
    end
end

function PlayerManager:delete()
    for i, player in pairs( self._players ) do
        if player.delete then
            player:delete()
            player = nil
        end
    end
    self._players = {}
end

function PlayerManager:new()
    local obj = {}

    obj._players = {}
    obj._started = false
    obj._current = 1

    local keyG = Keyboard:new( 'g', function( self, dt, f )
        if f == 0 then
            obj._players[obj._current]:nonplayable()
            obj._players[obj._current + 1]:playable()
            obj._current = #obj._players == obj._current and 1 or obj._current + 1
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

return PlayerManager
