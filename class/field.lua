local GameInstance = require 'class.gameinstance'

local Ground = {}
setmetatable( Ground, { __index = GameInstance } )

function Ground:new( ... )
  local obj = GameInstance:new( ... )
  obj.superDelete = obj.delete

  return setmetatable( obj, { __index = Ground } )
end

function Ground:delete()
  self:superDelete()
  self = nil
end

return Ground
