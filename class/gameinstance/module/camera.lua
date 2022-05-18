---------------------------------------
-- Camera
---------------------------------------
local Camera = {}
local Public = {}

function Public:getInstance( chase, chasingSpeed )
    if Camera.singleton == nil then
        Camera.singleton = Camera:new( chase, chasingSpeed )
    end

    assert( Camera.singleton ~= nil, 'Camera:getInstance() is not called yet.' )
    return Camera.singleton
end

function Camera:attach()
    love.graphics.push()
    love.graphics.translate( self._cx, self._cy )
    love.graphics.scale( self._scale )
    love.graphics.rotate( self._rotation )
    love.graphics.translate( -self._x, self._y )
end

function Camera:detach()
    love.graphics.pop()
end

function Camera:position()
    return self._x, self._y
end

function Camera:move( dx, dy )
    self._x = self._x + dx
    self._y = self._y + dy
end

function Camera:moveTo( x, y )
    local cx, cy = self:position()
    local dx, dy = x - cx, y - cy
    if self._chase then
        dx, dy = dx * (self._chasingSpeed * 0.01), dy * (self._chasingSpeed * 0.01)
    end

    self:move( dx, dy )
end

function Camera:rotate( rot )
    self._rotation = self._rotation + rot
end

function Camera:rotation()
    return self._rotation
end

function Camera:zoom( rate )
    self._scale = self._scale * rate
end

function Camera:zoomTo( scale, smooth, smoothrate )
    smoothrate = smoothrate or 0.1
    scale = smooth and self._scale + (scale - self._scale) * smoothrate or scale
    self._scale = scale
end

function Camera:getZoomScale()
    return self._scale
end

function Camera:setCameraCenter( x, y )
    self._cx = x
    self._cy = y
end

function Camera:update( dt )

end

-- Camera functions
function Camera:new( chase, chasingSpeed )
    local obj = {}

    obj._rotation = 0
    obj._scale = 1
    obj._x = 0
    obj._y = 0
    obj._cx = love.graphics.getWidth() / 2
    obj._cy = love.graphics.getHeight() / 2

    obj._chase = chase or false
    obj._chasingSpeed = chasingSpeed or 7

    setmetatable( obj, { __index = Camera } )

    return obj
end

return Public
