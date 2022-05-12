---------------------------------------
-- Debug
-- Q で表示および非表示を切り替え
---------------------------------------
local path = ... .. '.'

-- lib
local FrameCount = require( path .. 'module.framecount' )
local FreeCamera = require( path .. 'module.camera' )
local KeyManager = require( path .. 'module.keymanager' )
local Directory = require( path .. 'module.directory' )
local File = require( path .. 'module.file' )
local EntryManager = require( path .. 'module.entrymanager' )
local Cursor = require( path .. 'module.cursor' )

path = path:gsub( '%.', '/' )
-- defines
local DEBUG_MENU_X = 20
local DEBUG_MENU_Y = 10
local DEBUG_INFO_X = 20
local DEBUG_INFO_Y = 400
local DEBUG_FRAMECOUNT_X = love.graphics.getWidth() - 200
local DEBUG_FRAMECOUNT_Y = 5
local DEBUG_TEXT_HEIGHT = 16
local DEBUG_FONT_SIZE = 16
local DEBUG_FONT = love.graphics.newFont( path .. 'resource/fixedsys-ligatures.ttf', DEBUG_FONT_SIZE )
DEBUG_FONT:setFilter( 'nearest', 'nearest' )

local DEBUG_CAMERA_MOVE_DISTANCE = 5

-- local functions
-- 縁取りテキスト出力
local function printOutlined( text, x, y, ... )
    local args = { ... }
    local limit, align = args[1], args[2]

    love.graphics.setColor( 0.2, 0.2, 0.2, 1 )
    if limit then
        love.graphics.printf( text, x + 1, y + 1, limit, align )
        love.graphics.printf( text, x - 1, y + 1, limit, align )
        love.graphics.printf( text, x + 1, y - 1, limit, align )
        love.graphics.printf( text, x - 1, y - 1, limit, align )
        love.graphics.printf( text, x, y, limit, align )
    else
        love.graphics.print( text, x + 1, y + 1 )
        love.graphics.print( text, x - 1, y + 1 )
        love.graphics.print( text, x + 1, y - 1 )
        love.graphics.print( text, x - 1, y - 1 )
        love.graphics.print( text, x, y )
    end
    love.graphics.setColor( 1, 1, 1, 1 )
end


--------------------------------------------------
-- Class: Debug
local Debug = {}
local Public = {}

function Public.getInstance()
    if Debug.singleton == nil then
        Debug.singleton = Debug.new()
    end

    assert( Debug.singleton ~= nil, 'Debug is not initialized.' )
    return Debug.singleton
end


function Debug:printDebugMenu( x, y )
    if not self:isActive() then
        return
    end

    -- デバッグメニュー
    self.entryManager:print( x, y, DEBUG_TEXT_HEIGHT )
    self.cursor:print( x, y, DEBUG_TEXT_HEIGHT )

end


function Debug:update( dt )
    -- デバッグメニューが無効ならば更新しない
    if not self:isAvailable() then
        return
    end

    self.keyManager:update( dt )
    self.freeCamera:update( dt )
    self.frameCount:update( dt )
end


function Debug:draw()
    -- デバッグメニューが無効ならば描画しない
    if not self:isAvailable() then
        return
    end

    love.graphics.setFont( DEBUG_FONT )

    -- 現在のフレーム数/FPSを表示する
    love.graphics.push()
    love.graphics.setColor( 1, 1, 1, 1 )
    love.graphics.translate( DEBUG_FRAMECOUNT_X, DEBUG_FRAMECOUNT_Y )
    self.frameCount:printFrames( 0, 0 )
    self.frameCount:printFps( 0, 0 + DEBUG_TEXT_HEIGHT )
    self.freeCamera:printCenterPosition( 0, 0 + DEBUG_TEXT_HEIGHT * 2 )
    love.graphics.pop()

    -- デバッグメニュー表示
    self:printDebugMenu( DEBUG_MENU_X, DEBUG_MENU_Y )
    self:printDebugInfo( DEBUG_INFO_X, DEBUG_INFO_Y )
end


-- デバッグメニューの有効・無効状態の取得
function Debug:isAvailable()
    return self.available
end


-- デバッグメニューの表示
function Debug:showDebugMenu()
    self.showing = true
end


-- デバッグメニューの非表示
function Debug:hideDebugMenu()
    self.showing = false
end


-- デバッグメニューの表示状態を取得
function Debug:isActive()
    return self.showing
end


function Debug:setDebugInfo( text )
    table.insert( self.debugTextList, text )
end


function Debug:printDebugInfo( x, y )
    for index, text in ipairs( self.debugTextList ) do
        printOutlined( index .. ': ' .. text, DEBUG_INFO_X, DEBUG_INFO_Y + DEBUG_FONT_SIZE * (index - 1) )
    end

    self.debugTextList = {}
end


function Debug:changeFreeCameraConfig( type )
    self.freeCamera:changeConfig( type )
end


function Debug:attachFreeCamera()
    self.freeCamera:attach()
end


function Debug:detachFreeCamera()
    self.freeCamera:detach()
end


function Debug:Enable()
    self.available = true
end


function Debug:moveParent()
    self.pointer = self.pointer:getParent()
    self.cursor:move( self.pointer:getIndex() )
end


-- Debug functions
function Debug.new( available )
    local obj = {
        frameCount = FrameCount.getInstance(),
        freeCamera = FreeCamera.getInstance(),
        keyManager = KeyManager.getInstance(),

        -- インスタンス変数
        -- x, y:        座標
        -- available:       デバッグメニューを有効化するか否か
        -- showing:      スクリーン表示させるか否か
        -- list:        選択肢のリスト
        -- frameCount: フレームカウント
        -- index:       選択中のインデックス
        x = DEBUG_MENU_X,
        y = DEBUG_MENU_Y,
        available = available or false,
        showing = false,
        debugTextList = {},
        entryManager = EntryManager.new( Directory.new( 'root' ) ),
        cursor = Cursor:getInstance()
    }

    obj.entryManager:addObserver( obj.cursor:getObserver() )

    -- ディレクトリ構造
    do
        local root = obj.entryManager:rootDirectory()

        root:add( Directory.new( 'toggle' ) )
        root:getEntry( 'toggle' ):add( File.new( 'frameCount', function()
            obj.frameCount:toggle()
        end
 ) )
        root:getEntry( 'toggle' ):add( File.new( 'freeCamera', function()
            obj.freeCamera:toggle()
        end
 ) )
        root:getEntry( 'toggle' ):add( File.new( 'return', function()
            obj:moveParent()
        end
 ) )

        root:add( Directory.new( 'frameCount' ) )
        root:getEntry( 'frameCount' ):add( File.new( 'reset', function()
            obj.frameCount:reset()
        end
 ) )
        root:getEntry( 'frameCount' ):add( File.new( 'stop', function()
            obj.frameCount:stop()
        end
 ) )
        root:getEntry( 'frameCount' ):add( File.new( 'start', function()
            obj.frameCount:start()
        end
 ) )
        root:getEntry( 'frameCount' ):add( File.new( 'return' ) )

        root:add( Directory.new( 'freeCamera' ) )
        root:getEntry( 'freeCamera' ):add( Directory.new( 'keyconfig' ) )
        root:getEntry( 'freeCamera' ):getEntry( 'keyconfig' ):add( File.new( 'wasd', function()
            obj.freeCamera:changeConfig( 'wasd' )
        end
 ) )
        root:getEntry( 'freeCamera' ):getEntry( 'keyconfig' ):add( File.new( 'dirkey', function()
            obj.freeCamera:changeConfig( 'dirkey' )
        end
 ) )
        root:getEntry( 'freeCamera' ):getEntry( 'keyconfig' ):add( File.new( 'numpad', function()
            obj.freeCamera:changeConfig( 'numpad' )
        end
 ) )
        root:getEntry( 'freeCamera' ):getEntry( 'keyconfig' ):add( File.new( 'return', function()
            obj:moveParent()
        end
 ) )
        root:getEntry( 'freeCamera' ):add( File.new( 'return' ) )

        root:add( Directory.new( 'state' ) )
        for j, state in pairs( States ) do
            root:getEntry( 'state' ):add( File.new( state.name, function()
                State.switch( state )
            end
 ) )
        end
        root:getEntry( 'state' ):add( File.new( 'return', function()
            obj:moveParent()
        end
 ) )

        root:add( File.new( 'quit', function()
            love.event.quit()
        end
 ) )

        root:add( File.new( 'return', function()
            obj:hideDebugMenu()
        end
 ) )

        obj.entryManager:selectEntry( root:getEntry( 'toggle' ) )
    end

    -- 現在指し示しているエントリを設定
    -- obj.pointer = obj.directory:getEntry( 'toggle' )

    -- 操作関数
    do
        obj.keyManager:add( 'pageup', function()
            -- 非表示の際は更新しない
            if not obj:isActive() then
                return
            end

            -- カーソルの上方向への移動
            -- ポインタで一つ手前のエントリに移動する
            obj.entryManager:selectPrevEntry()
        end
, 'pressed' )
        obj.keyManager:add( 'pagedown', function()
            -- 非表示の際は更新しない
            if not obj:isActive() then
                return
            end

            -- 下方向への移動
            obj.entryManager:selectNextEntry()
        end
, 'pressed' )
        obj.keyManager:add( 'end', function()
            -- 非表示の際は更新しない
            if not obj:isActive() then
                return
            end

            -- 最後に選択したものに移動or実行
            obj.entryManager:execute()
        end
, 'pressed' )
        obj.keyManager:add( 'home', function()
            if obj:isActive() then
                obj:hideDebugMenu()
            else
                obj:showDebugMenu()
            end
        end
, 'pressed' )
        obj.keyManager:add( 'kp8', function()
            obj.freeCamera:move( 0, -DEBUG_CAMERA_MOVE_DISTANCE )
        end
, 'repeat', 'pressed' )
        obj.keyManager:add( 'kp2', function()
            obj.freeCamera:move( 0, DEBUG_CAMERA_MOVE_DISTANCE )
        end
, 'repeat', 'pressed' )
        obj.keyManager:add( 'kp4', function()
            obj.freeCamera:move( -DEBUG_CAMERA_MOVE_DISTANCE, 0 )
        end
, 'repeat', 'pressed' )
        obj.keyManager:add( 'kp6', function()
            obj.freeCamera:move( DEBUG_CAMERA_MOVE_DISTANCE, 0 )
        end
, 'repeat', 'pressed' )
    end

    setmetatable( obj, { __index = Debug } )

    return obj
end


return Public
