local Field = require 'class.field'
local PlayerManager = require 'class.player.manager'
local Player = require 'class.player'
local SequenceManager = require 'class.sequence.manager'
local Sequence = require 'class.sequence'
local CircleAoE = require 'class.gimmick.aoe.circle'
local GIManager = require( 'class.gameinstance.manager' ):getInstance()

local sandbox = {}

sandbox.name = 'sandbox2'

local field = nil
local playerManager = nil
local sequenceManager = nil
local gimmickManager = nil

function sandbox:enter()
    field = Field:new( { image = GROUND_IMAGE, x = 0, y = 0 } )

    playerManager = PlayerManager:new()
    playerManager:add( Player:new( { image = PLAYER_IMAGE_MT, drawPriority = 10, x = -350, y = 0, playable = true } ) )
    playerManager:add( Player:new( { image = PLAYER_IMAGE_ST, drawPriority = 10, x = -250, y = 0 } ) )
    playerManager:add( Player:new( { image = PLAYER_IMAGE_H1, drawPriority = 10, x = -150, y = 0 } ) )
    playerManager:add( Player:new( { image = PLAYER_IMAGE_H2, drawPriority = 10, x = -50, y = 0 } ) )
    playerManager:add( Player:new( { image = PLAYER_IMAGE_D1, drawPriority = 10, x = 50, y = 0 } ) )
    playerManager:add( Player:new( { image = PLAYER_IMAGE_D2, drawPriority = 10, x = 150, y = 0 } ) )
    playerManager:add( Player:new( { image = PLAYER_IMAGE_D3, drawPriority = 10, x = 250, y = 0 } ) )
    playerManager:add( Player:new( { image = PLAYER_IMAGE_D4, drawPriority = 10, x = 350, y = 0 } ) )

    gimmickManager = GimmickManager:new()

    sequenceManager = SequenceManager:new()
    sequenceManager:add( Sequence:new( function()
        gimmickManager:add( CircleAoE:new( { prediction = 2, x = 100, y = 50, r = 40, ir = 20 } ) )
    end, 1 ) )
    sequenceManager:add( Sequence:new( function()
        gimmickManager:add( RectangleAoE:new( { prediction = 1, sx = 100, sy = 50, tx = -100, ty = -50, w = 40 } ) )
    end, 4 ) )

    GIManager:add( field )
    GIManager:add( playerManager:getPlayers() )
    GIManager:add( sequenceManager:getSequences() )

end

function sandbox:update( dt )
    sequenceManager:update( dt )
end

function sandbox:draw()

end

function sandbox:leave()
    GIManager:deleteInstanceAll()
end

return sandbox

