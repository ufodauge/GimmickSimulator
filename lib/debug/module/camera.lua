local Camera = require 'lib.hump.camera'
local printOutlined = require( 'module.utils' ).printOutlined

-- フリーカメラ
local Private = {}
local Public = {}

function Public:getInstance()
    if Private.instance == nil then
        Private.instance = Private.new()
    end

    assert( Private.instance ~= nil, 'GameInstance:getInstance() is not called yet.' )
    return Private.instance
end


local keyconfigSet = {
    wasd = { { key = 'w' }, { key = 's' }, { key = 'd' }, { key = 'a' } },
    directionKey = { { key = 'up' }, { key = 'down' }, { key = 'right' }, { key = 'left' } },
    numpad = { { key = 'kp8' }, { key = 'kp2' }, { key = 'kp6' }, { key = 'kp4' } }
}

function Private:update( dt )

end


function Private:getActive()
    return self.active
end


function Private:getPosition()
    return self.camera.x, self.camera.y
end


function Private:printCenterPosition( x, y )
    if self:getActive() then
        local px, py = self:getPosition()

        printOutlined( string.format( 'x: %.2f, y: %.2f', px, py ), x, y )
    end
end


function Private:attach()
    self.camera:attach()
end


function Private:detach()
    self.camera:detach()
end


function Private:toggle()
    self.active = not self.active
end


function Private:move( x, y )
    self.camera:move( x, y )
end


-- 初期化処理
function Private.new()
    local obj = {}

    obj.camera = Camera.new()
    obj.active = true

    setmetatable( obj, { __index = Private } )

    return obj
end


return Public
