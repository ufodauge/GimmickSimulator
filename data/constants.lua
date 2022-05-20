-- Image
PLAYER_IMAGE_MT = love.graphics.newImage( 'resource/image/player/mt.png', { mipmaps = true } )
PLAYER_IMAGE_ST = love.graphics.newImage( 'resource/image/player/st.png', { mipmaps = true } )
PLAYER_IMAGE_H1 = love.graphics.newImage( 'resource/image/player/h1.png', { mipmaps = true } )
PLAYER_IMAGE_H2 = love.graphics.newImage( 'resource/image/player/h2.png', { mipmaps = true } )
PLAYER_IMAGE_D1 = love.graphics.newImage( 'resource/image/player/d1.png', { mipmaps = true } )
PLAYER_IMAGE_D2 = love.graphics.newImage( 'resource/image/player/d2.png', { mipmaps = true } )
PLAYER_IMAGE_D3 = love.graphics.newImage( 'resource/image/player/d3.png', { mipmaps = true } )
PLAYER_IMAGE_D4 = love.graphics.newImage( 'resource/image/player/d4.png', { mipmaps = true } )

PLAYER_IMAGE_MT:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_ST:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_H1:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_H2:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_D1:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_D2:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_D3:setFilter( 'nearest', 'nearest' )
PLAYER_IMAGE_D4:setFilter( 'nearest', 'nearest' )

GROUND_IMAGE = love.graphics.newImage( 'resource/image/field/nidhogg.png', { mipmaps = true } )
GROUND_IMAGE:setFilter( 'nearest', 'nearest' )

-- Constants
PLAYER_SPEED = 2.5
PLAYER_ROT_SPEED = math.pi * 1.5
PLAYER_CAMERA_TILT = 180

-- AoE
AOE_COLOR_RED = 0.92
AOE_COLOR_GREEN = 0.84
AOE_COLOR_BLUE = 0.06
AOE_COLOR_ALPHA = 0.5
TRIGGERED_AOE_COLOR_RED = 0.7
TRIGGERED_AOE_COLOR_GREEN = 0.13
TRIGGERED_AOE_COLOR_BLUE = 0.13
TRIGGERED_AOE_COLOR_ALPHA = 0.5
AOE_TIMELAG_BETWEEN_UNDISPLAYED_AND_TRIGGERED = 0.5
TRIGGERED_AOE_DURATION = 0.3
AOE_FADEIN_DURATION = 0.3
AOE_FADEOUT_DURATION = 0.3
