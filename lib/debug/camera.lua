-- フリーカメラ
local FreeCamera = {}

local keyconfigSet = {
    wasd = { { key = 'w' }, { key = 's' }, { key = 'd' }, { key = 'a' } },
    directionKey = { { key = 'up' }, { key = 'down' }, { key = 'right' }, { key = 'left' } },
    numpad = { { key = 'kp8' }, { key = 'kp2' }, { key = 'kp6' }, { key = 'kp4' } }
}

function FreeCamera:update( dt )

end


function FreeCamera:getActive()
    return self.active
end


function FreeCamera:getPosition()
    return self.camera.x, self.camera.y
end


function FreeCamera:attach()
    self.camera:attach()
end


function FreeCamera:detach()
    self.camera:detach()
end


function FreeCamera:toggle()
    self.active = not self.active
end


function FreeCamera:move( x, y )
    self.camera:move( x, y )
end


-- 初期化処理
function FreeCamera.new()
    local obj = {}

    obj.camera = Camera.new()
    obj.active = false

    setmetatable( obj, { __index = FreeCamera } )

    return obj
end


return FreeCamera
