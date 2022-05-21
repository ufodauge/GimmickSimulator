-- Fonts
FONT_REGULAR_SIZE = 24
FONT_DEBUG_SIZE = 16
FONT_HUD_SIZE = 28

FONT_REGULAR = love.graphics.newFont( 'resource//PixelMplus12-Regular.ttf', FONT_REGULAR_SIZE )
FONT_DEBUG = love.graphics.newFont( 'resource//fixedsys-ligatures.ttf', FONT_DEBUG_SIZE )
FONT_HUD = love.graphics.newFont( 'resource//YuGothM.ttc', FONT_HUD_SIZE )

FONT_REGULAR:setFilter( 'nearest', 'nearest' )
FONT_DEBUG:setFilter( 'nearest', 'nearest' )
FONT_HUD:setFilter( 'nearest', 'nearest' )

-- hitbox radius
HITBOX_RADIUS = 3

-- player
PLAYER_SPEED = 2.3
PLAYER_ROT_SPEED = math.pi * 1.5
PLAYER_ZOOM_SPEED = 0.01

-- aoe
AOE_COLOR_RED = 0.92
AOE_COLOR_GREEN = 0.84
AOE_COLOR_BLUE = 0.06
AOE_COLOR_ALPHA = 0.5
AOE_COLOR_TRIGGERING_RED = 0.7
AOE_COLOR_TRIGGERING_GREEN = 0.13
AOE_COLOR_TRIGGERING_BLUE = 0.13
AOE_COLOR_TRIGGERING_ALPHA = 0.5
AOE_TIMELAG_BETWEEN_UNDISPLAYED_AND_TRIGGERED = 0.5
AOE_TRIGGERING_DURATION = 0.3

-- field marker
FIELD_MARKER_A_IMAGE = love.graphics.newImage( 'resource//field_marker_A.png', { mipmaps = true } )
FIELD_MARKER_B_IMAGE = love.graphics.newImage( 'resource//field_marker_B.png', { mipmaps = true } )
FIELD_MARKER_C_IMAGE = love.graphics.newImage( 'resource//field_marker_C.png', { mipmaps = true } )
FIELD_MARKER_D_IMAGE = love.graphics.newImage( 'resource//field_marker_D.png', { mipmaps = true } )
FIELD_MARKER_1_IMAGE = love.graphics.newImage( 'resource//field_marker_1.png', { mipmaps = true } )
FIELD_MARKER_2_IMAGE = love.graphics.newImage( 'resource//field_marker_2.png', { mipmaps = true } )
FIELD_MARKER_3_IMAGE = love.graphics.newImage( 'resource//field_marker_3.png', { mipmaps = true } )
FIELD_MARKER_4_IMAGE = love.graphics.newImage( 'resource//field_marker_4.png', { mipmaps = true } )
FIELD_MARKER_A_IMAGE:setFilter( 'nearest', 'nearest' )
FIELD_MARKER_B_IMAGE:setFilter( 'nearest', 'nearest' )
FIELD_MARKER_C_IMAGE:setFilter( 'nearest', 'nearest' )
FIELD_MARKER_D_IMAGE:setFilter( 'nearest', 'nearest' )
FIELD_MARKER_1_IMAGE:setFilter( 'nearest', 'nearest' )
FIELD_MARKER_2_IMAGE:setFilter( 'nearest', 'nearest' )
FIELD_MARKER_3_IMAGE:setFilter( 'nearest', 'nearest' )
FIELD_MARKER_4_IMAGE:setFilter( 'nearest', 'nearest' )

-- hud
HUD_DEBUFF_ICON_SIZE = 52
HUD_SPELLGAUGE_BASE_IMAGE = love.graphics.newImage( 'resource//spellgaugebase2.png', { mipmaps = true } )
HUD_SPELLGAUGE_SPELL_IMAGE = love.graphics.newImage( 'resource//spellgauge2.png', { mipmaps = true } )
HUD_SPELLGAUGE_SPELL_IMAGE_LEFT = love.graphics.newQuad( 0, 0, HUD_SPELLGAUGE_SPELL_IMAGE:getWidth() / 3, HUD_SPELLGAUGE_SPELL_IMAGE:getHeight(),
                                                         HUD_SPELLGAUGE_SPELL_IMAGE:getWidth(), HUD_SPELLGAUGE_SPELL_IMAGE:getHeight() )
HUD_SPELLGAUGE_SPELL_IMAGE_MIDDLE = love.graphics.newQuad( HUD_SPELLGAUGE_SPELL_IMAGE:getWidth() / 3, 0, HUD_SPELLGAUGE_SPELL_IMAGE:getWidth() / 3,
                                                           HUD_SPELLGAUGE_SPELL_IMAGE:getHeight(), HUD_SPELLGAUGE_SPELL_IMAGE:getWidth(),
                                                           HUD_SPELLGAUGE_SPELL_IMAGE:getHeight() )
HUD_SPELLGAUGE_SPELL_IMAGE_RIGHT = love.graphics.newQuad( 2 * HUD_SPELLGAUGE_SPELL_IMAGE:getWidth() / 3, 0, HUD_SPELLGAUGE_SPELL_IMAGE:getWidth() / 3,
                                                          HUD_SPELLGAUGE_SPELL_IMAGE:getHeight(), HUD_SPELLGAUGE_SPELL_IMAGE:getWidth(),
                                                          HUD_SPELLGAUGE_SPELL_IMAGE:getHeight() )

HUD_SPELLGAUGE_BASE_IMAGE:setFilter( 'nearest', 'nearest' )
HUD_SPELLGAUGE_SPELL_IMAGE:setFilter( 'nearest', 'nearest' )

HUD_SPELLGAUGE_SPELL_IMAGE_LEFT_X = 3
HUD_SPELLGAUGE_SPELL_IMAGE_LEFT_Y = 41
HUD_SPELLGAUGE_SPELL_IMAGE_MIDDLE_MAX_WIDTH = 292
HUD_SPELLGAUGE_SPELL_SEGMENT = 15

-- nidhogg
-- player
NIDHOGG_PLAYER_IMAGE = love.graphics.newImage( 'resource//nidhogg//playerv2.png', { mipmaps = true } )
NIDHOGG_PLAYER_IMAGE:setFilter( 'nearest', 'nearest' )

NIDHOGG_MT_IMAGE = love.graphics.newImage( 'resource//MT.png', { mipmaps = true } )
NIDHOGG_ST_IMAGE = love.graphics.newImage( 'resource//ST.png', { mipmaps = true } )
NIDHOGG_H1_IMAGE = love.graphics.newImage( 'resource//H1.png', { mipmaps = true } )
NIDHOGG_H2_IMAGE = love.graphics.newImage( 'resource//H2.png', { mipmaps = true } )
NIDHOGG_D1_IMAGE = love.graphics.newImage( 'resource//D1.png', { mipmaps = true } )
NIDHOGG_D2_IMAGE = love.graphics.newImage( 'resource//D2.png', { mipmaps = true } )
NIDHOGG_D3_IMAGE = love.graphics.newImage( 'resource//D3.png', { mipmaps = true } )
NIDHOGG_D4_IMAGE = love.graphics.newImage( 'resource//D4.png', { mipmaps = true } )
NIDHOGG_MT_IMAGE:setFilter( 'nearest', 'nearest' )
NIDHOGG_ST_IMAGE:setFilter( 'nearest', 'nearest' )
NIDHOGG_H1_IMAGE:setFilter( 'nearest', 'nearest' )
NIDHOGG_H2_IMAGE:setFilter( 'nearest', 'nearest' )
NIDHOGG_D1_IMAGE:setFilter( 'nearest', 'nearest' )
NIDHOGG_D2_IMAGE:setFilter( 'nearest', 'nearest' )
NIDHOGG_D3_IMAGE:setFilter( 'nearest', 'nearest' )
NIDHOGG_D4_IMAGE:setFilter( 'nearest', 'nearest' )

NIDHOGG_ENEMY_IMAGE = love.graphics.newImage( 'resource//nidhogg//enemy.png', { mipmaps = true } )
NIDHOGG_ENEMY_IMAGE:setFilter( 'nearest', 'nearest' )

-- tower
NIDHOGG_TOWER_IMAGE = love.graphics.newImage( 'resource//nidhogg//tower.png', { mipmaps = true } )
NIDHOGG_TOWER_IMAGE:setFilter( 'nearest', 'nearest' )

-- distribution
NIDHOGG_DISTRIBUTION_IMAGE = love.graphics.newImage( 'resource//nidhogg//distribution.png', { mipmaps = true } )
NIDHOGG_DISTRIBUTION_IMAGE:setFilter( 'nearest', 'nearest' )

-- ground
NIDHOGG_GROUND_IMAGE = love.graphics.newImage( 'resource//nidhogg//ground_detailed.png', { mipmaps = true } )
NIDHOGG_GROUND_IMAGE:setFilter( 'nearest', 'nearest' )

-- debuffs
NIDHOGG_DEBUFF_RAND1_IMAGE = love.graphics.newImage( 'resource//nidhogg//debuff_rand1.png', { mipmaps = true } )
NIDHOGG_DEBUFF_RAND2_IMAGE = love.graphics.newImage( 'resource//nidhogg//debuff_rand2.png', { mipmaps = true } )
NIDHOGG_DEBUFF_RAND3_IMAGE = love.graphics.newImage( 'resource//nidhogg//debuff_rand3.png', { mipmaps = true } )
NIDHOGG_DEBUFF_HIGH_IMAGE = love.graphics.newImage( 'resource//nidhogg//debuff_high.png', { mipmaps = true } )
NIDHOGG_DEBUFF_ELUSIVE_IMAGE = love.graphics.newImage( 'resource//nidhogg//debuff_elusive.png', { mipmaps = true } )
NIDHOGG_DEBUFF_SPINE_IMAGE = love.graphics.newImage( 'resource//nidhogg//debuff_spine.png', { mipmaps = true } )
NIDHOGG_DEBUFF_RAND1_IMAGE:setFilter( 'nearest', 'nearest' )
NIDHOGG_DEBUFF_RAND2_IMAGE:setFilter( 'nearest', 'nearest' )
NIDHOGG_DEBUFF_RAND3_IMAGE:setFilter( 'nearest', 'nearest' )
NIDHOGG_DEBUFF_HIGH_IMAGE:setFilter( 'nearest', 'nearest' )
NIDHOGG_DEBUFF_ELUSIVE_IMAGE:setFilter( 'nearest', 'nearest' )
NIDHOGG_DEBUFF_SPINE_IMAGE:setFilter( 'nearest', 'nearest' )

-- marker
NIDHOGG_MARKER_RAND1_IMAGE = love.graphics.newImage( 'resource//nidhogg//marker_rand1.png', { mipmaps = true } )
NIDHOGG_MARKER_RAND2_IMAGE = love.graphics.newImage( 'resource//nidhogg//marker_rand2.png', { mipmaps = true } )
NIDHOGG_MARKER_RAND3_IMAGE = love.graphics.newImage( 'resource//nidhogg//marker_rand3.png', { mipmaps = true } )
NIDHOGG_MARKER_RAND1_IMAGE:setFilter( 'nearest', 'nearest' )
NIDHOGG_MARKER_RAND2_IMAGE:setFilter( 'nearest', 'nearest' )
NIDHOGG_MARKER_RAND3_IMAGE:setFilter( 'nearest', 'nearest' )

-- -- player
-- PLAYER_WIDTH= 40
-- PLAYER_HEIGHT= 40
-- PLAYER_BASE_SPEED= 100
-- PLAYER_IMAGE_PATH= 'resource//player.png'
-- PLAYER_JUMP_COOLTIME= 40

-- -- square
-- SQUARE_WIDTH= 40
-- SQUARE_HEIGHT= 40
-- SQUARE_IMAGE_PATH= 'resource//square.png'

-- -- triangle
-- TRIANGLE_EDGE_LENGTH= 40
-- TRIANGLE_IMAGE_PATH= 'resource//triangle.png'

-- -- circle
-- CIRCLE_RADIUS= 20
-- CIRCLE_IMAGE_PATH= 'resource//circle.png'

-- -- switch
-- SWITCH_WIDTH= 40
-- SWITCH_HEIGHT= 40

-- -- door
-- DOOR_WIDTH= 40
-- DOOR_HEIGHT= 40

-- -- goal
-- GOAL_WIDTH= 40
-- GOAL_HEIGHT= 40
-- GOAL_IMAGE_PATH= 'resource//black_hole.png'

-- -- text
-- TEXT_PRINT_TYPE_CENTER= 0
-- TEXT_PRINT_TYPE_UPPER_LEFT= 1

-- TEXT_PRINT_TYPES_LIST= {TEXT_PRINT_TYPE_CENTER, TEXT_PRINT_TYPE_UPPER_LEFT}

-- -- mouse
-- MOUSE_BUTTON_LEFT= 1
-- MOUSE_BUTTON_RIGHT= 2
-- MOUSE_BUTTON_MIDDLE= 3

-- -- hud
-- -- arrange objects GUI
-- HUD_ACTIVATE_ARRANGE_OBJECTS_BUTTON_X= 10
-- HUD_ACTIVATE_ARRANGE_OBJECTS_BUTTON_Y= 10
-- HUD_ACTIVATE_ARRANGE_OBJECTS_BUTTON_WIDTH= 40
-- HUD_ACTIVATE_ARRANGE_OBJECTS_BUTTON_HEIGHT= 40
-- HUD_ACTIVATE_ARRANGE_OBJECTS_BUTTON_TAG= 'activateArrangeObjectsButton'
-- HUD_ACTIVATE_ARRANGE_OBJECTS_BUTTON_IMAGE_PATH= 'resource//spanner.png'

-- -- background
-- BACKGROUND_IN_GAME= 'resource//background.png'

