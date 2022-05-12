---------- DO NOT CHANGE ----------
-- debug
local Lovebird = require 'lib.lovebird'

-- utility
-- local Lume = require 'lib.lume'
-----------------------------------

-- data
Data = {}
Data.Font = require 'data.font'
require 'data.defines'

-- independent library
Class = require 'lib.30log.30log'
Camera = require 'lib.hump.camera'
State = require 'lib.hump.gamestate'
Windfield = require 'lib.windfield'

----------------------------------------------------
-- state
States = {}
States.Dummy = require 'state.dummy'
States.Sandbox = require 'state.sandbox'
States.Nidhogg = require 'state.nidhogg'

-- PlainDebug
PlainDebug = require 'class.debug'

-- class
GameInstance = require 'class.gameinstance'
KeyManager = require 'class.keyManager'
MouseManager = require 'class.mouseManager'
Player = require 'class.player'
Ground = require 'class.ground'
GimmickManager = require 'class.gimmickManager'
AOE = require 'class.aoe'
DebuffList = require 'class.debufflist'
Debuff = require 'class.debuff'
SpellGauge = require 'class.spellgauge'
BattleTalkWindow = require 'class.battletalkwindow'
FieldMarker = require 'class.fieldmarker'
-- Tower = require 'class.tower'

-- instance
Debug = nil

function love.load()
    math.randomseed( os.time() )

    -- デバッグモードの有効化の際は true を渡すこと
    Debug = PlainDebug( true )
    Debug:changeFreeCameraConfig( 'numpad' )

    Debug:setDebugDrawToggler( GameInstance.toggleDebugMode, 'game_instance' )
    -- GameInstance:toggleDebugMode()

    State.registerEvents()
    State.switch( States.Nidhogg );
end


function love.update( dt )
    -- Debug
    Lovebird.update()
    Debug:update( dt )
    -- Debug

    GameInstance:updateAll( dt )
end


function love.draw()
    -- Debug
    Debug.free_camera:attach()
    GameInstance:drawAll()
    Debug.free_camera:detach()

    -- Debug
    Debug:draw()
    -- Debug
end


