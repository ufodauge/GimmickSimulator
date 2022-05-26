-- Fonts
FONT_REGULAR_SIZE = 24
FONT_HUD_SIZE = 28

FONT_REGULAR = love.graphics.newFont( 'resource/font/PixelMplus12-Regular.ttf',
                                      FONT_REGULAR_SIZE )
FONT_HUD = love.graphics.newFont( 'resource/font/YuGothM.ttc', FONT_HUD_SIZE )

FONT_REGULAR:setFilter( 'nearest', 'nearest' )
FONT_HUD:setFilter( 'nearest', 'nearest' )

-- Image
PLAYER_IMAGE_MT = love.graphics.newImage( 'resource/image/player/MT.png',
                                          { mipmaps = true } )
PLAYER_IMAGE_ST = love.graphics.newImage( 'resource/image/player/ST.png',
                                          { mipmaps = true } )
PLAYER_IMAGE_H1 = love.graphics.newImage( 'resource/image/player/H1.png',
                                          { mipmaps = true } )
PLAYER_IMAGE_H2 = love.graphics.newImage( 'resource/image/player/H2.png',
                                          { mipmaps = true } )
PLAYER_IMAGE_D1 = love.graphics.newImage( 'resource/image/player/D1.png',
                                          { mipmaps = true } )
PLAYER_IMAGE_D2 = love.graphics.newImage( 'resource/image/player/D2.png',
                                          { mipmaps = true } )
PLAYER_IMAGE_D3 = love.graphics.newImage( 'resource/image/player/D3.png',
                                          { mipmaps = true } )
PLAYER_IMAGE_D4 = love.graphics.newImage( 'resource/image/player/D4.png',
                                          { mipmaps = true } )

PLAYER_IMAGE_MT:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_ST:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_H1:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_H2:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_D1:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_D2:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_D3:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_D4:setFilter( 'nearest', 'nearest' )

PLAYER_IMAGE_ICON_MT = love.graphics.newImage( 'resource/image/hud/MT_icon.png',
                                               { mipmaps = true } )
PLAYER_IMAGE_ICON_ST = love.graphics.newImage( 'resource/image/hud/ST_icon.png',
                                               { mipmaps = true } )
PLAYER_IMAGE_ICON_H1 = love.graphics.newImage( 'resource/image/hud/H1_icon.png',
                                               { mipmaps = true } )
PLAYER_IMAGE_ICON_H2 = love.graphics.newImage( 'resource/image/hud/H2_icon.png',
                                               { mipmaps = true } )
PLAYER_IMAGE_ICON_D1 = love.graphics.newImage( 'resource/image/hud/D1_icon.png',
                                               { mipmaps = true } )
PLAYER_IMAGE_ICON_D2 = love.graphics.newImage( 'resource/image/hud/D2_icon.png',
                                               { mipmaps = true } )
PLAYER_IMAGE_ICON_D3 = love.graphics.newImage( 'resource/image/hud/D3_icon.png',
                                               { mipmaps = true } )
PLAYER_IMAGE_ICON_D4 = love.graphics.newImage( 'resource/image/hud/D4_icon.png',
                                               { mipmaps = true } )

PLAYER_IMAGE_ICON_MT:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_ICON_ST:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_ICON_H1:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_ICON_H2:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_ICON_D1:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_ICON_D2:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_ICON_D3:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_ICON_D4:setFilter( 'nearest', 'nearest' )

-- field image
NIDHOGG_GROUND_IMAGE = love.graphics.newImage(
                           'resource/image/field/nidhogg.png',
                           { mipmaps = true } )
WOTH_GROUND_IMAGE = love.graphics.newImage(
                        'resource/image/field/warthoftheheavens.png',
                        { mipmaps = true } )

NIDHOGG_GROUND_IMAGE:setFilter( 'nearest', 'nearest' )
WOTH_GROUND_IMAGE:setFilter( 'nearest', 'nearest' )

-- field marker
FIELD_MARKER_1_IMAGE = love.graphics.newImage( 'resource/image/object/fm_1.png',
                                               { mipmaps = true } )
FIELD_MARKER_2_IMAGE = love.graphics.newImage( 'resource/image/object/fm_2.png',
                                               { mipmaps = true } )
FIELD_MARKER_3_IMAGE = love.graphics.newImage( 'resource/image/object/fm_3.png',
                                               { mipmaps = true } )
FIELD_MARKER_4_IMAGE = love.graphics.newImage( 'resource/image/object/fm_4.png',
                                               { mipmaps = true } )
FIELD_MARKER_A_IMAGE = love.graphics.newImage( 'resource/image/object/fm_A.png',
                                               { mipmaps = true } )
FIELD_MARKER_B_IMAGE = love.graphics.newImage( 'resource/image/object/fm_B.png',
                                               { mipmaps = true } )
FIELD_MARKER_C_IMAGE = love.graphics.newImage( 'resource/image/object/fm_C.png',
                                               { mipmaps = true } )
FIELD_MARKER_D_IMAGE = love.graphics.newImage( 'resource/image/object/fm_D.png',
                                               { mipmaps = true } )

FIELD_MARKER_1_IMAGE:setFilter( 'nearest', 'nearest' )
FIELD_MARKER_2_IMAGE:setFilter( 'nearest', 'nearest' )
FIELD_MARKER_3_IMAGE:setFilter( 'nearest', 'nearest' )
FIELD_MARKER_4_IMAGE:setFilter( 'nearest', 'nearest' )
FIELD_MARKER_A_IMAGE:setFilter( 'nearest', 'nearest' )
FIELD_MARKER_B_IMAGE:setFilter( 'nearest', 'nearest' )
FIELD_MARKER_C_IMAGE:setFilter( 'nearest', 'nearest' )
FIELD_MARKER_D_IMAGE:setFilter( 'nearest', 'nearest' )

-- objects
WOTH_WARRIOR_IMAGE = love.graphics.newImage(
                         'resource/image/object/warrior.png', { mipmaps = true } )
WOTH_SOLIDER_IMAGE = love.graphics.newImage( 'resource/image/object/lancer.png',
                                             { mipmaps = true } )
WOTH_CASTER_IMAGE = love.graphics.newImage( 'resource/image/object/caster.png',
                                            { mipmaps = true } )
WOTH_DRAGON_IMAGE = love.graphics.newImage( 'resource/image/object/dragon.png',
                                            { mipmaps = true } )
DOTH_BLACK_DRAGON_IMAGE = love.graphics.newImage(
                              'resource/image/object/blackdragon.png',
                              { mipmaps = true } )
DOTH_WHITE_DRAGON_IMAGE = love.graphics.newImage(
                              'resource/image/object/whitedragon.png',
                              { mipmaps = true } )
WOTH_THORDAN_IMAGE = love.graphics.newImage(
                         'resource/image/object/thordan.png', { mipmaps = true } )
WOTH_CHAIN_IMAGE = love.graphics.newImage( 'resource/image/object/chain.png',
                                           { mipmaps = true } )
WOTH_BLUE_MARKER_IMAGE = love.graphics.newImage(
                             'resource/image/object/bluemarker.png',
                             { mipmaps = true } )
WOTH_GREEN_MARKER_IMAGE = love.graphics.newImage(
                              'resource/image/object/greenmarker.png',
                              { mipmaps = true } )
WOTH_DEBUFF_THUNDER_IMAGE = love.graphics.newImage(
                                'resource/image/object/debuff_thunder.png',
                                { mipmaps = true } )
DOTH_DEBUFF_DEATH_IMAGE = love.graphics.newImage(
                              'resource/image/object/debuff_death.png',
                              { mipmaps = true } )
DOTH_CIRCLE_MARKER_IMAGE = love.graphics.newImage(
                               'resource/image/object/circmarker.png',
                               { mipmaps = true } )
DOTH_CROSS_MARKER_IMAGE = love.graphics.newImage(
                              'resource/image/object/crossmarker.png',
                              { mipmaps = true } )
DOTH_TRIANGLE_MARKER_IMAGE = love.graphics.newImage(
                                 'resource/image/object/trimarker.png',
                                 { mipmaps = true } )
DOTH_SQUARE_MARKER_IMAGE = love.graphics.newImage(
                               'resource/image/object/sqmarker.png',
                               { mipmaps = true } )

WOTH_WARRIOR_IMAGE:setFilter( 'nearest', 'nearest' )
WOTH_SOLIDER_IMAGE:setFilter( 'nearest', 'nearest' )
WOTH_CASTER_IMAGE:setFilter( 'nearest', 'nearest' )
WOTH_DRAGON_IMAGE:setFilter( 'nearest', 'nearest' )
DOTH_BLACK_DRAGON_IMAGE:setFilter( 'nearest', 'nearest' )
DOTH_WHITE_DRAGON_IMAGE:setFilter( 'nearest', 'nearest' )
WOTH_THORDAN_IMAGE:setFilter( 'nearest', 'nearest' )
WOTH_CHAIN_IMAGE:setFilter( 'nearest', 'nearest' )
WOTH_BLUE_MARKER_IMAGE:setFilter( 'nearest', 'nearest' )
WOTH_GREEN_MARKER_IMAGE:setFilter( 'nearest', 'nearest' )
WOTH_DEBUFF_THUNDER_IMAGE:setFilter( 'nearest', 'nearest' )
DOTH_DEBUFF_DEATH_IMAGE:setFilter( 'nearest', 'nearest' )
DOTH_CIRCLE_MARKER_IMAGE:setFilter( 'nearest', 'nearest' )
DOTH_CROSS_MARKER_IMAGE:setFilter( 'nearest', 'nearest' )
DOTH_TRIANGLE_MARKER_IMAGE:setFilter( 'nearest', 'nearest' )
DOTH_SQUARE_MARKER_IMAGE:setFilter( 'nearest', 'nearest' )

-- HUD
HUD_SPELLGAUGE_BASE_IMAGE = love.graphics.newImage(
                                'resource/image/hud/spellgaugebase.png',
                                { mipmaps = true } )
HUD_SPELLGAUGE_SPELL_IMAGE = love.graphics.newImage(
                                 'resource/image/hud/spellgauge.png',
                                 { mipmaps = true } )

HUD_SPELLGAUGE_BASE_IMAGE:setFilter( 'nearest', 'nearest' )
HUD_SPELLGAUGE_SPELL_IMAGE:setFilter( 'nearest', 'nearest' )

HUD_SPELLGAUGE_BASE_IMAGE_X = 100
HUD_SPELLGAUGE_BASE_IMAGE_Y = 100

HUD_SPELLGAUGE_SPELL_IMAGE_RELATED_TO_BASE_X = 13
HUD_SPELLGAUGE_SPELL_IMAGE_RELATED_TO_BASE_Y = 13

HUD_DEBUFF_LIST_IMAGE_X = 100
HUD_DEBUFF_LIST_IMAGE_Y = 300

HUD_DEBUFF_LIST_ICON_WIDTH = 50

HUD_PARTY_LIST_BG_IMAGE = love.graphics.newImage(
                              'resource/image/hud/partylist_bg.png',
                              { mipmaps = true } )
HUD_PARTY_LIST_HP_GAUGE_IMAGE = love.graphics.newImage(
                                    'resource/image/hud/partylist_hp_gauge.png',
                                    { mipmaps = true } )

HUD_PARTY_LIST_BG_IMAGE:setFilter( 'nearest', 'nearest' )
HUD_PARTY_LIST_HP_GAUGE_IMAGE:setFilter( 'nearest', 'nearest' )

HUD_PARTY_LIST_WIDTH = HUD_PARTY_LIST_BG_IMAGE:getWidth()
HUD_PARTY_LIST_HEIGHT = HUD_PARTY_LIST_BG_IMAGE:getHeight() * 8

HUD_PARTY_LIST_IMAGE_X = love.graphics.getWidth() - 500
HUD_PARTY_LIST_IMAGE_Y = 400

HUD_PARTY_LIST_ICON_REL_X = 10
HUD_PARTY_LIST_ICON_REL_Y = 10

HUD_PARTY_LIST_HP_GAUGE_REL_X = 70
HUD_PARTY_LIST_HP_GAUGE_REL_Y = 26

HUD_PARTY_LIST_BG_HEIGHT = 62

HUD_PARTY_LIST_DEBUFF_REL_X = 270

-- Constants
PLAYER_SPEED = 2.5
PLAYER_ROT_SPEED = math.pi * 1.5
PLAYER_CAMERA_TILT = 180

-- AoE
AOE_COLOR_RED = 199 / 255
AOE_COLOR_GREEN = 153 / 255
AOE_COLOR_BLUE = 113 / 255
AOE_COLOR_ALPHA = 0.5
TRIGGERED_AOE_COLOR_RED = 0.7
TRIGGERED_AOE_COLOR_GREEN = 0.13
TRIGGERED_AOE_COLOR_BLUE = 0.13
TRIGGERED_AOE_COLOR_ALPHA = 0.5
AOE_TIMELAG_BETWEEN_UNDISPLAYED_AND_TRIGGERED = 0.5
TRIGGERED_AOE_DURATION = 0.3
AOE_FADEIN_DURATION = 0.3
AOE_FADEOUT_DURATION = 0.3
