---------- DO NOT CHANGE ----------
-- debug
local Lovebird = require 'lib.lovebird'
-----------------------------------

-- independent library
State = require 'lib.hump.gamestate'

-- data
require 'data.constants'

----------------------------------------------------
-- state
States = {}
States.Dummy = require 'state.dummy'
-- States.Sandbox = require 'state.sandbox'
States.Sandbox2 = require 'state.sandbox2'
States.Warthoftheheavens = require 'state.woth'
States.Deathoftheheavens = require 'state.doth'

-- PlainDebug
local PlainDebug = require( 'lib.debug' ):getInstance()

-- class
local GIManager = require( 'class.gameinstance.manager' ):getInstance()

function love.load()
  math.randomseed( os.time() )

  PlainDebug:Enable()

  -- GIManager:DebugMode()

  State.registerEvents()
  State.switch( States.Deathoftheheavens );
end

function love.update( dt )
  -- PlainDebug
  Lovebird.update()
  PlainDebug:update( dt )
  -- PlainDebug

  GIManager:updateAll( dt )

  if love.keyboard.isDown( 'escape' ) then
    love.event.quit()
  end
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

