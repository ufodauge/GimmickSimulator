local path = ...
local Directory = {}

local Entry = require(path)

function Directory:add(entry)
    table.insert(self.entries, entry)

    return self
end

function Directory:remove()
    for i, entry in ipairs(self.entries) do
        entry:remove()
    end

    self = nil
end

function Directory.new(name)
    local directory = {}
    directory = Entry.new(name)

    directory.entries = {}

    setmetatable(directory, { __index = Directory })
end

return Directory
