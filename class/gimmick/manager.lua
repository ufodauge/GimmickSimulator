local KeyManager = require 'class.keyboard.manager'
local Keyboard = require 'class.keyboard'
local GIManager = require( 'class.gameinstance.manager' ):getInstance()

local GimmickManager = {}

function GimmickManager:update( dt )
end

function GimmickManager:updateObserver( event )
    if event.name == 'stop' then
        self:deleteGimmicks()
    end
end

function GimmickManager:getObserver()
    return self._observer
end

function GimmickManager:add( gimmick )
    GIManager:add( gimmick )
    table.insert( self._gimmicks, gimmick )
end

function GimmickManager:remove( gimmick )
    for i, g in pairs( self._gimmicks ) do
        if g == gimmick then
            table.remove( self._gimmicks, i )
        end
    end
end

function GimmickManager:deleteGimmicks()
    for i, g in pairs( self._gimmicks ) do
        if g.delete then
            g:delete()
            g = nil
        end
    end
end

function GimmickManager:getGimmicks()
    return unpack( self._gimmicks )
end

function GimmickManager:delete()
    for i, gimmick in pairs( self._gimmicks ) do
        if gimmick.delete then
            gimmick:delete()
            gimmick = nil
        end
    end
    self._gimmicks = {}
end

function GimmickManager:new()
    local obj = {}
    setmetatable( obj, { __index = GimmickManager } )

    obj._gimmicks = {}

    return obj
end

return GimmickManager
