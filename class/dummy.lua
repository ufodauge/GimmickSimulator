-- Class
local GameInstance = require 'class.gameinstance'

local Dummy = {}
setmetatable( Dummy, { __index = GameInstance } )

function Dummy:delete()
    self:superDelete()
    self = nil
end

function Dummy:new( args )
    local obj = GameInstance:new( args )

    setmetatable( obj, { __index = Dummy } )
    obj.superDelete = obj.delete

    return obj
end

return Dummy
