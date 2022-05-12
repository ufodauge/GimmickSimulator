local path = ...
path = path:gsub( path:gsub( '(%w+%.)', '' ), '' )

local Entry = require( path .. 'entry' )

local File = {}
setmetatable( File, { __index = Entry } )

function File:execute()
    self.func()
end


function File.new( name, func )
    local obj = Entry.new( name )

    obj.func = func

    setmetatable( obj, { __index = File } )

    return obj
end


return File

