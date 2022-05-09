local InstanceCamera = require 'class.gameinstance.camera'

local GameInstance = Class( 'GameInstance' )

local instance_list = {}
local debug_mode = false

setmetatable( instance_list, { __mode = 'k' } )

local singleton = nil

function GameInstance:getInstance()
    if singleton == nil then
        singleton = GameInstance:new()
    end

    assert( singleton ~= nil, 'GameInstance:getInstance() is not called yet.' )
    return singleton
end


function GameInstance:init( obj )
    print( 'GameInstance:init' )
    -- マネージャーへの登録
    table.insert( instance_list, obj )

    -- 描画優先度の指定
    -- 高いほど上側に描画される
    self.draw_priority = 0

    -- カメラ
    self.camera = InstanceCamera()

    -- 初期位置
    -- この位置は基本的にオブジェクトの中心で考える
    self.x, self.y = 0, 0
    self.scale = 1
    self.rot = 0
end


function GameInstance:updateAll( dt )
    -- 親クラスでなければ処理しない
    -- if not self:subclassOf(GameInstance) then
    --     return
    -- end

    for i, obj in pairs( instance_list ) do
        if obj.update then
            obj:update( dt )
        end

        -- リストから除外 じゃあな
        -- えっなにこれきたねえ
        if not obj.instanceOf then
            table.remove( instance_list, i )
        end
    end
end


function GameInstance:drawAll()
    -- 親クラスでなければ処理しない
    -- if not self:subclassOf(GameInstance) then
    --     return
    -- end

    love.graphics.setColor( 1, 1, 1, 1 )
    for i, obj in pairs( instance_list ) do
        -- オブジェクトが無ければ処理しない
        if obj.draw then
            obj.camera:attach()
            obj:draw()
            obj.camera:detach()
        end

    end
end


local function sort( a, b )
    return a.draw_priority < b.draw_priority
end


function GameInstance:setPriority( draw_priority )
    self.draw_priority = draw_priority

    table.sort( instance_list, sort )
end


function GameInstance:setPosition( x, y )
    self.x, self.y = x, y
end


function GameInstance:getPosition()
    return self.x, self.y
end


function GameInstance:setSize( w, h )
    self.width, self.height = w, h
end


function GameInstance:getSize()
    return self.width, self.height
end


function GameInstance:setScale( scale )
    self.scale = scale
end


function GameInstance:getScale()
    return self.scale
end


-- オブジェクトの左上の位置を返す
function GameInstance:getOrigin()
    return self.x - self.width / 2, self.y - self.height / 2
end


function GameInstance:setImage( ImageObject )
    self.ImageObject = ImageObject
    self.width, self.height = ImageObject:getWidth(), ImageObject:getHeight()
end


function GameInstance:draw()
    if self.ImageObject then
        local x0, y0 = self:getOrigin()
        local w, h = self:getSize()
        -- x0, y0 = x0 + love.graphics.getWidth() / 2, y0 + love.graphics.getHeight() / 2

        love.graphics.push()
        love.graphics.translate( x0 + w / 2, y0 + h / 2 )
        love.graphics.scale( self.scale )
        love.graphics.rotate( self.rot )
        love.graphics.setColor( 1, 1, 1, 1 )
        love.graphics.draw( self.ImageObject, -w / 2, -h / 2 )
        love.graphics.pop()
    end

    if debug_mode then
        self:debugDraw()
    end
end


function GameInstance:debugDraw()
    local x0, y0 = self:getOrigin()
    local x, y = self:getPosition()
    local w, h = self:getSize()
    -- x0, y0 = x0 + love.graphics.getWidth() / 2, y0 + love.graphics.getHeight() / 2
    -- x, y = x + love.graphics.getWidth() / 2, y + love.graphics.getHeight() / 2

    love.graphics.push()
    love.graphics.translate( x0 + w / 2, y0 + h / 2 )
    love.graphics.scale( self.scale )
    love.graphics.rotate( self.rot )
    love.graphics.setColor( 1, 0, 0, 1 )
    love.graphics.rectangle( 'line', -w / 2, -h / 2, w, h )
    love.graphics.setColor( 1, 1, 1, 0.25 )
    love.graphics.rectangle( 'fill', -w / 2, -h / 2, w, h )
    love.graphics.pop()

    love.graphics.setColor( 1, 0, 0, 1 )
    love.graphics.circle( 'line', x, y, HITBOX_RADIUS )

end


function GameInstance:toggleDebugMode()

    debug_mode = not debug_mode
end


function GameInstance:delete( obj )
    print( 'GameInstance:delete' )
    setmetatable( obj, { __mode = 'k' } )
    obj = nil
end


return GameInstance
