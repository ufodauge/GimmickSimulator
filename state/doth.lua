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

sandbox.name = 'Warthoftheheavens'

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

  DebuffListHUD:setTarget( playerManager:getPlayers() )
  PartyListHUD:add( playerManager:getPlayers() )

  -- マーカー、および初期化
  sequenceManager:add( Sequence:new( function()
    gimmickManager:add( FieldObject:new( { image = FIELD_MARKER_A_IMAGE, x = 0, y = 550, scale = 1.5, drawPriority = 8 } ) )
    gimmickManager:add( FieldObject:new( { image = FIELD_MARKER_B_IMAGE, x = 550, y = 0, scale = 1.5, drawPriority = 8 } ) )
    gimmickManager:add( FieldObject:new( { image = FIELD_MARKER_C_IMAGE, x = 0, y = -550, scale = 1.5, drawPriority = 8 } ) )
    gimmickManager:add( FieldObject:new( { image = FIELD_MARKER_D_IMAGE, x = -550, y = 0, scale = 1.5, drawPriority = 8 } ) )
    gimmickManager:add( FieldObject:new( {
      image = FIELD_MARKER_1_IMAGE,
      x = 550 * math.cos( math.pi / 4 ),
      y = 550 * math.sin( math.pi / 4 ),
      scale = 1.5,
      drawPriority = 8
    } ) )
    gimmickManager:add( FieldObject:new( {
      image = FIELD_MARKER_2_IMAGE,
      x = 550 * math.cos( -math.pi / 4 ),
      y = 550 * math.sin( -math.pi / 4 ),
      scale = 1.5,
      drawPriority = 8
    } ) )
    gimmickManager:add( FieldObject:new( {
      image = FIELD_MARKER_3_IMAGE,
      x = 550 * math.cos( -3 * math.pi / 4 ),
      y = 550 * math.sin( -3 * math.pi / 4 ),
      scale = 1.5,
      drawPriority = 8
    } ) )
    gimmickManager:add( FieldObject:new( {
      image = FIELD_MARKER_4_IMAGE,
      x = 550 * math.cos( 3 * math.pi / 4 ),
      y = 550 * math.sin( 3 * math.pi / 4 ),
      scale = 1.5,
      drawPriority = 8
    } ) )
    for _, player in ipairs( { playerManager:getPlayers() } ) do
      if not player:isPlayable() then
        local randx, randy = math.random( -100, 100 ), math.random( -100, 100 )
        player:moveTo( randx, randy )
      end
    end
  end, 0 ) )

  -- ほかプレイヤー画面外へ
  sequenceManager:add( Sequence:new( function()
    for _, player in ipairs( { playerManager:getPlayers() } ) do
      if not player:isPlayable() then
        player:moveTo( 0, 5000 )
      end
    end
  end, 0.1 ) )

  -- 至天の陣：死刻
  sequenceManager:add( Sequence:new( function()
    SpellGaugeHUD:spell( { time = 3.5, mes = '至天の陣：死刻' } )
    gimmickManager:add( FieldObject:new( { image = WOTH_WARRIOR_IMAGE, x = -220, y = 220, drawPriority = 5, scale = 0.25 } ), 7.2 )
    gimmickManager:add( FieldObject:new( { image = WOTH_CASTER_IMAGE, x = 220, y = 220, drawPriority = 5, scale = 0.3 } ), 7.2 )
    gimmickManager:add( FieldObject:new( { image = WOTH_SOLIDER_IMAGE, x = 220, y = -220, drawPriority = 5, scale = 0.3 } ), 7.2 )
    gimmickManager:add( FieldObject:new( { image = WOTH_SOLIDER_IMAGE, x = -220, y = -220, drawPriority = 5, scale = 0.3 } ), 7.2 )
    gimmickManager:add( FieldObject:new( { image = WOTH_SOLIDER_IMAGE, x = 0, y = -300, drawPriority = 5, scale = 0.3 } ), 7.2 )
    gimmickManager:add( FieldObject:new( { image = WOTH_DRAGON_IMAGE, x = -800, y = 0, drawPriority = 5, scale = 0.3 } ), 7.2 )
    gimmickManager:add( FieldObject:new( { image = WOTH_DRAGON_IMAGE, x = 800, y = 0, drawPriority = 5, scale = 0.3 } ), 7.2 )
    gimmickManager:add( FieldObject:new( { image = WOTH_THORDAN_IMAGE, x = 0, y = 0, drawPriority = 5, scale = 0.3 } ), 7.2 )
  end, 0.1 ) )

  local nsew = nil
  local dragon1_x, dragon1_y = 0, 0
  local dragon2_x, dragon2_y = 0, 0
  local dragon3_x, dragon3_y = 0, 0
  local caster_x, caster_y = 0, 0
  local warrior_x, warrior_y = 0, 0

  local nsew2 = nil
  local thordan_x, thordan_y = 0, 0
  local nsew3 = nil
  local dragonseye_x, dragonseye_y = 0, 0

  -- 着地
  sequenceManager:add( Sequence:new( function()
    nsew = lume.randomchoice( { -math.pi / 2, 0, math.pi / 2, math.pi } )
    dragon1_x, dragon1_y = math.cos( nsew ) * 700, math.sin( nsew ) * 700 -- black
    dragon2_x, dragon2_y = math.cos( nsew - math.pi / 3 ) * 700, math.sin( nsew - math.pi / 3 ) * 700 -- white
    dragon3_x, dragon3_y = math.cos( nsew - math.pi * 2 / 3 ) * 700, math.sin( nsew - math.pi * 2 / 3 ) * 700 -- blue
    warrior_x, warrior_y = math.cos( nsew ) * 243, math.sin( nsew ) * 243 -- warrior
    caster_x, caster_y = math.cos( nsew + math.pi / 2 ) * 700, math.sin( nsew + math.pi / 2 ) * 700 -- solider?

    nsew2 = lume.randomchoice( { 0, math.pi / 4, math.pi / 2, math.pi / 4 * 3, math.pi, math.pi / 4 * 5, math.pi / 2 * 3, math.pi / 4 * 7 } )
    nsew3 = lume.randomchoice( { 0, math.pi / 4, -math.pi / 4 } )
    thordan_x, thordan_y = math.cos( nsew2 ) * 750, math.sin( nsew2 ) * 750 -- thordan
    dragonseye_x, dragonseye_y = math.cos( nsew2 + nsew3 - math.pi ) * 750, math.sin( nsew2 + nsew3 - math.pi ) * 750 -- dragonseye

    gimmickManager:add( FieldObject:new( { image = DOTH_BLACK_DRAGON_IMAGE, x = dragon1_x, y = dragon1_y, drawPriority = 5, scale = 0.3 } ), 20.3 - 8.3 )
    gimmickManager:add( FieldObject:new( { image = WOTH_SOLIDER_IMAGE, x = dragon2_x, y = dragon2_y, drawPriority = 5, scale = 0.3 } ), 20.3 - 8.3 )
    gimmickManager:add( FieldObject:new( { image = WOTH_DRAGON_IMAGE, x = dragon3_x, y = dragon3_y, drawPriority = 5, scale = 0.3 } ), 20.3 - 8.3 )
    gimmickManager:add( FieldObject:new( { image = WOTH_WARRIOR_IMAGE, x = warrior_x, y = warrior_y, drawPriority = 5, scale = 0.3 } ), 20.3 - 8.3 )
    gimmickManager:add( FieldObject:new( { image = DOTH_WHITE_DRAGON_IMAGE, x = caster_x, y = caster_y, drawPriority = 5, scale = 0.3 } ), 20.3 - 8.3 )
    gimmickManager:add( FieldObject:new( { image = WOTH_THORDAN_IMAGE, x = thordan_x, y = thordan_y, drawPriority = 4, scale = 0.3 } ) )
    gimmickManager:add( FieldObject:new( { image = DOTH_DRAGON_EYE_IMAGE, x = dragonseye_x, y = dragonseye_y, drawPriority = 4 } ) )
  end, 8.3 ) )

  -- 誰に何を付与するかを決める
  local debuff1 = nil

  -- 死の宣告
  sequenceManager:add( Sequence:new( function()
    debuff1 = lume.shuffle( { 'cirA', 'cirB', 'crsA', 'crsB', 'triA', 'triB', 'sqeA', 'sqeB' } )

    for i, deb in ipairs( debuff1 ) do
      local pl = select( i, playerManager:getPlayers() )
      if lume.find( { 'cirA', 'cirB', 'triA', 'sqeA' }, deb ) then
        local debuff = Debuff:new( {
          image = DOTH_DEBUFF_DEATH_IMAGE,
          triggertiming = 35.8 - 11.3,
          target = pl,
          func = function()
            -- デバフがあるよってだけ
          end,
          drawPriority = 15
        } )
        pl:addDebuff( debuff )
        gimmickManager:add( debuff )
      end
    end
  end, 11.3 ) )

  -- Heavy Impact 1
  sequenceManager:add( Sequence:new( function()
    SpellGaugeHUD:spell( { time = 18.4 - 12.7 - AOE_TIMELAG_BETWEEN_UNDISPLAYED_AND_TRIGGERED, mes = 'ヘヴィインパクト' } )
    gimmickManager:add( CircleAoE:new( {
      x = warrior_x,
      y = warrior_y,
      r = 162,
      prediction = 18.4 - 12.7 - AOE_TIMELAG_BETWEEN_UNDISPLAYED_AND_TRIGGERED,
      drawPriority = 5
    } ), 18.4 - 12.7 + 1 )
  end, 12.7 ) )

  -- Heavy Impact 2
  sequenceManager:add( Sequence:new( function()
    gimmickManager:add( CircleAoE:new( { x = warrior_x, y = warrior_y, r = 314, ir = 162, drawPriority = 5 } ), 1 )
  end, 20.3 ) )

  -- Heavy Impact 3
  sequenceManager:add( Sequence:new( function()
    gimmickManager:add( CircleAoE:new( { x = warrior_x, y = warrior_y, r = 476, ir = 314, drawPriority = 5 } ), 1 )
  end, 22.2 ) )

  -- Heavy Impact 4
  sequenceManager:add( Sequence:new( function()
    gimmickManager:add( CircleAoE:new( { x = warrior_x, y = warrior_y, r = 638, ir = 476, drawPriority = 5 } ), 1 )
  end, 24.0 ) )

  -- Heavy Impact 5
  sequenceManager:add( Sequence:new( function()
    gimmickManager:add( CircleAoE:new( { x = warrior_x, y = warrior_y, r = 800, ir = 638, drawPriority = 5 } ), 1 )
  end, 26.0 ) )

  -- 白AoEなどなど
  sequenceManager:add( Sequence:new( function()
    local x, y = math.cos( nsew + math.pi ) * 1500, math.sin( nsew + math.pi ) * 1500
    gimmickManager:add( RectangleAoE:new( { sx = dragon1_x, sy = dragon1_y, tx = x, ty = y, w = 600, drawPriority = 5 } ), 1 )

    x, y = math.cos( nsew + math.pi * 2 / 3 ) * 1500, math.sin( nsew + math.pi * 2 / 3 ) * 1500
    gimmickManager:add( RectangleAoE:new( { sx = dragon2_x, sy = dragon2_y, tx = x, ty = y, w = 150, drawPriority = 5 } ), 1 )

    x, y = math.cos( nsew + math.pi / 3 ) * 1500, math.sin( nsew + math.pi / 3 ) * 1500
    gimmickManager:add( RectangleAoE:new( { sx = dragon3_x, sy = dragon3_y, tx = x, ty = y, w = 150, drawPriority = 5 } ), 1 )

    local death_p = 0
    local pos = {
      { math.cos( nsew + math.pi * 7 / 16 ) * 550, math.sin( nsew + math.pi * 7 / 16 ) * 550 },
      { math.cos( nsew + math.pi * 3 / 16 ) * 550, math.sin( nsew + math.pi * 3 / 16 ) * 550 },
      { math.cos( nsew - math.pi * 3 / 16 ) * 550, math.sin( nsew - math.pi * 3 / 16 ) * 550 },
      { math.cos( nsew - math.pi * 7 / 16 ) * 550, math.sin( nsew - math.pi * 7 / 16 ) * 550 }
    }
    for i, deb in ipairs( debuff1 ) do
      if lume.find( { 'crsA', 'crsB', 'triB', 'sqeB' }, deb ) then
        death_p = death_p + 1
        local pl = select( i, playerManager:getPlayers() )
        local x, y = 0, 0
        if pl:isPlayable() then
          x, y = pl:getPosition()
        else
          x, y = unpack( pos[death_p] )
        end
        gimmickManager:add( CircleAoE:new( { x = x, y = y, r = 100, drawPriority = 5, color = '#FFFFFF', alpha = 0.5, prediction = 35.8 - 20.3 } ), 35.8 - 20.3 )
      end
    end
  end, 20.3 ) )

  -- 雷デバフ付与
  sequenceManager:add( Sequence:new( function()
    for i, pl in ipairs( { playerManager:getPlayers() } ) do
      local debuff = Debuff:new( {
        image = WOTH_DEBUFF_THUNDER_IMAGE,
        triggertiming = 3,
        target = pl,
        func = function()
          local x, y = pl:getPosition()
          gimmickManager:add( CircleAoE:new( { x = x, y = y, r = 200, drawPriority = 5 } ), 5 )
        end,
        drawPriority = 15
      } )
      pl:addDebuff( debuff )
      gimmickManager:add( debuff )
    end
  end, 20.8 ) )

  -- ツイスター
  sequenceManager:add( Sequence:new( function()
    for i, pl in ipairs( { playerManager:getPlayers() } ) do
      local x, y = pl:getPosition()
      gimmickManager:add( CircleAoE:new( { x = x, y = y, r = 50, color = '#616B07', drawPriority = 5, prediction = 27.0 - 21.3 } ), 7 )
    end
  end, 21.3 ) )

  -- プレステ
  sequenceManager:add( Sequence:new( function()
    for i, deb in ipairs( debuff1 ) do
      local pl = select( i, playerManager:getPlayers() )
      local image = nil
      if lume.find( { 'cirA', 'cirB' }, deb ) then
        image = DOTH_CIRCLE_MARKER_IMAGE
      elseif lume.find( { 'crsA', 'crsB' }, deb ) then
        image = DOTH_CROSS_MARKER_IMAGE
      elseif lume.find( { 'triA', 'triB' }, deb ) then
        image = DOTH_TRIANGLE_MARKER_IMAGE
      else
        image = DOTH_SQUARE_MARKER_IMAGE
      end

      gimmickManager:add( Marker:new( {
        image = image,
        target = pl,
        scale = 0.2,
        triggertiming = 32.4 - 28.6,
        func = function()
          pl:stun( 35.8 - 32.4 )
        end,
        drawPriority = 15
      } ) )
    end
  end, 28.6 ) )

  -- ノックバック
  sequenceManager:add( Sequence:new( function()
    for i, pl in ipairs( { playerManager:getPlayers() } ) do
      local x, y = pl:getPosition()
      local angle = math.atan2( y, x )
      local dx, dy = math.cos( angle ) * 550, math.sin( angle ) * 550
      pl:blowBack( dx, dy, 35.8 - 34.3 )
    end
  end, 34.3 ) )

  -- 小範囲攻撃
  sequenceManager:add( Sequence:new( function()
    for i, pl in ipairs( { playerManager:getPlayers() } ) do
      local x, y = pl:getPosition()
      gimmickManager:add( CircleAoE:new( { x = x, y = y, r = 100, drawPriority = 5 } ), 1 )
    end
  end, 35.8 ) )

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
  playerManager:delete()
  sequenceManager:delete()
  gimmickManager:delete()
  SpellGaugeHUD:delete()
  DebuffListHUD:delete()
  PartyListHUD:delete()
  field:delete()
  GIManager:deleteInstanceAll()
end

return sandbox

