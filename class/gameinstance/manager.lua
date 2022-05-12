local Class = require 'lib.30log.30log'
local Camera = require 'lib.hump.camera'

local GameInstanceManager = Class( 'GameInstanceManager' )
local Public = {}

GameInstanceManager.instanceList = {}
GameInstanceManager.debugMode = false

setmetatable( GameInstanceManager.instanceList, { __mode = 'k' } )

function Public:getInstance()
    if GameInstanceManager.singleton == nil then
        GameInstanceManager.singleton = GameInstanceManager:new()
    end

    assert( GameInstanceManager.singleton ~= nil, 'GameInstanceManager:getInstance() is not called yet.' )
    return GameInstanceManager.singleton
end


function GameInstanceManager:init()
    print( 'GameInstanceManager:init' )

    -- カメラ
    self.camera = Camera()
end


function GameInstanceManager:add( obj )
    -- マネージャーへの登録
    table.insert( GameInstanceManager.instanceList, obj )
end


local function filter( tbl, func )
    local out = {}
    for k, v in pairs( tbl ) do
        if func( v ) then
            out[k] = v
        end
    end
    return out

end


function GameInstanceManager:updateAll( dt )
    local function sort( a, b )
        return a.drawPriority < b.drawPriority
    end


    table.sort( GameInstanceManager.instanceList, sort )

    for i, obj in pairs( GameInstanceManager.instanceList ) do
        if obj.update then
            obj:update( dt )
        end

    end

    -- 消滅しているオブジェクトはリストから除外
    GameInstanceManager.instanceList = filter( GameInstanceManager.instanceList, function( obj )
        return obj
    end
 )
end


function GameInstanceManager:drawAll()
    for i, obj in pairs( GameInstanceManager.instanceList ) do
        -- オブジェクトが無ければ処理しない
        if obj.draw then
            love.graphics.setColor( 1, 1, 1, 1 )

            self.camera:attach()

            obj:draw()
            if GameInstanceManager.debugMode then
                obj:debugDraw()
            end

            self.camera:detach()
        end

    end
end


function GameInstanceManager:toggleDebugMode()
    GameInstanceManager.debugMode = not GameInstanceManager.debugMode
end


function GameInstanceManager:delete( obj )
    print( 'GameInstanceManager:delete' )
    setmetatable( obj, { __mode = 'k' } )
    obj = nil
end


return Public
