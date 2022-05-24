local Field = require 'class.field'
local FieldObject = require 'class.gimmick.fieldobject'
local PlayerManager = require( 'class.player.manager' ):getInstance()
local Player = require 'class.player'
local SequenceManager = require 'class.sequence.manager'
local Sequence = require 'class.sequence'
local CircleAoE = require 'class.gimmick.aoe.circle'
local RectangleAoE = require 'class.gimmick.aoe.rectangle'
local ArcAoE = require 'class.gimmick.aoe.arc'
local Marker = require 'class.gimmick.marker'
local LineMarker = require 'class.gimmick.linemarker'
local Debuff = require 'class.gimmick.debuff'
local SpellGaugeHUD = require( 'class.hud.spellgauge' ):getInstance()
local DebuffListHUD = require( 'class.hud.debufflist' ):getInstance()
local PartyListHUD = require( 'class.hud.partylist' ):getInstance()
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
  playerManager:add( Player:new( { image = PLAYER_IMAGE_MT, icon = PLAYER_IMAGE_ICON_MT, drawPriority = 10, x = -350, y = 0, playable = true } ) )
  playerManager:add( Player:new( { image = PLAYER_IMAGE_ST, icon = PLAYER_IMAGE_ICON_ST, drawPriority = 10, x = -250, y = 0 } ) )
  playerManager:add( Player:new( { image = PLAYER_IMAGE_H1, icon = PLAYER_IMAGE_ICON_H1, drawPriority = 10, x = -150, y = 0 } ) )
  playerManager:add( Player:new( { image = PLAYER_IMAGE_H2, icon = PLAYER_IMAGE_ICON_H2, drawPriority = 10, x = -50, y = 0 } ) )
  playerManager:add( Player:new( { image = PLAYER_IMAGE_D1, icon = PLAYER_IMAGE_ICON_D1, drawPriority = 10, x = 50, y = 0 } ) )
  playerManager:add( Player:new( { image = PLAYER_IMAGE_D2, icon = PLAYER_IMAGE_ICON_D2, drawPriority = 10, x = 150, y = 0 } ) )
  playerManager:add( Player:new( { image = PLAYER_IMAGE_D3, icon = PLAYER_IMAGE_ICON_D3, drawPriority = 10, x = 250, y = 0 } ) )
  playerManager:add( Player:new( { image = PLAYER_IMAGE_D4, icon = PLAYER_IMAGE_ICON_D4, drawPriority = 10, x = 350, y = 0 } ) )

  gimmickManager = GimmickManager:new()
  sequenceManager = SequenceManager:new()

  sequenceManager:addObserver( gimmickManager )
  sequenceManager:addObserver( playerManager )
  sequenceManager:addObserver( SpellGaugeHUD )
  -- sequenceManager:addObserver( DebuffListHUD )

  DebuffListHUD:setTarget( playerManager:getPlayers() )
  PartyListHUD:add( playerManager:getPlayers() )

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

  local nsew = nil
  local dragon1_x, dragon1_y = nil, nil
  local dragon2_x, dragon2_y = nil, nil
  local dragon3_x, dragon3_y = nil, nil
  local solider1_x, solider1_y = nil, nil
  local solider2_x, solider2_y = nil, nil
  local caster_x, caster_y = nil, nil
  local warrior_x, warrior_y = nil, nil

  -- 着地
  sequenceManager:add( Sequence:new( function()
    nsew = lume.randomchoice( { -math.pi / 2, 0, math.pi / 2, math.pi } )
    dragon1_x, dragon1_y = math.cos( nsew ) * 600, math.sin( nsew ) * 600
    dragon2_x, dragon2_y = math.cos( nsew + math.pi / 2 ) * 600, math.sin( nsew + math.pi / 2 ) * 600
    dragon3_x, dragon3_y = math.cos( nsew - math.pi / 2 ) * 600, math.sin( nsew - math.pi / 2 ) * 600
    solider1_x, solider1_y = math.cos( nsew + math.pi / 6 ) * 600, math.sin( nsew + math.pi / 6 ) * 600
    solider2_x, solider2_y = math.cos( nsew - math.pi / 6 ) * 600, math.sin( nsew - math.pi / 6 ) * 600
    local addorstay = lume.randomchoice( { 0, math.pi } )
    caster_x, caster_y = math.cos( nsew + addorstay ) * 350, math.sin( nsew + addorstay ) * 350
    warrior_x, warrior_y = math.cos( nsew + addorstay + math.pi ) * 350, math.sin( nsew + addorstay + math.pi ) * 350

    gimmickManager:add( FieldObject:new( { image = WOTH_DRAGON_IMAGE, x = dragon1_x, y = dragon1_y, drawPriority = 5, scale = 0.3 } ) )
    gimmickManager:add( FieldObject:new( { image = WOTH_SOLIDER_IMAGE, x = solider1_x, y = solider1_y, drawPriority = 5, scale = 0.3 } ) )
    gimmickManager:add( FieldObject:new( { image = WOTH_SOLIDER_IMAGE, x = solider2_x, y = solider2_y, drawPriority = 5, scale = 0.3 } ) )
  end, 9.0 ) )

  -- 誰に何を付与するかを決める
  local debuff1 = nil
  local debuff2 = nil

  -- 線とマーカー
  sequenceManager:add( Sequence:new( function()
    SpellGaugeHUD:spell( { time = 15.55 - 9.83, mes = 'ツイスターダイブ' } )

    debuff1 = lume.shuffle( { 'chain1', 'chain2', 'blue', 'green', 'largeaoe', 'smallaoe', 'none', 'none' } )
    debuff2 = lume.shuffle( { 'thunder', 'thunder', 'none', 'none', 'none', 'none', 'none', 'none' } )

    for i, deb in ipairs( debuff1 ) do
      if deb == 'chain1' then
        gimmickManager:add( LineMarker:new( {
          image = WOTH_CHAIN_IMAGE,
          sx = solider1_x,
          sy = solider1_y,
          target = select( i, playerManager:getPlayers() ),
          triggertiming = 15.55 - 9.83,
          func = function()
            local tx, ty = select( i, playerManager:getPlayers() ):getPosition()
            gimmickManager:add( RectangleAoE:new( { sx = solider1_x, sy = solider1_y, tx = tx, ty = ty, w = 300, drawPriority = 5, prediction = 0.41 } ), 5 )
          end,
          drawPriority = 15
        } ) )
      elseif deb == 'chain2' then
        gimmickManager:add( LineMarker:new( {
          image = WOTH_CHAIN_IMAGE,
          sx = solider2_x,
          sy = solider2_y,
          target = select( i, playerManager:getPlayers() ),
          triggertiming = 15.55 - 9.83,
          func = function()
            local tx, ty = select( i, playerManager:getPlayers() ):getPosition()
            gimmickManager:add( RectangleAoE:new( { sx = solider2_x, sy = solider2_y, tx = tx, ty = ty, w = 300, drawPriority = 5, prediction = 0.41 } ), 5 )
          end,
          drawPriority = 15
        } ) )
      elseif deb == 'blue' then
        gimmickManager:add( Marker:new( {
          image = WOTH_BLUE_MARKER_IMAGE,
          target = select( i, playerManager:getPlayers() ),
          triggertiming = 15.55 - 9.83,
          func = function()
            local x, y = select( i, playerManager:getPlayers() ):getPosition()
            gimmickManager:add( CircleAoE:new( { x = x, y = y, r = 500, drawPriority = 5, prediction = 0.41 } ), 5 )
          end,
          drawPriority = 15
        } ) )
      end
    end

  end, 9.83 ) )

  -- ドラゴンの突進
  sequenceManager:add( Sequence:new( function()
    local x, y = math.cos( nsew + math.pi ) * 600, math.sin( nsew + math.pi ) * 600
    gimmickManager:add( RectangleAoE:new( { sx = dragon1_x, sy = dragon1_y, tx = x, ty = y, w = 300, drawPriority = 5, prediction = 0.41 } ), 5 )
  end, 15.55 ) )

  -- ドラゴン・真ん中二名着地
  sequenceManager:add( Sequence:new( function()
    gimmickManager:add( FieldObject:new( { image = WOTH_DRAGON_IMAGE, x = dragon2_x, y = dragon2_y, drawPriority = 5, scale = 0.3 } ) )
    gimmickManager:add( FieldObject:new( { image = WOTH_DRAGON_IMAGE, x = dragon3_x, y = dragon3_y, drawPriority = 5, scale = 0.3 } ) )
    gimmickManager:add( FieldObject:new( { image = WOTH_CASTER_IMAGE, x = caster_x, y = caster_y, drawPriority = 5, scale = 0.3 } ) )
    gimmickManager:add( FieldObject:new( { image = WOTH_WARRIOR_IMAGE, x = warrior_x, y = warrior_y, drawPriority = 5, scale = 0.3 } ) )
  end, 12.00 ) )

  -- 雷デバフ付与
  sequenceManager:add( Sequence:new( function()
    for i, deb in ipairs( debuff2 ) do
      if deb == 'thunder' then
        local debuff = Debuff:new( {
          image = WOTH_DEBUFF_THUNDER_IMAGE,
          triggertiming = 29.45 - 14.33,
          target = select( i, playerManager:getPlayers() ),
          func = function()
            local x, y = select( i, playerManager:getPlayers() ):getPosition()
            gimmickManager:add( CircleAoE:new( { x = x, y = y, r = 200, drawPriority = 5 } ), 5 )
          end,
          drawPriority = 15
        } )
        select( i, playerManager:getPlayers() ):addDebuff( debuff )
        gimmickManager:add( debuff )
      end
    end
  end, 14.33 ) )

  -- 緑デバフ
  sequenceManager:add( Sequence:new( function()
    for i, deb in ipairs( debuff1 ) do
      if deb == 'green' then
        gimmickManager:add( Marker:new( {
          image = WOTH_GREEN_MARKER_IMAGE,
          target = select( i, playerManager:getPlayers() ),
          triggertiming = 21.70 - 15.80,
          func = function()
            local x, y = select( i, playerManager:getPlayers() ):getPosition()
            gimmickManager:add( RectangleAoE:new( { sx = dragon2_x, sy = dragon2_y, tx = x, ty = y, w = 300, drawPriority = 5, prediction = 28.85 - 21.70 } ), 5 )
            gimmickManager:add( RectangleAoE:new( { sx = dragon3_x, sy = dragon3_y, tx = x, ty = y, w = 300, drawPriority = 5, prediction = 28.85 - 21.70 } ), 5 )
          end,
          drawPriority = 15
        } ) )
      end
    end
  end, 15.80 ) )

  -- アスカロンメルシーと追跡円範囲1
  sequenceManager:add( Sequence:new( function()
    for i, player in ipairs( { playerManager:getPlayers() } ) do
      local x, y = player:getPosition()
      -- local angle = math.atan2( y - dragon2_y, x - dragon2_x )
      gimmickManager:add( RectangleAoE:new( { sx = 0, sy = 0, tx = x, ty = y, w = 50, drawPriority = 5 } ), 5 )
    end
  end, 21.70 ) )

  sequenceManager:add( Sequence:new( function()
    local i = lume.find( debuff1, 'largeaoe' )
    local x, y = select( i, playerManager:getPlayers() ):getPosition()
    gimmickManager:add( CircleAoE:new( { x = x, y = y, r = 250, drawPriority = 5, prediction = 1 } ), 5 )
  end, 21.70 ) )

  sequenceManager:add( Sequence:new( function()
    local i = lume.find( debuff1, 'largeaoe' )
    local x, y = select( i, playerManager:getPlayers() ):getPosition()
    gimmickManager:add( CircleAoE:new( { x = x, y = y, r = 250, drawPriority = 5, prediction = 1 } ), 5 )
  end, 23.56 ) )

  sequenceManager:add( Sequence:new( function()
    local i = lume.find( debuff1, 'largeaoe' )
    local x, y = select( i, playerManager:getPlayers() ):getPosition()
    gimmickManager:add( CircleAoE:new( { x = x, y = y, r = 250, drawPriority = 5, prediction = 1 } ), 5 )
  end, 25.36 ) )

  sequenceManager:add( Sequence:new( function()
    local i = lume.find( debuff1, 'largeaoe' )
    local x, y = select( i, playerManager:getPlayers() ):getPosition()
    gimmickManager:add( CircleAoE:new( { x = x, y = y, r = 250, drawPriority = 5, prediction = 1 } ), 5 )
  end, 26.68 ) )

  -- 追跡円範囲2
  sequenceManager:add( Sequence:new( function()
    local i = lume.find( debuff1, 'smallaoe' )
    local x, y = select( i, playerManager:getPlayers() ):getPosition()
    gimmickManager:add( CircleAoE:new( { x = x, y = y, r = 150, drawPriority = 5, prediction = 1 } ), 5 )
  end, 22.80 ) )

  sequenceManager:add( Sequence:new( function()
    local i = lume.find( debuff1, 'smallaoe' )
    local x, y = select( i, playerManager:getPlayers() ):getPosition()
    gimmickManager:add( CircleAoE:new( { x = x, y = y, r = 150, drawPriority = 5, prediction = 1 } ), 5 )
  end, 24.00 ) )

  sequenceManager:add( Sequence:new( function()
    local i = lume.find( debuff1, 'smallaoe' )
    local x, y = select( i, playerManager:getPlayers() ):getPosition()
    gimmickManager:add( CircleAoE:new( { x = x, y = y, r = 150, drawPriority = 5, prediction = 1 } ), 5 )
  end, 25.16 ) )

  sequenceManager:add( Sequence:new( function()
    local i = lume.find( debuff1, 'smallaoe' )
    local x, y = select( i, playerManager:getPlayers() ):getPosition()
    gimmickManager:add( CircleAoE:new( { x = x, y = y, r = 150, drawPriority = 5, prediction = 1 } ), 5 )
  end, 26.38 ) )

  sequenceManager:add( Sequence:new( function()
    local i = lume.find( debuff1, 'smallaoe' )
    local x, y = select( i, playerManager:getPlayers() ):getPosition()
    gimmickManager:add( CircleAoE:new( { x = x, y = y, r = 150, drawPriority = 5, prediction = 1 } ), 5 )
  end, 27.46 ) )

  -- 最後のダイナモ
  sequenceManager:add( Sequence:new( function()
    gimmickManager:add( CircleAoE:new( { x = warrior_x, y = warrior_y, r = 1500, ir = 200, drawPriority = 6, prediction = 28.85 - 28.13 } ), 5 )
  end, 28.13 ) )

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
  PartyListHUD:update( dt )
end

function sandbox:draw()
  SpellGaugeHUD:draw()
  DebuffListHUD:draw( HUD_DEBUFF_LIST_IMAGE_X, HUD_DEBUFF_LIST_IMAGE_Y )
  PartyListHUD:draw( HUD_PARTY_LIST_IMAGE_X, HUD_PARTY_LIST_IMAGE_Y, 0.8 )
end

function sandbox:leave()
  GIManager:deleteInstanceAll()
end

return sandbox

