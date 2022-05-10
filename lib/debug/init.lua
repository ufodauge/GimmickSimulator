---------------------------------------
-- Debug
-- Q で表示および非表示を切り替え
---------------------------------------
local path = ... .. '.'

-- lib
local FrameCount = require(path .. 'module.framecount')
local FreeCamera = require(path .. 'module.camera')
local KeyManager = require(path .. 'module.keymanager')
local Directory = require(path .. 'module.directory')
local File = require(path .. 'module.file')

path = path:gsub('.', '/')
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
local DEBUG_FONT = love.graphics.newFont(path .. 'resource/fixedsys-ligatures.ttf', DEBUG_FONT_SIZE)
DEBUG_FONT:setFilter('nearest', 'nearest')

local DEBUG_CAMERA_MOVE_DISTANCE = 5

-- local functions
-- 影付きでテキスト出力
local function printWithShadow(text, x, y)
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.print(text, x + 1, y + 1)
    love.graphics.print(text, x - 1, y + 1)
    love.graphics.print(text, x + 1, y - 1)
    love.graphics.print(text, x - 1, y - 1)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(text, x, y)
end

--------------------------------------------------
-- Class: Debug
local Debug = {}
local Public = {}

function Public.getInstance()
    if Debug.singleton == nil then
        Debug.singleton = Debug.new()
    end

    assert(Debug.singleton ~= nil, 'Debug is not initialized.')
    return Debug.singleton
end

-- returns current directory
function Debug:getCurrentDirectory()
    local directory = self.list

    for i, name in ipairs(self.path) do
        if type(name) == type(1) then
            return directory
        end

        for j, dir in ipairs(directory) do
            if dir.name == name then
                directory = dir.contents
                break
            end
        end
    end
end

-- カーソルの移動
function Debug:cursorMove(up_down)
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
function Debug:movePath(command)
    -- returns current path
    local dir = self:getCurrentDirectory()

    -- 現在指している場所がフォルダなら移動　末尾なら戻る
    if command == '..' then
        table.remove(self.path)
        table.remove(self.path)
        table.insert(self.path, 1)
    elseif dir[self.path[#self.path]].attribute == 'dir' then
        table.insert(self.path, dir[self.path[#self.path]].name)
        table.remove(self.path, #self.path - 1)
        table.insert(self.path, 1)
    end

    print('movePath:')
    for i, v in ipairs(self.path) do
        print(i, v)
    end
end

function Debug:update(dt)
    -- デバッグメニューが無効ならば更新しない
    if not self:isValid() then
        return
    end

    self.keyManager:update(dt)
    self.freeCamera:update(dt)
    self.frameCount:update(dt)
end

function Debug:draw()
    -- デバッグメニューが無効ならば描画しない
    if not self:isValid() then
        return
    end

    love.graphics.setFont(DEBUG_FONT)

    -- 現在のフレーム数を表示する
    Debug:printOutlined(self.frameCount:getFrameCount(), DEBUG_FRAMECOUNT_X, DEBUG_FRAMECOUNT_Y)
    Debug:printOutlined(self.frameCount:getFps(), DEBUG_FRAMECOUNT_X, DEBUG_FRAMECOUNT_Y + DEBUG_FONT_SIZE)

    -- 現在のカメラ位置を表示する
    Debug:printOutlined(self.freeCamera:getPosition(), DEBUG_FREECAMERA_X, DEBUG_FREECAMERA_Y)


    -- 以下を書き換える ------------------------------------
    if self.toggle.frameCount then
        printWithShadow('frame: ' .. tostring(self.frameCount:getFrame()), DEBUG_FRAMECOUNT_X, DEBUG_FRAMECOUNT_Y)
    end

    if self.freeCamera:getActive() then
        local x, y = self.freeCamera:getPosition()
        printWithShadow('free camera: (' .. x .. ', ' .. y .. ')', DEBUG_FREECAMERA_X, DEBUG_FREECAMERA_Y)
    end
    --------------------------------------------------------

    -- デバッグメニューを表示する
    if self:isActive() then
        -- returns current path
        local dir = self:getCurrentDirectory()

        -- 選択肢の表示
        for i, content in ipairs(dir) do
            printWithShadow(content.name, self.x, self.y + DEBUG_FONT_SIZE * (i - 1))

            if self.path[#self.path] == i then
                printWithShadow('>', self.x - 10, self.y + DEBUG_FONT_SIZE * (i - 1))
            end
        end
    end

    self:printDebugInfo()
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

function Debug:setDebugDrawToggler(togglefunc, name)
    self.debugdrawTogglers = self.debugdrawTogglers or {}
    self.debugdrawTogglers[name] = togglefunc
end

function Debug:toggleDebugDraw()
    self.debugdrawTogglers = self.debugdrawTogglers or {}

    for name, togglefunc in pairs(self.debugdrawTogglers) do
        togglefunc()
    end
end

function Debug:setDebugInfo(text)
    table.insert(self.debugTextList, text)
end

function Debug:printDebugInfo()
    for index, text in ipairs(self.debugTextList) do
        printWithShadow(index .. ': ' .. text, DEBUG_INFO_X, DEBUG_INFO_Y + DEBUG_FONT_SIZE * (index - 1))
    end

    self.debugTextList = {}
end

function Debug:changeFreeCameraConfig(type)
    self.freeCamera:changeConfig(type)
end

function Debug:attachFreeCamera()
    self.freeCamera:attach()
end

function Debug:detachFreeCamera()
    self.freeCamera:detach()
end

function Debug:setDebugMode(bool)
    self.valid = bool
end

-- Debug functions
function Debug.new(valid)
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
        directory = Directory.new('root'),
        toggle = { frameCount = true, coordinateSystem = true },
        path = { 'root', 1 }

    }

    -- ディレクトリ構造
    do
        obj.directory:add(--
            Directory.new('toggle'):add(--
                File.new('frameCount', function()
                    obj.frameCount:toggle()
                end
                )):add(--
                File.new('freeCamera', function()
                    obj.freeCamera:toggle()
                end
                )):add(--
                File.new('return', function()
                    obj:movePath('..')
                end
                )))
        obj.directory:add(--
            Directory.new('framecount'):add(--
                File.new('reset', function()
                    obj.frameCount:reset()
                end
                )):add(--
                File.new('stop', function()
                    obj.frameCount:stop()
                end
                )):add(--
                File.new('start', function()
                    obj.frameCount:start()
                end
                )):add(--
                File.new('return', function()
                    obj:movePath('..')
                end
                )))
        obj.directory:add(--
            Directory.new('freecamera'):add(--
                Directory.new('key config'):add(--
                    File.new('wasd', function()
                        obj.freeCamera:changeConfig('wasd')
                    end
                    )):add(--
                    File.new('direction key', function()
                        obj.freeCamera:changeConfig('direction_key')
                    end
                    )):add(--
                    File.new('numpad', function()
                        obj.freeCamera:changeConfig('numpad')
                    end
                    )):add(--
                    File.new('return', function()
                        obj:movePath('..')
                    end
                    ))):add(--
                File.new('return', function()
                    obj:movePath('..')
                end
                )))

        local dirState = obj.directory:add(Directory.new('state'))
        obj.directory:add(--
            dirState
        )
        for j, state in pairs(States) do
            dirState:add(File.new(state.name, function()
                State.switch(state)
            end))
        end
        obj.directory:add(File.new('quit', function()
            love.event.quit()
        end))
        obj.directory:add(File.new('return', function()
            obj:deactivate()
        end))
    end

    -- 操作関数
    do
        obj.keyManager:add('pageup', function()
            -- 非表示の際は更新しない
            if not obj:isActive() then
                return
            end

            -- 上方向への移動
            obj:cursorMove('up')
        end, 'pressed')
        obj.keyManager:add('pagedown', function()
            -- 非表示の際は更新しない
            if not obj:isActive() then
                return
            end

            -- 下方向への移動
            obj:cursorMove('down')
        end, 'pressed')
        obj.keyManager:add('end', function()
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
                obj:movePath(obj.path[#obj.path])
            end
        end, 'pressed')
        obj.keyManager:add('home', function()
            if obj:isActive() then
                obj:deactivate()
            else
                obj:activate()
            end
        end,
            'pressed')
        obj.keyManager:add('kp8', function()
            obj.freeCamera:move(0, -DEBUG_CAMERA_MOVE_DISTANCE)
        end, 'repeat', 'pressed')
        obj.keyManager:add('kp2', function()
            obj.freeCamera:move(0, DEBUG_CAMERA_MOVE_DISTANCE)
        end, 'repeat', 'pressed')
        obj.keyManager:add('kp4', function()
            obj.freeCamera:move(-DEBUG_CAMERA_MOVE_DISTANCE, 0)
        end, 'repeat', 'pressed')
        obj.keyManager:add('kp6', function()
            obj.freeCamera:move(DEBUG_CAMERA_MOVE_DISTANCE, 0)
        end, 'repeat', 'pressed')
    end

    setmetatable(obj, { __index = Debug })

    return obj
end

return Public
