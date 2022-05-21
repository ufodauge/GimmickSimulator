-- Class
local GameInstance = require 'class.gameinstance'

local Dummy = {}
setmetatable( Dummy, { __index = GameInstance } )

function Dummy:delete()
    self:_superDelete()
    self = nil
end

function Dummy:new( args )
    local obj = GameInstance:new( args )
    obj._superDelete = obj.delete

    setmetatable( obj, { __index = Dummy } )

    return obj
end

return Dummy
