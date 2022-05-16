local GameInstance = require 'class.gameinstance'

local Ground = {}
setmetatable( Ground, { __index = GameInstance } )

function Ground:new( ... )
    local obj = GameInstance:new( ... )
    setmetatable( obj, { __index = Ground } )

    obj._superDelete = obj.delete

    return obj
end

function Ground:delete()
    self:_superDelete()
    self = nil
end

return Ground
