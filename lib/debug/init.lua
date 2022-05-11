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
    local args = ...
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


-- returns current directory
function Debug:getCurrentDirectory()
    local directory = self.list

    for i, name in ipairs( self.path ) do
        if type( name ) == type( 1 ) then
            return directory
        end

        for j, dir in ipairs( directory ) do
            if dir.name == name then
                directory = dir.contents
                break
            end
        end
    end
end


-- カーソルの移動
function Debug:cursorMove( up_down )
    local dir = self:getCurrentDirectory()

    -- カーソルの上への移動
    if up_down == 'up' and self.path[#self.path] > 1 then
        self.path[#self.path] = self.path[#self.path] - 1
    end

    if up_down == 'down' and self.path[#self.path] < #dir then
        self.path[#self.path] = self.path[#self.path] + 1
    end
end


-- メニュー遷移処理
function Debug:movePath( command )
    -- returns current path
    local dir = self:getCurrentDirectory()

    -- 現在指している場所がフォルダなら移動　末尾なら戻る
    if command == '..' then
        table.remove( self.path )
        table.remove( self.path )
        table.insert( self.path, 1 )
    elseif dir[self.path[#self.path]].attribute == 'dir' then
        table.insert( self.path, dir[self.path[#self.path]].name )
        table.remove( self.path, #self.path - 1 )
        table.insert( self.path, 1 )
    end

    print( 'movePath:' )
    for i, v in ipairs( self.path ) do
        print( i, v )
    end
end


function Debug:printCurrentDirectory( x, y )
    local directory = self:getCurrentDirectory()

end


function Debug:printDebugMenu( x, y )
    if not self:isActive() then
        return
    end

    -- デバッグメニュー

    -- self.pointer:printCurrentDirectory( x, y )
    -- self.pointer:printCursor( x, y )
end


function Debug:update( dt )
    -- デバッグメニューが無効ならば更新しない
    if not self:isValid() then
        return
    end

    self.keyManager:update( dt )
    self.freeCamera:update( dt )
    self.frameCount:update( dt )
end


function Debug:draw()
    -- デバッグメニューが無効ならば描画しない
    if not self:isValid() then
        return
    end

    love.graphics.setFont( DEBUG_FONT )

    -- 現在のフレーム数/FPSを表示する
    love.graphics.push()
    love.graphics.translate( DEBUG_FRAMECOUNT_X, DEBUG_FRAMECOUNT_Y )
    self.frameCount:printFrames( 0, 0 )
    self.frameCount:printFps( 0, 0 + DEBUG_TEXT_HEIGHT )
    self.freeCamera:printCenterPosition( 0, 0 + DEBUG_TEXT_HEIGHT * 2 )
    love.graphics.pop()

    -- デバッグメニュー表示
    self:printDebugMenu( DEBUG_MENU_X, DEBUG_MENU_Y )
    self:printDebugInfo( DEBUG_INFO_X, DEBUG_INFO_Y )

    -- デバッグメニューを表示する
    -- if self:isActive() then
    --     -- returns current path
    --     local dir = self:getCurrentDirectory()

    --     -- 選択肢の表示
    --     for i, content in ipairs( dir ) do
    --         printWithShadow( content.name, self.x, self.y + DEBUG_FONT_SIZE * (i - 1) )

    --         if self.path[#self.path] == i then
    --             printWithShadow( '>', self.x - 10, self.y + DEBUG_FONT_SIZE * (i - 1) )
    --         end
    --     end
    -- end

end


-- デバッグメニューの有効・無効状態の取得
function Debug:isValid()
    return self.valid
end


-- デバッグメニューの表示
function Debug:activate()
    self.active = true
end


-- デバッグメニューの非表示
function Debug:deactivate()
    self.active = false
end


-- デバッグメニューの表示状態を取得
function Debug:isActive()
    return self.active
end


function Debug:setDebugDrawToggler( togglefunc, name )
    self.debugdrawTogglers = self.debugdrawTogglers or {}
    self.debugdrawTogglers[name] = togglefunc
end


function Debug:toggleDebugDraw()
    self.debugdrawTogglers = self.debugdrawTogglers or {}

    for name, togglefunc in pairs( self.debugdrawTogglers ) do
        togglefunc()
    end
end


function Debug:setDebugInfo( text )
    table.insert( self.debugTextList, text )
end


function Debug:printDebugInfo( x, y )
    for index, text in ipairs( self.debugTextList ) do
        printWithShadow( index .. ': ' .. text, DEBUG_INFO_X, DEBUG_INFO_Y + DEBUG_FONT_SIZE * (index - 1) )
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


function Debug:setDebugMode( bool )
    self.valid = bool
end


function Debug:moveParent()
    self.pointer = self.pointer:getParent()
    self.cursor:move( self.pointer:getIndex() )
end


-- Debug functions
function Debug.new( valid )
    local obj = {
        frameCount = FrameCount.getInstance(),
        freeCamera = FreeCamera.getInstance(),
        keyManager = KeyManager.getInstance(),

        -- インスタンス変数
        -- x, y:        座標
        -- valid:       デバッグメニューを有効化するか否か
        -- active:      スクリーン表示させるか否か
        -- list:        選択肢のリスト
        -- frameCount: フレームカウント
        -- index:       選択中のインデックス
        x = DEBUG_MENU_X,
        y = DEBUG_MENU_Y,
        valid = valid or false,
        active = false,
        debugTextList = {},
        entryManager = EntryManager.new( Directory.new( 'root' ) ),
        toggle = { frameCount = true, coordinateSystem = true },
        pointer = nil
    }

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
            obj:moveParent()
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
            -- obj.pointer = obj.pointer:prev()
            -- obj.cursor:move( obj.pointer:getIndex() )
        end
, 'pressed' )
        obj.keyManager:add( 'pagedown', function()
            -- 非表示の際は更新しない
            if not obj:isActive() then
                return
            end

            -- 下方向への移動
            obj.entryManager:selectNextEntry()
            -- obj.pointer = obj.pointer:next()
            -- obj.cursor:move( obj.pointer:getIndex() )
        end
, 'pressed' )
        obj.keyManager:add( 'end', function()
            -- 非表示の際は更新しない
            if not obj:isActive() then
                return
            end

            -- 最後に選択したものに移動or実行

            -- returns current dir
            obj.entryManager:executeEntry()
            -- if obj.pointer:isDirectory() then
            --     obj.pointer = obj.pointer:getEntry()
            --     obj.cursor:move( obj.pointer:getIndex() )
            -- else
            --     obj.pointer:execute()
            -- end

        end
, 'pressed' )
        obj.keyManager:add( 'home', function()
            if obj:isActive() then
                obj:deactivate()
            else
                obj:activate()
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
