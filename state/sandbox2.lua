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
        gimmickManager:add( FieldObject:new( { image = WOTH_WARRIOR_IMAGE, x = -220, y = 220, drawPriority = 5, scale = 0.25 } ), 7.39 )
        gimmickManager:add( FieldObject:new( { image = WOTH_CASTER_IMAGE, x = 220, y = 220, drawPriority = 5, scale = 0.3 } ), 7.39 )
        gimmickManager:add( FieldObject:new( { image = WOTH_SOLIDER_IMAGE, x = 220, y = -220, drawPriority = 5, scale = 0.3 } ), 7.39 )
        gimmickManager:add( FieldObject:new( { image = WOTH_SOLIDER_IMAGE, x = -220, y = -220, drawPriority = 5, scale = 0.3 } ), 7.39 )
        gimmickManager:add( FieldObject:new( { image = WOTH_SOLIDER_IMAGE, x = 0, y = -300, drawPriority = 5, scale = 0.3 } ), 7.39 )
        gimmickManager:add( FieldObject:new( { image = WOTH_DRAGON_IMAGE, x = -800, y = 0, drawPriority = 5, scale = 0.3 } ), 7.39 )
        gimmickManager:add( FieldObject:new( { image = WOTH_DRAGON_IMAGE, x = 800, y = 0, drawPriority = 5, scale = 0.3 } ), 7.39 )
        gimmickManager:add( FieldObject:new( { image = WOTH_THORDAN_IMAGE, x = 0, y = 0, drawPriority = 5, scale = 0.3 } ), 7.39 )
    end, 0.1 ) )

    local nsew = lume.randomchoice( { -math.pi / 2, 0, math.pi / 2, math.pi } )
    local dragon1_x, dragon1_y = math.cos( nsew ) * 600, math.sin( nsew ) * 600
    local dragon2_x, dragon2_y = math.cos( nsew + math.pi / 2 ) * 600, math.sin( nsew + math.pi / 2 ) * 600
    local dragon3_x, dragon3_y = math.cos( nsew - math.pi / 2 ) * 600, math.sin( nsew - math.pi / 2 ) * 600
    local solider1_x, solider1_y = math.cos( nsew + math.pi / 6 ) * 600, math.sin( nsew + math.pi / 6 ) * 600
    local solider2_x, solider2_y = math.cos( nsew - math.pi / 6 ) * 600, math.sin( nsew - math.pi / 6 ) * 600

    -- 着地
    sequenceManager:add( Sequence:new( function()
        gimmickManager:add( FieldObject:new( { image = WOTH_DRAGON_IMAGE, x = dragon1_x, y = dragon1_y, drawPriority = 5, scale = 0.3 } ) )
        gimmickManager:add( FieldObject:new( { image = WOTH_SOLIDER_IMAGE, x = solider1_x, y = solider1_y, drawPriority = 5, scale = 0.3 } ) )
        gimmickManager:add( FieldObject:new( { image = WOTH_SOLIDER_IMAGE, x = solider2_x, y = solider2_y, drawPriority = 5, scale = 0.3 } ) )
    end, 9.0 ) )

    -- 線とマーカー
    sequenceManager:add( Sequence:new( function()
    end, 9.78 ) )

    -- ドラゴン着地
    sequenceManager:add( Sequence:new( function()
        gimmickManager:add( FieldObject:new( { image = WOTH_DRAGON_IMAGE, x = dragon2_x, y = dragon2_y, drawPriority = 5, scale = 0.3 } ) )
        gimmickManager:add( FieldObject:new( { image = WOTH_DRAGON_IMAGE, x = dragon3_x, y = dragon3_y, drawPriority = 5, scale = 0.3 } ) )
    end, 12.00 ) )

    -- 雷デバフ付与
    sequenceManager:add( Sequence:new( function()
    end, 14.36 ) )

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

