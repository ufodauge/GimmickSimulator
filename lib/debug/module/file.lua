local path = ...
local Entry = require( path )

local File = {}

function File:doFunc( func )
    func()
end


function File.new( name, func )
    local file = Entry.new( name )

    file.func = func

    setmetatable( file, { __index = File } )

    return file
end


return File

