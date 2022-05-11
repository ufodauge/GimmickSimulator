local EntryManager = {}

function EntryManager:rootDirectory()
    return self.root
end


function EntryManager:selectPrevEntry()
    if self.selected then
        self.selected = self.selected:prev()
    end
end


function EntryManager:selectNextEntry()
    if self.selected then
        self.selected = self.selected:next()
    end
end


function EntryManager:selectEntry( entry )
    self.selected = entry
end


function EntryManager.new( directory )
    local obj = {}

    obj.root = directory
    obj.selected = nil

    setmetatable( obj, { __index = EntryManager } )

    return obj
end


return EntryManager
