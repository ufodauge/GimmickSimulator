---------- DO NOT CHANGE ----------
-- debug
local Lovebird = require 'lib.lovebird'
-----------------------------------

-- independent library
---@diagnostic disable-next-line: different-requires
Class = require 'lib.30log.30log'
Camera = require 'lib.hump.camera'
State = require 'lib.hump.gamestate'

----------------------------------------------------
-- state
States = {}
States.Dummy = require 'state.dummy'
States.Sandbox = require 'state.sandbox'

-- PlainDebug
local PlainDebug = require 'lib.debug'

-- class
local GameInstance = require 'class.gameinstance'
-- KeyManager = require 'class.keyManager'
-- MouseManager = require 'class.mouseManager'
Player = require 'class.player'

-- instance
local debug = PlainDebug:getInstance()
local gameInstance = GameInstance:getInstance()

function love.load()
    math.randomseed( os.time() )

    -- デバッグモードの有効化の際は true を渡す
    debug:setDebugMode( true )
    -- debug:changeFreeCameraConfig( 'numpad' )

    -- debug:setDebugDrawToggler( GameInstance.toggleDebugMode, 'game_instance' )
    gameInstance:toggleDebugMode()

    local player = Player( 'MT', NIDHOGG_MT_IMAGE, { x = -350, y = 0 } )

    State.registerEvents()
    State.switch( States.Dummy );
end


function love.update( dt )
    -- debug
    Lovebird.update()
    debug:update( dt )
    -- debug

    gameInstance:updateAll( dt )
end


function love.draw()
    -- debug
    debug:attachFreeCamera()
    gameInstance:drawAll()
    debug:detachFreeCamera()

    -- debug
    debug:draw()
    -- debug
end


