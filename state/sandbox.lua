local Field = require 'class.field'
local FieldObject = require 'class.gimmick.fieldobject'
local PlayerManager = require 'class.player.manager'
local Player = require 'class.player'
local SequenceManager = require 'class.sequence.manager'
local Sequence = require 'class.sequence'
local CircleAoE = require 'class.gimmick.aoe.circle'
local RectangleAoE = require 'class.gimmick.aoe.rectangle'
local Marker = require 'class.gimmick.marker'
local LineMarker = require 'class.gimmick.linemarker'
local Debuff = require 'class.gimmick.debuff'
local SpellGaugeHUD = require( 'class.hud.spellgauge' ):getInstance()
local DebuffListHUD = require( 'class.hud.debufflist' ):getInstance()
local GimmickManager = require 'class.gimmick.manager'
local GIManager = require( 'class.gameinstance.manager' ):getInstance()
local lume = require( 'lib.lume' )

local sandbox = {}

sandbox.name = 'sandbox2'

local field = nil
local playerManager = nil
local sequenceManager = nil
local gimmickManager = nil

function sandbox:enter()
    field = Field:new( { image = WOTH_GROUND_IMAGE, x = 0, y = 0 } )

    playerManager = PlayerManager:new()
    playerManager:add( Player:new( { image = PLAYER_IMAGE_MT, drawPriority = 10, x = -350, y = 0, playable = true } ) )

    gimmickManager = GimmickManager:new()
    sequenceManager = SequenceManager:new()

    sequenceManager:addObserver( gimmickManager )

    sequenceManager:add( Sequence:new( function()
        gimmickManager:add( LineMarker:new( {
            image = WOTH_CHAIN_IMAGE,
            sx = 0,
            sy = 0,
            target = playerManager:getPlayers(),
            triggertiming = 10,
            func = function()
                local tx, ty = playerManager:getPlayers():getPosition()
                gimmickManager:add( RectangleAoE:new( { sx = 0, sy = 0, tx = tx, ty = ty, w = 200, prediction = 0.41 } ), 5 )
            end,
            drawPriority = 15
        } ) )
    end, 0.1 ) )

    GIManager:add( field )
    GIManager:add( playerManager:getPlayers() )
    GIManager:add( sequenceManager:getSequences() )

end

function sandbox:update( dt )
    playerManager:update( dt )
    sequenceManager:update( dt )
    gimmickManager:update( dt )
    SpellGaugeHUD:update( dt )
    DebuffListHUD:update( dt )
end

function sandbox:draw()
    SpellGaugeHUD:draw()
    DebuffListHUD:draw()
end

function sandbox:leave()
    GIManager:deleteInstanceAll()
end

return sandbox

