local GimmickManager = Class( 'GimmickManager' )
local alreadyStarted = false

local keyManager = KeyManager()

function GimmickManager:init()

    self.gimmicks = {}

    keyManager:register( {
        {
            key = 'space',
            func = function()
                if not alreadyStarted then
                    self:reset()
                    self:start()
                else
                    self:reset()
                end
            end
,
            act = 'pressed'
        }
    } )
end


function GimmickManager:update( dt )
    keyManager:update( dt )

    for i, gimmick in pairs( self.gimmicks ) do

        if gimmick:isTriggering() then
            local isPlayerSuffering = gimmick:isInTheArea( self.player:getPosition() )

            if isPlayerSuffering then
                self.player:hit()

            end
        end

        local px, py = self.player:getPosition()
        -- Debug:setDebugInfo( tostring( gimmick:isInTheArea( px, py ) ) )
    end

end


function GimmickManager:start()
    if alreadyStarted then
        return
    end
    print( 'GimmickManager:start' )
    alreadyStarted = true

    for i, gimmick in pairs( self.gimmicks ) do
        if gimmick.start then
            gimmick:start()
        end
    end
end


function GimmickManager:reset()
    print( 'GimmickManager:reset' )
    alreadyStarted = false
    for i, gimmick in pairs( self.gimmicks ) do
        if gimmick.reset then
            gimmick:stop()
            gimmick:reset()
        end
    end
end


function GimmickManager:setPlayer( player )
    self.player = player
end


function GimmickManager:isWorking()
    return self.alreadyStarted
end


function GimmickManager:add( gimmick )
    table.insert( self.gimmicks, gimmick )
end


function GimmickManager:remove( gimmick )
    for i, g in pairs( self.gimmicks ) do
        if g == gimmick then
            table.remove( self.gimmicks, i )
        end
    end
end


function GimmickManager:delete()
    for i, gimmick in pairs( self.gimmicks ) do
        if gimmick.delete then
            gimmick:delete()
        end
    end
    self.gimmicks = {}

end


return GimmickManager
