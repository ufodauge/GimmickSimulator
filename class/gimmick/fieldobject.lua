local GameInstance = require 'class.gameinstance'

local FieldObject = {}
setmetatable( FieldObject, { __index = GameInstance } )

function FieldObject:new( ... )
    local obj = GameInstance:new( ... )
    obj.superDelete = obj.delete

    setmetatable( obj, { __index = FieldObject } )

    return obj
end

function FieldObject:delete()
    self:superDelete()
    self = nil
end

return FieldObject
