---------------------------------------
-- Camera
---------------------------------------
print( 'Camera' )

local Class = require 'lib.30log.30log'

local Camera = Class( 'Camera' )
local Public = {}

function Public:getInstance()
    if Camera.singleton == nil then
        Camera.singleton = Camera()
    end

    assert( Camera.singleton ~= nil, 'Camera:getInstance() is not called yet.' )
    return Camera.singleton
end


-- Camera functions
function Camera:init()
    self._rotation = 0
    self._scale = 1
    self._x = 0
    self._y = 0

    -- HUD ならばカメラ処理に介入しないように設定
    self._HUD = false

    self._chase = false
    self._chasingSpeed = 7
end


function Camera:attach()
    if not self:isHUD() then
        love.graphics.push()
        love.graphics.rotate( -self._rotation )
        love.graphics.scale( 1 / self._scale, 1 / self._scale )
        love.graphics.translate( -self._x, -self._y )
    end
end


function Camera:detach()
    if not self:isHUD() then
        love.graphics.pop()
    end
end


function Camera:isHUD()
    return self._HUD
end


function Camera:moveTo( x, y )
    local cx, cy = self:position()
    local dx, dy = x - cx, y - cy
    if self._chase then
        dx, dy = dx * (self._chasingSpeed * 0.01), dy * (self._chasingSpeed * 0.01)
    end

    self:move( dx, dy )
end


return Public
