-- Fonts
FONT_REGULAR_SIZE = 24
FONT_HUD_SIZE = 28

FONT_REGULAR = love.graphics.newFont( 'resource/font/PixelMplus12-Regular.ttf',
                                      FONT_REGULAR_SIZE )
FONT_HUD = love.graphics.newFont( 'resource/font/YuGothM.ttc', FONT_HUD_SIZE )

FONT_REGULAR:setFilter( 'nearest', 'nearest' )
FONT_HUD:setFilter( 'nearest', 'nearest' )

-- Image
PLAYER_IMAGE_MT = love.graphics.newImage( 'resource/image/player/mt.png',
                                          { mipmaps = true } )
PLAYER_IMAGE_ST = love.graphics.newImage( 'resource/image/player/st.png',
                                          { mipmaps = true } )
PLAYER_IMAGE_H1 = love.graphics.newImage( 'resource/image/player/h1.png',
                                          { mipmaps = true } )
PLAYER_IMAGE_H2 = love.graphics.newImage( 'resource/image/player/h2.png',
                                          { mipmaps = true } )
PLAYER_IMAGE_D1 = love.graphics.newImage( 'resource/image/player/d1.png',
                                          { mipmaps = true } )
PLAYER_IMAGE_D2 = love.graphics.newImage( 'resource/image/player/d2.png',
                                          { mipmaps = true } )
PLAYER_IMAGE_D3 = love.graphics.newImage( 'resource/image/player/d3.png',
                                          { mipmaps = true } )
PLAYER_IMAGE_D4 = love.graphics.newImage( 'resource/image/player/d4.png',
                                          { mipmaps = true } )

PLAYER_IMAGE_MT:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_ST:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_H1:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_H2:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_D1:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_D2:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_D3:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_D4:setFilter( 'nearest', 'nearest' )

-- field image
NIDHOGG_GROUND_IMAGE = love.graphics.newImage(
                           'resource/image/field/nidhogg.png',
                           { mipmaps = true } )
WOTH_GROUND_IMAGE = love.graphics.newImage(
                        'resource/image/field/warthoftheheavens.png',
                        { mipmaps = true } )

NIDHOGG_GROUND_IMAGE:setFilter( 'nearest', 'nearest' )
WOTH_GROUND_IMAGE:setFilter( 'nearest', 'nearest' )

-- objects
WOTH_WARRIOR_IMAGE = love.graphics.newImage(
                         'resource/image/object/warrior.png', { mipmaps = true } )
WOTH_SOLIDER_IMAGE = love.graphics.newImage( 'resource/image/object/lancer.png',
                                             { mipmaps = true } )
WOTH_CASTER_IMAGE = love.graphics.newImage( 'resource/image/object/caster.png',
                                            { mipmaps = true } )
WOTH_DRAGON_IMAGE = love.graphics.newImage( 'resource/image/object/dragon.png',
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
                                'resource/image/object/debuffthunder.png',
                                { mipmaps = true } )

WOTH_WARRIOR_IMAGE:setFilter( 'nearest', 'nearest' )
WOTH_SOLIDER_IMAGE:setFilter( 'nearest', 'nearest' )
WOTH_CASTER_IMAGE:setFilter( 'nearest', 'nearest' )
WOTH_DRAGON_IMAGE:setFilter( 'nearest', 'nearest' )
WOTH_THORDAN_IMAGE:setFilter( 'nearest', 'nearest' )
WOTH_CHAIN_IMAGE:setFilter( 'nearest', 'nearest' )
WOTH_BLUE_MARKER_IMAGE:setFilter( 'nearest', 'nearest' )
WOTH_GREEN_MARKER_IMAGE:setFilter( 'nearest', 'nearest' )
WOTH_DEBUFF_THUNDER_IMAGE:setFilter( 'nearest', 'nearest' )

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
