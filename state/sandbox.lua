local TestInstance = require 'class.testinstance'
local GIManager = require 'class.gimanager'

local sandbox = {}

local gim = GIManager:getInstance()
local test = TestInstance()

sandbox.name = 'sandbox'

function sandbox:init()

end


function sandbox:enter()
    test:setPosition( 100, -100 )
    test:setImage( love.graphics.newImage( 'resource/nidhogg/DPSRole.png' ) )

end


function sandbox:update( dt )
    if love.keyboard.isDown( 's' ) then
        test:delete()
    end
end


function sandbox:draw()

end


function sandbox:leave()
    gim:deleteInstanceAll()
end


return sandbox
