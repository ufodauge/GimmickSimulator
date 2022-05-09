local sandbox = {}

sandbox.name = 'sandbox'
local player = nil
local ground = nil
local gimmickManager = nil
local aoes = {}
local fieldMarkers = {}
local huds = {}

function sandbox:init()

end


function sandbox:enter()
    -- objects
    player = Player()
    ground = Ground()
    aoes.testCircle = AOE( 'circle', 3, 5, { x = 0, y = 0, rad = 100, hole = 50 } )
    aoes.testRectangle = AOE( 'rectangle', 8, 10, { x = 0, y = 0, w = 100, h = 100 } )
    fieldMarkers.A = FieldMarker( { image = FIELD_MARKER_A_IMAGE, x = 0, y = 567 } )
    fieldMarkers.B = FieldMarker( { image = FIELD_MARKER_B_IMAGE, x = 567, y = 0 } )
    fieldMarkers.C = FieldMarker( { image = FIELD_MARKER_C_IMAGE, x = 0, y = -567 } )
    fieldMarkers.D = FieldMarker( { image = FIELD_MARKER_D_IMAGE, x = -567, y = 0 } )
    fieldMarkers.num1 = FieldMarker( { image = FIELD_MARKER_1_IMAGE, x = 401, y = 401 } )
    fieldMarkers.num2 = FieldMarker( { image = FIELD_MARKER_2_IMAGE, x = 401, y = -401 } )
    fieldMarkers.num3 = FieldMarker( { image = FIELD_MARKER_3_IMAGE, x = -401, y = -401 } )
    fieldMarkers.num4 = FieldMarker( { image = FIELD_MARKER_4_IMAGE, x = -401, y = 401 } )

    huds.debuffList = DebuffList()
    huds.spellGauge = SpellGauge()
    huds.battletalkwindow = BattleTalkWindow()

    player:setImage( NIDHOGG_PLAYER_IMAGE )
    ground:setImage( NIDHOGG_GROUND_IMAGE )

    player:setScale( 0.5 )
    player:setPriority( 10 )
    for k, aoe in pairs( aoes ) do
        aoe:setPriority( 5 )
    end
    for k, fieldMarker in pairs( fieldMarkers ) do
        fieldMarker:setPriority( 6 )
    end

    gimmickManager = GimmickManager()
    gimmickManager:setPlayer( player )
    gimmickManager:add( aoes.testCircle )
    gimmickManager:add( aoes.testRectangle )

    -- test
    local test = function()
        print( 'test' )
    end


    local debuff = Debuff( 'test', NIDHOGG_DEBUFF_RAND2_IMAGE, test, 3, 'onEnd', NIDHOGG_MARKER_RAND2_IMAGE )
    player:addDebuff( debuff )
    huds.debuffList:add( debuff )
    -- huds.spellGauge:startSpell( 'test', test, 10 )
    -- huds.battletalkwindow:setSeriph( 'test' )
    -- huds.battletalkwindow:display()
end


function sandbox:update( dt )
    gimmickManager:update( dt )
    huds.debuffList:update( dt )
    huds.spellGauge:update( dt )
    huds.battletalkwindow:update( dt )
end


function sandbox:draw()
    huds.debuffList:draw()
    huds.spellGauge:draw()
    huds.battletalkwindow:draw()
end


function sandbox:leave()
    player:delete()
    ground:delete()

    for k, aoe in pairs( aoes ) do
        aoe:delete()
    end

    gimmickManager:delete()
    huds.debuffList:delete()
    huds.spellGauge:delete()
    huds.battletalkwindow:delete()

end


return sandbox
