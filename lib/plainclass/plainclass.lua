-- 一般的なクラス機能のほか、C#ライクなゲッター・セッターを実装する
--[[
example:

    local Class = require("lib.plainclass")
    local MyClass = Class:new()

    function MyClass:init()
        self.x = self.private(0)
        self.y = self.private(0)

        self.width = 0
        self.height = 0

        self.color = self.private({255, 255, 255})
        
    end
]] --
local Class = {}

function Class:new()
    local obj = {}

    setmetatable( obj, self )

    self.__index = self

    return obj
end


function Class:init()
    -- do nothing
end

