-- Class
local GameInstance = require 'class.gameinstance'

local AoE = {}
setmetatable( AoE, { __index = GameInstance } )

function AoE:delete()
    self:superDelete()
    self = nil
end

function AoE:new( args )
    local obj = GameInstance:new( args )
    obj.superDelete = obj.delete

    setmetatable( obj, { __index = AoE } )

    return obj
end

return AoE
