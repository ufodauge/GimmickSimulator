---------------------------------------
-- InstanceCamera
---------------------------------------
local InstanceCamera = Class( 'InstanceCamera' )

-- Defines
local cursor_width, cursor_height = 32, 32
local __camera = nil

local __limits = { x = 0, y = 0, w = love.graphics.getWidth(), h = love.graphics.getHeight() }
local __use_limits = true

-- local functions
local function define_limits( limits )
    __limits.left_x = limits.x + love.graphics.getWidth() / 2
    __limits.right_x = limits.x + limits.w - love.graphics.getWidth() / 2
    __limits.above_y = limits.y + love.graphics.getHeight() / 2
    __limits.bottom_y = limits.y + limits.h - love.graphics.getHeight() / 2
end


define_limits( __limits )

-- InstanceCamera functions
function InstanceCamera:init()
    __camera = __camera or Camera.new()

    -- HUD ならばカメラ処理に介入しないように設定
    self.mode_HUD = false

    self.mode_chase = true
    self.chasing_speed = 7
end


function InstanceCamera:setBoundingBox( x, y, w, h )
    -- test
    if w <= love.graphics.getWidth() or h <= love.graphics.getHeight() then
        print( 'invalid Input in InstanceCamera:setBoundingBox()' )
        return
    end

    __limits = { x = x, y = y, w = w, h = h }
    define_limits( __limits )
end


function InstanceCamera:useBoundingBox( bool )
    __use_limits = bool
end


function InstanceCamera:attach()
    if not self:isHUD() then
        __camera:attach()
    end
end


function InstanceCamera:detach()
    if not self:isHUD() then
        __camera:detach()
    end
end


function InstanceCamera:setHUD( bool )
    self.mode_HUD = bool
end


function InstanceCamera:isHUD()
    return self.mode_HUD
end


function InstanceCamera:setChase( bool )
    self.mode_chase = bool
end


function InstanceCamera:setChaseSpeed( speed )
    self.chasing_speed = speed
end


function InstanceCamera:isChase()
    return self.mode_chase
end


function InstanceCamera:moveTo( x, y )
    if __use_limits then
        -- test and modify x y
        x = x <= __limits.left_x and __limits.left_x or x
        x = x >= __limits.right_x and __limits.right_x or x
        y = y <= __limits.above_y and __limits.above_y or y
        y = y >= __limits.bottom_y and __limits.bottom_y or y
    end

    local cx, cy = __camera:position()
    local dx, dy = x - cx, y - cy
    if self.mode_chase then
        dx, dy = dx * (self.chasing_speed * 0.01), dy * (self.chasing_speed * 0.01)
    end

    __camera:move( dx, dy )
end


function InstanceCamera:setPosition( x, y )
    __camera:lookAt( x, y )
end


function InstanceCamera:zoomIn( scale )
    scale = scale or 1.1
    __camera:zoom( scale )
end


function InstanceCamera:zoomOut( scale )
    scale = scale or 1.1
    __camera:zoom( 1 / scale )
end


function InstanceCamera:zoomTo( scale )
    __camera:zoomTo( scale )
end


function InstanceCamera:getScale()
    return __camera.scale
end


function InstanceCamera:reset()
    __camera = nil
end


return InstanceCamera
