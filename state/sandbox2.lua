local Player = require 'class.player'
local Field = require 'class.field'
local GIManager = require( 'class.gameinstance.manager' ):getInstance()

local sandbox = {}

sandbox.name = 'sandbox2'

local player = {}
local field = nil

function sandbox:enter()
    player[1] = Player:new( { image = PLAYER_IMAGE_MT, drawPriority = 10, x = -175, y = 0, playable = true } )
    player[2] = Player:new( { image = PLAYER_IMAGE_ST, drawPriority = 10, x = -125, y = 0 } )
    player[3] = Player:new( { image = PLAYER_IMAGE_H1, drawPriority = 10, x = -75, y = 0 } )
    player[4] = Player:new( { image = PLAYER_IMAGE_H2, drawPriority = 10, x = -25, y = 0 } )
    player[5] = Player:new( { image = PLAYER_IMAGE_D1, drawPriority = 10, x = 25, y = 0 } )
    player[6] = Player:new( { image = PLAYER_IMAGE_D2, drawPriority = 10, x = 75, y = 0 } )
    player[7] = Player:new( { image = PLAYER_IMAGE_D3, drawPriority = 10, x = 125, y = 0 } )
    player[8] = Player:new( { image = PLAYER_IMAGE_D4, drawPriority = 10, x = 175, y = 0 } )

    player[1]:next( player[2] )
    player[2]:next( player[3] )
    player[3]:next( player[4] )
    player[4]:next( player[5] )
    player[5]:next( player[6] )
    player[6]:next( player[7] )
    player[7]:next( player[8] )
    player[8]:next( player[1] )

    field = Field:new( { image = GROUND_IMAGE, x = 0, y = 0 } )

    GIManager:add( player[1], player[2], player[3], player[4], player[5], player[6], player[7], player[8], field )

end

function sandbox:update( dt )
end

function sandbox:draw()

end

function sandbox:leave()
    GIManager:deleteInstanceAll()
end

return sandbox
