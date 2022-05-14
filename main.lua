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
-- States.Sandbox = require 'state.sandbox'

-- PlainDebug
local PlainDebug = require( 'lib.debug' ):getInstance()

-- class
local GIManager = require( 'class.gameinstance.manager' ):getInstance()
-- KeyManager = require 'class.keyManager'
-- MouseManager = require 'class.mouseManager'

function love.load()
    math.randomseed( os.time() )

    PlainDebug:Enable()

    GIManager:DebugMode()

    State.registerEvents()
    State.switch( States.Dummy );
end


function love.update( dt )
    -- PlainDebug
    Lovebird.update()
    PlainDebug:update( dt )
    -- PlainDebug

    GIManager:updateAll( dt )
end


function love.draw()
    -- PlainDebug
    PlainDebug:attachFreeCamera()
    GIManager:drawAll()
    PlainDebug:detachFreeCamera()

    -- PlainDebug
    love.graphics.setColor( 1, 1, 1, 1 )
    PlainDebug:draw()
    -- PlainDebug
end


