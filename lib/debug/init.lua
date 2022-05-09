---------------------------------------
-- Debug
-- Q で表示および非表示を切り替え
---------------------------------------
local path = ... .. '.'
local FrameCount = require( path .. 'framecount' )
local FreeCamera = require( path .. 'camera' )
local KeyManager = require( path .. 'keymanager' )

-- lib

-- defines
local DEBUG_MENU_X = 20
local DEBUG_MENU_Y = 10
local DEBUG_INFO_X = 20
local DEBUG_INFO_Y = 400
local DEBUG_FRAMECOUNT_X = love.graphics.getWidth() - 200
local DEBUG_FRAMECOUNT_Y = 5
local DEBUG_FREECAMERA_X = love.graphics.getWidth() - 200
local DEBUG_FREECAMERA_Y = 25
local DEBUG_FONT_SIZE = 16
local DEBUG_FONT = love.graphics.newFont( 'resource/fixedsys-ligatures.ttf', DEBUG_FONT_SIZE )
DEBUG_FONT:setFilter( 'nearest', 'nearest' )

local DEBUG_CAMERA_MOVE_DISTANCE = 5

-- local functions
-- 影付きでテキスト出力
local function printWithShadow( text, x, y )
    love.graphics.setColor( 0.2, 0.2, 0.2, 1 )
    love.graphics.print( text, x + 1, y + 1 )
    love.graphics.print( text, x - 1, y + 1 )
    love.graphics.print( text, x + 1, y - 1 )
    love.graphics.print( text, x - 1, y - 1 )
    love.graphics.setColor( 1, 1, 1, 1 )
    love.graphics.print( text, x, y )
end


--------------------------------------------------
-- Class: Debug
local Private = {}
local Public = {}

function Public.getInstance()
    if Private.singleton == nil then
        Private.singleton = Private.new()
    end

    assert( Private.singleton ~= nil, 'Debug is not initialized.' )
    return Private.singleton
end


-- returns current directory
function Private:getCurrentDirectory()
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
function Private:cursorMove( up_down )
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
function Private:movePath( command )
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


function Private:update( dt )
    -- デバッグメニューが無効ならば更新しない
    if not self:isValid() then
        return
    end

    self.freeCamera:update( dt )

    -- フレーム総数の更新
    self.frameCount:update( dt )

    self.keyManager:update( dt )

end


function Private:draw()
    -- デバッグメニューが無効ならば描画しない
    if not self:isValid() then
        return
    end

    love.graphics.setFont( DEBUG_FONT )

    -- 現在のフレーム数を表示する
    if self.toggle.frameCount then
        printWithShadow( 'frame: ' .. tostring( self.frameCount:getFrame() ), DEBUG_FRAMECOUNT_X, DEBUG_FRAMECOUNT_Y )
    end

    if self.freeCamera:getActive() then
        local x, y = self.freeCamera:getPosition()
        printWithShadow( 'free camera: (' .. x .. ', ' .. y .. ')', DEBUG_FREECAMERA_X, DEBUG_FREECAMERA_Y )
    end

    -- デバッグメニューを表示する
    if self:isActive() then
        -- returns current path
        local dir = self:getCurrentDirectory()

        -- 選択肢の表示
        for i, content in ipairs( dir ) do
            printWithShadow( content.name, self.x, self.y + DEBUG_FONT_SIZE * (i - 1) )

            if self.path[#self.path] == i then
                printWithShadow( '>', self.x - 10, self.y + DEBUG_FONT_SIZE * (i - 1) )
            end
        end
    end

    self:printDebugInfo()
end


-- デバッグメニューの有効・無効状態の取得
function Private:isValid()
    return self.valid
end


-- デバッグメニューの表示
function Private:activate()
    self.active = true
end


-- デバッグメニューの非表示
function Private:deactivate()
    self.active = false
end


-- デバッグメニューの表示状態を取得
function Private:isActive()
    return self.active
end


function Private:setDebugDrawToggler( togglefunc, name )
    self.debugdrawTogglers = self.debugdrawTogglers or {}
    self.debugdrawTogglers[name] = togglefunc
end


function Private:toggleDebugDraw()
    self.debugdrawTogglers = self.debugdrawTogglers or {}

    for name, togglefunc in pairs( self.debugdrawTogglers ) do
        togglefunc()
    end
end


function Private:setDebugInfo( text )
    table.insert( self.debugTextList, text )
end


function Private:printDebugInfo()
    for index, text in ipairs( self.debugTextList ) do
        printWithShadow( index .. ': ' .. text, DEBUG_INFO_X, DEBUG_INFO_Y + DEBUG_FONT_SIZE * (index - 1) )
    end

    self.debugTextList = {}
end


function Private:changeFreeCameraConfig( type )
    self.freeCamera:changeConfig( type )
end


function Private:attachFreeCamera()
    self.freeCamera:attach()
end


function Private:detachFreeCamera()
    self.freeCamera:detach()
end


function Private:setDebugMode( bool )
    self.valid = bool
end


-- Private functions
function Private.new( valid )
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
        list = {},
        toggle = { frameCount = true, coordinateSystem = true },
        path = { 'root', 1 }

    }

    obj.list = {
        {
            attribute = 'dir',
            name = 'root',
            contents = {
                {
                    attribute = 'dir',
                    name = 'toggle',
                    contents = {
                        {
                            attribute = 'file',
                            name = 'frameCount',
                            contents = function()
                                obj.toggle.frameCount = not obj.toggle.frameCount
                            end


                        },
                        {
                            attribute = 'file',
                            name = 'freeCamera',
                            contents = function()
                                obj.freeCamera:toggle()
                            end


                        },
                        {
                            attribute = 'file',
                            name = 'debug_draw',
                            contents = function()
                                obj:toggleDebugDraw()
                            end


                        },
                        {
                            attribute = 'file',
                            name = 'return',
                            contents = function()
                                obj:movePath( '..' )
                            end


                        }
                    }
                },
                {
                    attribute = 'dir',
                    name = 'framecount',
                    contents = {
                        {
                            attribute = 'file',
                            name = 'reset',
                            contents = function()
                                obj.frameCount:reset()
                            end


                        },
                        {
                            attribute = 'file',
                            name = 'stop',
                            contents = function()
                                obj.frameCount:stop()
                            end


                        },
                        {
                            attribute = 'file',
                            name = 'start',
                            contents = function()
                                obj.frameCount:start()
                            end


                        },
                        {
                            attribute = 'file',
                            name = 'return',
                            contents = function()
                                obj:movePath( '..' )
                            end


                        }
                    }
                },
                {
                    attribute = 'dir',
                    name = 'freecamera',
                    contents = {
                        {
                            attribute = 'dir',
                            name = 'key config',
                            contents = {
                                {
                                    attribute = 'file',
                                    name = 'wasd',
                                    contents = function()
                                        obj.freeCamera:changeConfig( 'wasd' )
                                    end


                                },
                                {
                                    attribute = 'file',
                                    name = 'direction key',
                                    contents = function()
                                        obj.freeCamera:changeConfig( 'direction_key' )
                                    end


                                },
                                {
                                    attribute = 'file',
                                    name = 'numpad',
                                    contents = function()
                                        obj.freeCamera:changeConfig( 'numpad' )
                                    end


                                },
                                {
                                    attribute = 'file',
                                    name = 'return',
                                    contents = function()
                                        obj:movePath( '..' )
                                    end


                                }
                            }
                        },
                        {
                            attribute = 'file',
                            name = 'return',
                            contents = function()
                                obj:movePath( '..' )
                            end


                        }
                    }
                },
                { attribute = 'dir', name = 'state', contents = {} },
                {
                    attribute = 'file',
                    name = 'quit',
                    contents = function()
                        -- local currentState = State.current()
                        -- currentState.leave()
                        State.current().leave()

                        love.event.quit()
                    end


                },
                {
                    attribute = 'file',
                    name = 'return',
                    contents = function()
                        obj:deactivate()
                    end


                }
            }
        }
    }

    for i, content in ipairs( obj.list[1].contents ) do
        if content.name == 'state' then
            for j, state in pairs( States ) do
                table.insert( content.contents, {
                    attribute = 'file',
                    name = state.name,
                    contents = function()
                        -- if State.current() ~= state then
                        -- else
                        -- end
                        State.switch( state )
                    end


                } )
            end
            table.insert( content.contents, {
                attribute = 'file',
                name = 'return',
                contents = function()
                    obj:movePath( '..' )
                end


            } )
        end
    end

    obj.keyManager:register( {
        {
            key = 'pageup',
            func = function()
                -- 非表示の際は更新しない
                if not obj:isActive() then
                    return
                end

                -- 上方向への移動
                obj:cursorMove( 'up' )
            end
,
            rep = false,
            act = 'pressed'
        },
        {
            key = 'pagedown',
            func = function()
                -- 非表示の際は更新しない
                if not obj:isActive() then
                    return
                end

                -- 下方向への移動
                obj:cursorMove( 'down' )
            end
,
            rep = false,
            act = 'pressed'
        },
        {
            key = 'end',
            func = function()
                -- 非表示の際は更新しない
                if not obj:isActive() then
                    return
                end

                -- returns current dir
                local dir = obj:getCurrentDirectory()

                -- 決定時の具体的な処理
                if dir[obj.path[#obj.path]].attribute == 'file' then
                    dir[obj.path[#obj.path]].contents()
                elseif dir[obj.path[#obj.path]].attribute == 'dir' then
                    obj:movePath( obj.path[#obj.path] )
                end
            end
,
            rep = false,
            act = 'pressed'
        },
        {
            key = 'home',
            func = function()
                if obj:isActive() then
                    obj:deactivate()
                else
                    obj:activate()
                end
            end
,
            rep = false,
            act = 'pressed'
        },
        {
            key = 'kp8',
            func = function()
                obj.freeCamera:move( 0, -DEBUG_CAMERA_MOVE_DISTANCE )
            end
,
            rep = true
        },
        {
            key = 'kp2',
            func = function()
                obj.freeCamera:move( 0, DEBUG_CAMERA_MOVE_DISTANCE )
            end
,
            rep = true
        },
        {
            key = 'kp6',
            func = function()
                obj.freeCamera:move( DEBUG_CAMERA_MOVE_DISTANCE, 0 )
            end
,
            rep = true
        },
        {
            key = 'kp4',
            func = function()
                obj.freeCamera:move( -DEBUG_CAMERA_MOVE_DISTANCE, 0 )
            end
,
            rep = true
        }
    } )

    setmetatable( obj, { __index = Private } )

    return obj
end


return Public
