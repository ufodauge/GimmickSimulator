-- Love2d Mesh
local function makeVertices( src, xc, yc )
    local xyuv = {}
    local xi, yi, u, v = 0, 0, 0, 0
    yi = 0
    for yi = 0, yc do
        v = yi / yc
        local sx0 = (src[4][1] - src[1][1]) * v + src[1][1]
        local sy0 = (src[4][2] - src[1][2]) * v + src[1][2]
        local sx1 = (src[3][1] - src[2][1]) * v + src[2][1]
        local sy1 = (src[3][2] - src[2][2]) * v + src[2][2]
        for xi = 0, xc do
            u = xi / xc
            local x = (sx1 - sx0) * u + sx0
            local y = (sy1 - sy0) * u + sy0
            table.insert( xyuv, { x, y, u, v } )
        end
    end
    local vidx = {}
    for y = 1, yc do
        for x = 1, xc do
            local i0 = x + ((xc + 1) * (y - 1))
            local i1 = i0 + 1
            local i2 = i0 + (xc + 1)
            local i3 = i2 + 1
            table.insert( vidx, i0 )
            table.insert( vidx, i1 )
            table.insert( vidx, i2 )
            table.insert( vidx, i2 )
            table.insert( vidx, i1 )
            table.insert( vidx, i3 )
        end
    end
    local vt = {}
    for j = 1, #vidx do
        local i = vidx[j]
        local x, y, u, v
        x, y = xyuv[i][1], xyuv[i][2]
        u, v = xyuv[i][3], xyuv[i][4]
        table.insert( vt, { x, y, u, v, 1.0, 1.0, 1.0, 1.0 } )
    end
    return vt, xyuv
end


local mesh_refresh = false
local wdw_w, wdw_h = love.graphics.getDimensions()
local img = nil
local divide = 3
local src = nil
local srcorig = nil
local vert, xyuv = nil, nil
local mesh = nil
local guide = nil
local ang = 0

local sandbox = {}
sandbox.name = 'sandbox'

-- init
function sandbox:enter()
    -- get window width and height
    wdw_w, wdw_h = love.graphics.getDimensions()
    img = love.graphics.newImage( 'resource/nidhogg/DPSRole.png', { mipmaps = true } )
    divide = 3
    -- src = { {270, 40}, {370, 40}, {620, 440}, {20, 440} }
    -- src = { { 270, 20 }, { 370, 60 }, { 620, 350 }, { 20, 440 } }
    src = { { 270, 240 }, { 370, 240 }, { 630, 460 }, { 10, 460 } }
    srcorig = { { 270, 240 }, { 370, 240 }, { 630, 460 }, { 10, 460 } }
    vert, xyuv = makeVertices( src, divide, divide )
    mesh = love.graphics.newMesh( vert, 'triangles' )
    mesh:setTexture( img )
    guide = true
    mesh_refresh = false
    ang = 0
end


-- update
function sandbox:update( dt )
    if mesh_refresh then
        vert, xyuv = makeVertices( src, divide, divide )
        mesh = love.graphics.newMesh( vert, 'triangles' )
        mesh:setTexture( img )
    end
    ang = ang + 90 * dt
    local d = 140 * math.sin( math.rad( ang ) )
    -- change x0, x1
    src[1][1] = 270 - 150 + d
    src[2][1] = 370 + 150 - d
    vert, xyuv = makeVertices( src, divide, divide )
    mesh:setVertices( vert, 1 )
end


-- draw
function sandbox:draw()
    -- fill BG color
    love.graphics.setColor( 0.1, 0.2, 0.4 )
    love.graphics.rectangle( 'fill', 0, 0, wdw_w, wdw_h )
    -- draw mesh
    love.graphics.setColor( 1, 1, 1 )
    love.graphics.draw( mesh, 0, 0 )
    if guide then
        -- draw lines
        love.graphics.setColor( 1, 1, 1, 0.5 )
        for i = 1, #vert, 3 do
            local vlst = { vert[i][1], vert[i][2], vert[i + 1][1], vert[i + 1][2], vert[i + 2][1], vert[i + 2][2] }
            love.graphics.polygon( 'line', vlst )
        end
        -- draw points
        love.graphics.setColor( 0, 1, 1, 0.5 )
        for i = 1, #xyuv do
            local x = xyuv[i][1]
            local y = xyuv[i][2]
            love.graphics.ellipse( 'line', x, y, 3, 3 )
        end
    end
    -- print FPS
    love.graphics.setColor( 1, 1, 1 )
    love.graphics.print( 'FPS: ' .. tostring( love.timer.getFPS() ), 2, 2 )
    love.graphics.print( 'Divide: ' .. tostring( divide ), 2, 20 )
    love.graphics.print( 'G key : Guide on/off', 2, 40 )
    love.graphics.print( 'Up, Down : Divide +/-', 2, 60 )

    for i = 1, #srcorig do
        love.graphics.circle( 'line', srcorig[i][1], srcorig[i][2], 3 )
    end
end


function love.keypressed( key, isrepeat )
    -- ESC to exit
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'g' then
        guide = not guide
    end
    if key == 'up' then
        if divide < 32 then
            divide = divide + 1
        end
        mesh_refresh = true
    end
    if key == 'down' then
        if divide > 2 then
            divide = divide - 1
        end
        mesh_refresh = true
    end
end


return sandbox
