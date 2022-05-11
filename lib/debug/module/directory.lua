local path = ...
local Directory = {}

local Entry = require( path )

function Directory:add( entry )
    table.insert( self.entries, entry )

    if self.first == nil then
        self.first = entry
    end

    if self.last == nil then
        self.last = entry
    end

    entry.prev = self.last
    entry.next = nil

    self.last.next = entry
    self.last = entry

    entry.index = #self.entries

    if entry:isDirectory() then
        entry.parent = self
    end

    return self
end


function Directory:remove()
    for i, entry in ipairs( self.entries ) do
        entry:remove()
    end

    self = nil
end


function Directory:getEntry( name )
    if name == nil then
        return self.first
    end

    for i, entry in ipairs( self.entries ) do
        if entry:getName() == name then
            return entry
        end
    end
end


function Directory:getEntries()
    return self.entries
end


function Directory:getFirst()
    return self.first
end


function Directory:getLast()
    return self.last
end


function Directory:getParent()
    return self.parent
end


function Directory.new( name )
    local directory = {}
    directory = Entry.new( name )

    directory.entries = {}

    directory.first = nil
    directory.last = nil

    directory.parent = nil
    directory.child = nil

    setmetatable( directory, { __index = Directory } )
end


return Directory
