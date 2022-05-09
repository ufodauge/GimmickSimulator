local FrameCount = {}

function FrameCount:update( dt )
    if self.active then
        self.frameCount = self.frameCount + 1
    end
end


function FrameCount:stop()
    self.active = false
end


function FrameCount:start()
    self.active = true
end


function FrameCount:getFrame()
    return self.frameCount
end


function FrameCount:reset()
    self.frameCount = 0
end


-- 初期化処理
function FrameCount.new()
    local obj = {}

    obj.frameCount = 0
    obj.active = true

    setmetatable( obj, { __index = FrameCount } )

    return obj
end


return FrameCount

-- リリース時の処理の追加！！！！
