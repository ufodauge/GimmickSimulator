local Lume = require 'lib.lume'

local GameInstanceManager = {}
local Public = {}

GameInstanceManager.instanceList = {}
GameInstanceManager.debugMode = false

setmetatable( GameInstanceManager.instanceList, { __mode = 'vk' } )

function Public:getInstance()
    if GameInstanceManager.singleton == nil then
        GameInstanceManager.singleton = GameInstanceManager:new()
    end

    assert( GameInstanceManager.singleton ~= nil, 'GameInstanceManager:getInstance() is not called yet.' )
    return GameInstanceManager.singleton
end

function GameInstanceManager:add( ... )
    Lume.push( self.instanceList, ... )

    -- マネージャーへの登録
    local function sort( a, b )
        return a._drawPriority < b._drawPriority
    end

    Lume.filter( GameInstanceManager.instanceList, function( v )
        return v._drawPriority
    end )
    Lume.sort( GameInstanceManager.instanceList, sort )
end

function GameInstanceManager:updateAll( dt )
    for i, obj in pairs( GameInstanceManager.instanceList ) do
        if obj.update then
            obj:update( dt )
        end
        require( 'lib.debug' ):getInstance():setDebugInfo( tostring( obj ) )
    end

    -- 消滅しているオブジェクトはリストから除外
    Lume.filter( GameInstanceManager.instanceList, function( v )
        return v._drawPriority
    end )
end

function GameInstanceManager:drawAll()
    for i, obj in pairs( GameInstanceManager.instanceList ) do
        -- オブジェクトが無ければ処理しない
        if obj.draw then
            love.graphics.setColor( 1, 1, 1, 1 )

            obj:attachCamera()

            obj:draw()
            if GameInstanceManager.debugMode then
                obj:debugDraw()
            end

            obj:detachCamera()
        end

    end
end

function GameInstanceManager:DebugMode()
    GameInstanceManager.debugMode = true
end

function GameInstanceManager:deleteInstanceAll()
    for i, obj in pairs( GameInstanceManager.instanceList ) do
        obj:delete()
        obj = nil
    end
    GameInstanceManager.instanceList = {}
    collectgarbage()
end

function GameInstanceManager:deleteInstance( obj )
    print( 'GameInstanceManager:delete' )
    obj:delete()
    obj = nil

    Lume.filter( GameInstanceManager.instanceList, function( v )
        return v._drawPriority
    end )

    collectgarbage()
end

function GameInstanceManager:delete()
    self:deleteInstanceAll()
    self = nil
end

function GameInstanceManager:new()
    local obj = {}

    setmetatable( obj, { __index = GameInstanceManager } )

    return obj
end

return Public
