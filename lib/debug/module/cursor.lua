local Cursor = {}
local Public = {}

local instance = nil

function Public:getInstance()
    if instance == nil then
        instance = Cursor.new()
    end

    assert(instance ~= nil, 'Cursor:getInstance() is not called yet.')
    return instance
end

function Cursor.new(font, x, y)
    local obj = {}

    obj.x = x
    obj.y = y

    setmetatable(obj, { __index = Cursor })

    return obj
end

return Cursor
