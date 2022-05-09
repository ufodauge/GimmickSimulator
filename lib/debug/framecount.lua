local Private = {}
local Public = {}

function Public:getInstance()
    if Private.instance == nil then
        Private.instance = Private.new()
    end

    assert( Private.instance ~= nil, 'GameInstance:getInstance() is not called yet.' )
    return Private.instance
end


function Private:update( dt )
    if self.active then
        self.frameCount = self.frameCount + 1
    end
end


function Private:stop()
    self.active = false
end


function Private:start()
    self.active = true
end


function Private:getFrame()
    return self.frameCount
end


function Private:reset()
    self.frameCount = 0
end


-- 初期化処理
function Private.new()
    local obj = {}

    obj.frameCount = 0
    obj.active = true

    setmetatable( obj, { __index = Private } )

    return obj
end


return Public
