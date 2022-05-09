local DebuffList = Class( 'DebuffList' )

function DebuffList:init()
    self.debuffs = {}

    self.x, self.y = 150, 10
    self.scale = 1
end


function DebuffList:update( dt )
    for i, debuff in pairs( self.debuffs ) do

        if debuff.deleted then
            print( 'debuff is deleted' )
            self:remove( debuff )
        end
    end
end


function DebuffList:draw()
    for i, debuff in pairs( self.debuffs ) do
        debuff:draw( self.x - HUD_DEBUFF_ICON_SIZE * i, self.y, self.scale )
    end
end


function DebuffList:add( debuff )
    table.insert( self.debuffs, debuff )
end


function DebuffList:remove( debuff )
    for i, v in ipairs( self.debuffs ) do
        if v == debuff then
            table.remove( self.debuffs, i )
        end
    end
end


function DebuffList:delete()
    self.debuffs = nil
end


return DebuffList
