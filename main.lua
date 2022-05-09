---------- DO NOT CHANGE ----------
-- debug
local Lovebird = require 'lib.lovebird'
-----------------------------------

-- independent library
---@diagnostic disable-next-line: different-requires
-- Class = require 'lib.30log.30log'
-- Camera = require 'lib.hump.camera'
State = require 'lib.hump.gamestate'

----------------------------------------------------
-- state
States = {}
States.Dummy = require 'state.dummy'
States.Sandbox = require 'state.sandbox'

-- PlainDebug
local PlainDebug = require 'lib.debug'

-- class
local GIManager = require 'class.gimanager'
-- KeyManager = require 'class.keyManager'
-- MouseManager = require 'class.mouseManager'

-- instance
local debug = PlainDebug:getInstance()
local gim = GIManager:getInstance()

function love.load()
    math.randomseed( os.time() )

    -- デバッグモードの有効化の際は true を渡す
    debug:setDebugMode( true )
    -- debug:changeFreeCameraConfig( 'numpad' )

    -- debug:setDebugDrawToggler( GIManager.toggleDebugMode, 'game_instance' )
    gim:toggleDebugMode()

    State.registerEvents()
    State.switch( States.Sandbox );
end


function love.update( dt )
    -- debug
    Lovebird.update()
    debug:update( dt )
    -- debug

    gim:updateAll( dt )
end


function love.draw()
    -- debug
    debug:attachFreeCamera()
    gim:drawAll()
    debug:detachFreeCamera()

    -- debug
    debug:draw()
    -- debug
end


