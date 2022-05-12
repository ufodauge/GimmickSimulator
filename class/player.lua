local Lume = require 'lib.lume'
local Angle = require( 'class.angle' )

local GameInstance = require 'class.gameinstance'
local gameInstance = GameInstance:getInstance()

local Player = gameInstance:extend( 'Player' )

function Player:init( name, image, settings )
    -- Player.super:init( self )
    self.super:init( self ) -- weak point

    -- 一般的な座標系での偏角
    self.front_direction = Angle( math.pi / 2 )
    self.aiming_direction = Angle( math.pi / 2 )

    self.x = settings.x
    self.y = settings.y

    self.dir_x = 0
    self.dir_y = 0

    self.goal_x = 0
    self.goal_y = 0
    self.goaled = true

    self.hitStatus = false

    self.targetScale = self.camera:getScale()
    self.limitScale = { min = 0.5, max = 2 }

    if name then
        self.name = name
    end

    if image then
        self:setImage( image )
    end

    self.debuffs = {}

    self.keys = KeyManager()
    self.keys:register( {
        {
            key = 'w',
            func = function()
                self:move( 0, PLAYER_SPEED )
            end
,
            rep = true,
            act = 'pressed'
        },
        {
            key = 'd',
            func = function()
                self:move( PLAYER_SPEED, 0 )
            end
,
            rep = true,
            act = 'pressed'
        },
        {
            key = 's',
            func = function()
                self:move( 0, -PLAYER_SPEED )
            end
,
            rep = true,
            act = 'pressed'
        },
        {
            key = 'a',
            func = function()
                self:move( -PLAYER_SPEED, 0 )
            end
,
            rep = true,
            act = 'pressed'
        }
    } )

    self.mouseManager = MouseManager()
    self.mouseManager:register( {
        {
            -- 左クリック
            key = 1,
            func = function()
                print( 'left click' )
            end
,
            act = 'pressed'
        }
    } )
    self.mouseManager:setWheelMovedFunc( function( x, y )
        local mul = math.pow( 2, y * 0.1 )

        self.camera:zoomIn( mul )

        if self.camera:getScale() < self.limitScale.min then
            self.camera:zoomTo( self.limitScale.min )
        elseif self.camera:getScale() > self.limitScale.max then
            self.camera:zoomTo( self.limitScale.max )

        end
    end
, 'zoomInOut' )

    self.camera:useBoundingBox( false )
    self.camera:setChase( false )

end


function Player:move( x, y )
    self.dir_x = self.dir_x + x
    self.dir_y = self.dir_y + y

    -- 目的向きを測定
    self.aiming_direction:set( math.atan2( self.dir_y, self.dir_x ) )
end


-- 目標位置に向かって移動
function Player:moveTo( x, y )
    self.goal_x = x
    self.goal_y = y
    self.goaled = false

    print( 'move to (' .. x .. ', ' .. y .. ')' .. 'from (' .. self.x .. ', ' .. self.y .. ')' )
end


function Player:getDirection()
    return self.front_direction:get()
end


function Player:getName()
    return self.name

end


function Player:getDebuff( name )
    for i, debuff in ipairs( self.debuffs ) do
        if debuff:getName() == name then
            return debuff
        end
    end
    return nil
end


function Player:hit( other )
    print( 'hit' )
    self.hitStatus = true
end


function Player:isHit()
    return self.hitStatus
end


function Player:addDebuff( debuff )
    print( 'add debuff: ' .. tostring( debuff ) .. ' to ' .. self.name )
    table.insert( self.debuffs, debuff )
end


function Player:removeDebuff( debuff )
    for i, v in ipairs( self.debuffs ) do
        if v == debuff then
            table.remove( self.debuffs, i )
            -- debuff:delete()
        end
    end
end


function Player:setMe( bool )
    self.me = bool

end


function Player:isMe()
    return self.me
end


function Player:setSequence( sequence )
    self.sequence = sequence
end


function Player:doSequence( dt )
    if self.sequence then
        self.sequence:doSequence( dt )
    end
end


function Player:update( dt )

    if self.me then

        self.keys:update( dt )
        self.mouseManager:update( dt )

        self.camera:moveTo( self.x, self.y )

        if self.dir_x ~= 0 and self.dir_y ~= 0 then
            self.dir_x = self.dir_x / math.sqrt( 2 )
            self.dir_y = self.dir_y / math.sqrt( 2 )
        end
    else
        -- 自然に移動させたかったが難航したので次回版でよろしくお願いします
        -- if not self.goaled then
        --     local dx = self.goal_x - self.x
        --     local dy = self.goal_y - self.y
        --     self:move( dx, dy )

        --     local is_near = Lume.distance( self.x, self.y, self.goal_x, self.goal_y ) < 10
        --     if is_near then
        --         print( 'goal', Lume.distance( self.x, self.y, self.goal_x, self.goal_y ) )
        --         self.goaled = true
        --     end
        -- end
    end

    self:setPosition( self.x + self.dir_x, self.y - self.dir_y )

    -- 目的向きを測定
    -- self.aiming_direction:set( math.atan2( self.dir_x, self.dir_y ) )

    -- 現在の向きを dt * pi 度ずつ回転させ、目的向きに近づくようにする
    -- 右から回転させたほうが早いか否かを判断する
    local aiming, front = self.aiming_direction, self.front_direction
    -- -pi < diff < pi
    local diff = aiming - front

    -- 回転角
    local amplitude = 0
    if math.abs( diff:get() ) <= math.pi / 192 then
        amplitude = 0
    elseif math.abs( diff:get() ) >= dt * math.pi then
        -- amplitude = dt * PLAYER_ROT_SPEED
        amplitude = diff:get() > 0 and dt * PLAYER_ROT_SPEED or -dt * PLAYER_ROT_SPEED
    else
        amplitude = diff:get()
    end

    front:set( front:get() + amplitude )

    -- 向きを更新
    self.rot = -front:get() + math.pi / 2

    -- reset
    self.dir_x = 0
    self.dir_y = 0

    for i, debuff in pairs( self.debuffs ) do
        Debug:setDebugInfo( self:getName() .. ': ' .. debuff:getName() )
        debuff:update( dt )
        if debuff.deleted then
            self:removeDebuff( debuff )
        end
    end
end


function Player:draw()
    self.super.draw( self )

    for i, debuff in pairs( self.debuffs ) do
        if debuff.marker and debuff:isMarkerDisplaying() then
            local x0, y0 = self:getPosition()
            local w, h = debuff.marker:getDimensions()

            love.graphics.draw( debuff.marker, x0 - w / 2, y0 - h )

        end
    end
end


function Player:delete()
    self.super:delete( self ) -- selfを明示的に書いてあげる必要あり
end


return Player
