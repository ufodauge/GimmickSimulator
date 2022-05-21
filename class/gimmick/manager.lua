local KeyManager = require 'class.keyboard.manager'
local Keyboard = require 'class.keyboard'

local GimmickManager = {}

function GimmickManager:update( dt )
    self._keyManager:update( dt )
end

function GimmickManager:start()

end

function GimmickManager:reset()

end

function GimmickManager:started()

end

function GimmickManager:add( sequence )

end

function GimmickManager:remove( sequence )
end

function GimmickManager:getSequences()

end

function GimmickManager:delete()

end

function GimmickManager:new()
    local obj = {}
    setmetatable( obj, { __index = GimmickManager } )

    obj._keyManager = KeyManager:new()

    return obj
end

return GimmickManager
