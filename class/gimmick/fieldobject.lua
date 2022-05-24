local GameInstance = require 'class.gameinstance'

local FieldObject = {}
setmetatable( FieldObject, { __index = GameInstance } )

function FieldObject:delete()
    self:superDelete()
    self = nil
end

function FieldObject:new( ... )
    local obj = GameInstance:new( ... )
    obj.superDelete = obj.delete

    return setmetatable( obj, {
        __index = FieldObject,
        __tostring = function()
            return 'FieldObject'
        end
    } )
end

return FieldObject
