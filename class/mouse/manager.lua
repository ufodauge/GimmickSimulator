local MouseManager = {}

-- key:     入力するキー
-- func:    入力されたときに呼び出される関数
-- (prem:   前提となるキー)
-- (rep:    "repeat")
-- (act:    "pressed" or "released")
function MouseManager:add( ... )
    local keyboards = { ... }
    for i, keyboard in ipairs( keyboards ) do
        table.insert( self.keys, keyboard )
    end
end

function MouseManager:remove( ... )
    local keyboards = { ... }
    for i, keyboard in ipairs( keyboards ) do
        for j, key in ipairs( self.keys ) do
            if key == keyboard then
                table.remove( self.keys, j )
                break
            end
        end
    end
end

function MouseManager:update( dt )
    self.x, self.y = love.mouse.getPosition()
    for i, key in ipairs( self.keys ) do
        key:update( dt )
    end
    self.xBefore, self.yBefore = self.x, self.y
end

function MouseManager:getPositionBefore()
    return self.xBefore, self.yBefore
end

-- 初期化処理
function MouseManager:new()

    local obj = {}

    obj.keys = {}
    obj.x, obj.y = 0, 0
    obj.xBefore, obj.yBefore = 0, 0

    local wheelmove = love.wheelmoved or function( x, y )

    end

    function love.wheelmoved( x, y )
        wheelmove( x, y )
        for i, key in ipairs( obj.keys ) do
            key:updateWheelMoves( x, y )
        end
    end

    return setmetatable( obj, {
        __index = MouseManager,
        __tostring = function()
            return 'MouseManager'
        end
    } )
end

return MouseManager
