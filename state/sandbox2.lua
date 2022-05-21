local Field = require 'class.field'
local FieldObject = require 'class.gimmick.fieldobject'
local PlayerManager = require 'class.player.manager'
local Player = require 'class.player'
local SequenceManager = require 'class.sequence.manager'
local Sequence = require 'class.sequence'
local CircleAoE = require 'class.gimmick.aoe.circle'
local RectangleAoE = require 'class.gimmick.aoe.rectangle'
local SpellGaugeHUD = require( 'class.hud.spellgauge' ):getInstance()
local GimmickManager = require 'class.gimmick.manager'
local GIManager = require( 'class.gameinstance.manager' ):getInstance()

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
    -- playerManager:add( Player:new( { image = PLAYER_IMAGE_ST, drawPriority = 10, x = -250, y = 0 } ) )
    -- playerManager:add( Player:new( { image = PLAYER_IMAGE_H1, drawPriority = 10, x = -150, y = 0 } ) )
    -- playerManager:add( Player:new( { image = PLAYER_IMAGE_H2, drawPriority = 10, x = -50, y = 0 } ) )
    -- playerManager:add( Player:new( { image = PLAYER_IMAGE_D1, drawPriority = 10, x = 50, y = 0 } ) )
    -- playerManager:add( Player:new( { image = PLAYER_IMAGE_D2, drawPriority = 10, x = 150, y = 0 } ) )
    -- playerManager:add( Player:new( { image = PLAYER_IMAGE_D3, drawPriority = 10, x = 250, y = 0 } ) )
    -- playerManager:add( Player:new( { image = PLAYER_IMAGE_D4, drawPriority = 10, x = 350, y = 0 } ) )

    gimmickManager = GimmickManager:new()
    sequenceManager = SequenceManager:new()

    sequenceManager:addObserver( gimmickManager )

    -- sequenceManager:add( Sequence:new( function()
    --     gimmickManager:add( CircleAoE:new( { prediction = 1, x = 200, y = 350, r = 200, ir = 80 } ) )
    -- end, 1 ) )
    -- 至天の陣：風槍
    sequenceManager:add( Sequence:new( function()
        SpellGaugeHUD:spell( { time = 3.67, mes = '至天の陣：風槍' } )
        gimmickManager:add( FieldObject:new( { image = WOTH_WARRIOR_IMAGE, x = -300, y = 300, drawPriority = 5, scale = 0.3 } ), 7.39 )
        gimmickManager:add( FieldObject:new( { image = WOTH_SOLIDER_IMAGE, x = 300, y = 300, drawPriority = 5, scale = 0.3 } ), 7.39 )
        gimmickManager:add( FieldObject:new( { image = WOTH_SOLIDER_IMAGE, x = 300, y = -300, drawPriority = 5, scale = 0.3 } ), 7.39 )
        gimmickManager:add( FieldObject:new( { image = WOTH_SOLIDER_IMAGE, x = -300, y = -300, drawPriority = 5, scale = 0.3 } ), 7.39 )
        gimmickManager:add( FieldObject:new( { image = WOTH_DRAGON_IMAGE, x = -800, y = 0, drawPriority = 5, scale = 0.3 } ), 7.39 )
        gimmickManager:add( FieldObject:new( { image = WOTH_DRAGON_IMAGE, x = 800, y = 0, drawPriority = 5, scale = 0.3 } ), 7.39 )
        gimmickManager:add( FieldObject:new( { image = WOTH_THORDAN_IMAGE, x = 0, y = 0, drawPriority = 5, scale = 0.3 } ), 7.39 )
    end, 0.1 ) )

    GIManager:add( field )
    GIManager:add( playerManager:getPlayers() )
    GIManager:add( sequenceManager:getSequences() )

end

function sandbox:update( dt )
    sequenceManager:update( dt )
    gimmickManager:update( dt )
    SpellGaugeHUD:update( dt )
end

function sandbox:draw()
    SpellGaugeHUD:draw()
end

function sandbox:leave()
    GIManager:deleteInstanceAll()
end

return sandbox

