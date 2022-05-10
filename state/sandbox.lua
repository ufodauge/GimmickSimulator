local TestInstance = require 'class.testinstance'
local GIManager = require 'class.gameinstance.manager'

local sandbox = {}

local gim = GIManager:getInstance()
local test = nil

sandbox.name = 'sandbox'

function sandbox:enter()
    local image = love.graphics.newImage( 'resource/nidhogg/DPSRole.png', { mipmaps = true } )
    image:setFilter( 'nearest', 'nearest' )

    test = TestInstance( { image = image, x = 100, y = -100 } )
end


function sandbox:update( dt )
    if love.keyboard.isDown( 'p' ) then
        test:delete()
    end
end


function sandbox:draw()

end


function sandbox:leave()
    gim:deleteInstanceAll()
end


return sandbox
