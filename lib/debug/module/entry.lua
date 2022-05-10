local Entry = {}

function Entry:getName()
    return self.name
end


function Entry:getPath()
    return self.path
end


function Entry:remove()
    self = nil
end


function Entry.new( name )
    local entry = {}

    entry.name = name

    setmetatable( entry, { __index = Entry } )

    return entry
end


return Entry
