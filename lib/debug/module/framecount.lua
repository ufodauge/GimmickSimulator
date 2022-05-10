local Private = {}
local Public = {}

function Public:getInstance()
    if Private.instance == nil then
        Private.instance = Private.new()
    end

    assert(Private.instance ~= nil, 'GameInstance:getInstance() is not called yet.')
    return Private.instance
end

function Private:update(dt)
    if self.counting then
        self.frames = self.frames + 1
    end
end

function Private:stop()
    self.counting = false
end

function Private:start()
    self.counting = true
end

function Private:getFrame()
    return self.frames
end

function Private:reset()
    self.frames = 0
end

function Private:toggle()
    self.active = not self.active
end

function Private:getActive()
    return self.active
end

-- 初期化処理
function Private.new()
    local obj = {}

    obj.frames = 0
    obj.counting = true

    setmetatable(obj, { __index = Private })

    return obj
end

return Public
