local lume = require 'lib.lume'
local nidhogg = {}

local getNearestPlayer = function( players, x, y )
    local nearestPlayer = nil
    local nearestDistance = math.huge

    for i, player in ipairs( players ) do
        local pl_x, pl_y = player:getPosition()
        local distance = math.sqrt( (x - pl_x) ^ 2 + (y - pl_y) ^ 2 )

        if distance < nearestDistance then
            nearestPlayer = player
            nearestDistance = distance

        end
    end

    return nearestPlayer
end


local initPosition = {
    -- MT
    { x = 0, y = -200 },
    -- Others
    { x = -90, y = 200 },
    { x = -30, y = 200 },
    { x = 30, y = 200 },
    { x = 90, y = 200 },
    { x = -60, y = 260 },
    { x = 0, y = 260 },
    { x = 60, y = 260 }
}

local randDebuffGroup = {}
local dropDebuffPosition = {}
local towerManagePosition = {}

-- local towerGimmickTiming = {
--     -- form tower defined
--     {
--         4.55, -- tower appearing
--         10.26, -- defining geirskogul 
--         3.62 -- geirskogul
--     },
--     { 5.02, 9.97, 4.1 },
--     { 4.27, 9.3, 4.2 }
-- }

local playerlist = {
    MT = { image = NIDHOGG_MT_IMAGE },
    ST = { image = NIDHOGG_ST_IMAGE },
    H1 = { image = NIDHOGG_H1_IMAGE },
    H2 = { image = NIDHOGG_H2_IMAGE },
    D1 = { image = NIDHOGG_D1_IMAGE },
    D2 = { image = NIDHOGG_D2_IMAGE },
    D3 = { image = NIDHOGG_D3_IMAGE },
    D4 = { image = NIDHOGG_D4_IMAGE }
}

local randlist = {
    { image = { debuff = NIDHOGG_DEBUFF_RAND1_IMAGE, marker = NIDHOGG_MARKER_RAND1_IMAGE }, timer = 14.42, name = 'rand1' },
    { image = { debuff = NIDHOGG_DEBUFF_RAND2_IMAGE, marker = NIDHOGG_MARKER_RAND2_IMAGE }, timer = 24.73, name = 'rand2' },
    { image = { debuff = NIDHOGG_DEBUFF_RAND3_IMAGE, marker = NIDHOGG_MARKER_RAND3_IMAGE }, timer = 35.73, name = 'rand3' }
}

local jumplist = {
    { image = NIDHOGG_DEBUFF_ELUSIVE_IMAGE, name = 'elusive' },
    { image = NIDHOGG_DEBUFF_SPINE_IMAGE, name = 'spine' },
    { image = NIDHOGG_DEBUFF_HIGH_IMAGE, name = 'highjump' }
}

nidhogg.name = 'nidhogg'
local currentPlayerIndex = 1
local players = {}
local enemy = nil
local ground = nil
local gimmickManager = nil
local aoes = {}
local fieldMarkers = {}
local huds = {}
local towers = {}
local keyManager = nil

function nidhogg:init()

end


function nidhogg:enter()
    keyManager = KeyManager()
    keyManager:register( {
        {
            key = 'g',
            func = function()
                if gimmickManager:isWorking() then
                    return
                end

                -- change me to next player
                players[currentPlayerIndex]:setMe( false )
                players[(currentPlayerIndex) % #players + 1]:setMe( true )

                currentPlayerIndex = (currentPlayerIndex) % #players + 1
            end
,
            rep = false,
            act = 'pressed'
        }
    } )

    -- objects
    players = {
        Player( 'MT', NIDHOGG_MT_IMAGE, { x = -350, y = 0 } ),
        Player( 'ST', NIDHOGG_ST_IMAGE, { x = -250, y = 0 } ),
        Player( 'H1', NIDHOGG_H1_IMAGE, { x = -150, y = 0 } ),
        Player( 'H2', NIDHOGG_H2_IMAGE, { x = -50, y = 0 } ),
        Player( 'D1', NIDHOGG_D1_IMAGE, { x = 50, y = 0 } ),
        Player( 'D2', NIDHOGG_D2_IMAGE, { x = 150, y = 0 } ),
        Player( 'D3', NIDHOGG_D3_IMAGE, { x = 250, y = 0 } ),
        Player( 'D4', NIDHOGG_D4_IMAGE, { x = 350, y = 0 } )
    }
    players[currentPlayerIndex]:setMe( true )
    ground = Ground()

    enemy = FieldMarker( { image = NIDHOGG_ENEMY_IMAGE, x = 0, y = 0, scale = 1.45 } )
    fieldMarkers.A = FieldMarker( { image = FIELD_MARKER_A_IMAGE, x = 0, y = 535 } )
    fieldMarkers.B = FieldMarker( { image = FIELD_MARKER_B_IMAGE, x = 535, y = 0 } )
    fieldMarkers.C = FieldMarker( { image = FIELD_MARKER_C_IMAGE, x = 0, y = -535 } )
    fieldMarkers.D = FieldMarker( { image = FIELD_MARKER_D_IMAGE, x = -535, y = 0 } )
    fieldMarkers.num1 = FieldMarker( { image = FIELD_MARKER_1_IMAGE, x = 385, y = 385 } )
    fieldMarkers.num2 = FieldMarker( { image = FIELD_MARKER_2_IMAGE, x = 385, y = -385 } )
    fieldMarkers.num3 = FieldMarker( { image = FIELD_MARKER_3_IMAGE, x = -385, y = -385 } )
    fieldMarkers.num4 = FieldMarker( { image = FIELD_MARKER_4_IMAGE, x = -385, y = 385 } )

    huds.debuffList = DebuffList()
    huds.spellGauge = SpellGauge()
    huds.battletalkwindow = BattleTalkWindow()

    for i, pl in ipairs( players ) do
        pl:setScale( 1 )
        pl:setPriority( 10 )
    end
    ground:setImage( NIDHOGG_GROUND_IMAGE )

    for k, aoe in pairs( aoes ) do
        aoe:setPriority( 5 )
    end
    for k, fm in pairs( fieldMarkers ) do
        fm:setPriority( 6 )
    end
    enemy:setPriority( 6 )

    gimmickManager = GimmickManager()
    for i, pl in ipairs( players ) do
        gimmickManager:setPlayer( pl )
    end

    -- timeline +0.63
    do
        -- table.insert( aoes, AOE( 'seriph', 0, 0.1, {
        --     effect = function()
        --         huds.battletalkwindow:setSeriph( 'これぞ終焉の竜詩よ！' )
        --         huds.battletalkwindow:display()
        --     end

        -- } ) )
        -- table.insert( aoes, AOE( 'seriph', 0, 5.25, {
        --     effect = function()
        --         huds.battletalkwindow:setSeriph(
        --             '我が竜詩を耐えるというのか……！\nフレースヴェルグの力を使いこなしていると！？' )
        --         huds.battletalkwindow:display()
        --     end

        -- } ) )
        local delay = 13.5

        -- PCを初期位置へ
        table.insert( aoes, AOE( 'seriph', 0, 13.76 - delay, {
            effect = function()
                for i, pl in ipairs( players ) do
                    pl:setPosition( initPosition[i].x, initPosition[i].y )
                end
            end


        } ) )

        -- table.insert( aoes, AOE( 'seriph', 0, 0.1, {
        table.insert( aoes, AOE( 'seriph', 0, 13.76 - delay, {
            effect = function()
                local spelltime = 5.4
                local towertime = 2.11
                local jumplength = 400
                local nullfunc = function()
                end


                local establishTower = {
                    -- back
                    function( pl )
                        print( 'back', pl:getName() )
                        local pl_x, pl_y = pl:getPosition()
                        local pl_rot = pl:getDirection()

                        local x = pl_x + math.cos( pl_rot + math.pi ) * jumplength
                        local y = pl_y - math.sin( pl_rot + math.pi ) * jumplength

                        -- 塔設置(塔の位置確定から4.6秒の遅延)
                        -- 塔の出現時間は 2.11 秒
                        table.insert( aoes, AOE( 'seriph', 0, 4.6, {
                            effect = function()
                                table.insert( towers, FieldMarker( { image = NIDHOGG_TOWER_IMAGE, x = x, y = -y, duration = towertime } ) )
                            end


                        } ) )
                        aoes[#aoes]:start()

                        -- ゲイルスコルグAoEは塔確定のち9.8秒後に位置が確定し、13.88秒後に発動する
                        table.insert( aoes, AOE( 'seriph', 0, 9.8, {
                            effect = function()
                                local nearest = getNearestPlayer( players, x, y )
                                local pl_x2, pl_y2 = nearest:getPosition()
                                local angle = lume.angle( pl_x2, pl_y2, x, y ) + math.pi
                                local x_aoe = x + math.cos( angle ) * 400
                                local y_aoe = y + math.sin( angle ) * 400

                                print( pl:getName() .. '\'s tower' .. ' (' .. x .. ', ' .. y .. ')' .. ': ' .. nearest:getName() .. ' (' .. pl_x2 .. ', ' ..
                                           pl_y2 .. ')' )

                                table.insert( aoes, AOE( 'rectangle', 0, 3.9, { x = x_aoe, y = y_aoe, w = 800, h = 200, rot = angle } ) )
                                aoes[#aoes]:start()
                            end


                        } ) )
                        aoes[#aoes]:start()
                    end
,
                    -- front
                    function( pl )
                        print( 'front', pl:getName() )
                        local pl_x, pl_y = pl:getPosition()
                        local pl_rot = pl:getDirection()

                        local x = pl_x + math.cos( pl_rot ) * jumplength
                        local y = pl_y - math.sin( pl_rot ) * jumplength

                        -- 塔設置(塔の位置確定から4.6秒の遅延)
                        -- 塔の出現時間は 2.11 秒
                        table.insert( aoes, AOE( 'seriph', 0, 4.6, {
                            effect = function()
                                table.insert( towers, FieldMarker( { image = NIDHOGG_TOWER_IMAGE, x = x, y = -y, duration = towertime } ) )
                            end


                        } ) )
                        aoes[#aoes]:start()

                        -- ゲイルスコルグAoEは塔確定のち9.8秒後に位置が確定し、13.88秒後に発動する
                        table.insert( aoes, AOE( 'seriph', 0, 9.8, {
                            effect = function()
                                local nearest = getNearestPlayer( players, x, y )
                                local pl_x2, pl_y2 = nearest:getPosition()
                                local angle = lume.angle( pl_x2, pl_y2, x, y ) + math.pi
                                local x_aoe = x + math.cos( angle ) * 400
                                local y_aoe = y + math.sin( angle ) * 400

                                print( pl:getName() .. '\'s tower' .. ' (' .. x .. ', ' .. y .. ')' .. ': ' .. nearest:getName() .. ' (' .. pl_x2 .. ', ' ..
                                           pl_y2 .. ')' )

                                table.insert( aoes, AOE( 'rectangle', 0, 3.9, { x = x_aoe, y = y_aoe, w = 800, h = 200, rot = angle } ) )
                                aoes[#aoes]:start()
                            end


                        } ) )
                        aoes[#aoes]:start()
                    end
,
                    -- stay
                    function( pl )
                        print( 'stay', pl:getName() )
                        -- 塔の位置
                        local pl_x, pl_y = pl:getPosition()

                        -- 塔設置(塔の位置確定から4.6秒の遅延)
                        -- 塔の出現時間は 2.11 秒
                        table.insert( aoes, AOE( 'seriph', 0, 4.6, {
                            effect = function()
                                table.insert( towers, FieldMarker( { image = NIDHOGG_TOWER_IMAGE, x = pl_x, y = -pl_y, duration = towertime } ) )
                            end


                        } ) )
                        aoes[#aoes]:start()

                        -- ゲイルスコルグAoEは塔確定のち9.8秒後に位置が確定し、13.88秒後に発動する
                        table.insert( aoes, AOE( 'seriph', 0, 9.8, {
                            effect = function()
                                local nearest = getNearestPlayer( players, pl_x, pl_y )
                                -- 最も近いプレイヤーの位置
                                local pl_x2, pl_y2 = nearest:getPosition()
                                local angle = lume.angle( pl_x2, pl_y2, pl_x, pl_y ) + math.pi
                                -- AoEの位置
                                local x_aoe = pl_x + math.cos( angle ) * 400
                                local y_aoe = pl_y + math.sin( angle ) * 400

                                print(
                                    pl:getName() .. '\'s tower' .. ' (' .. pl_x .. ', ' .. pl_y .. ')' .. ': ' .. nearest:getName() .. ' (' .. pl_x2 .. ', ' ..
                                        pl_y2 .. ')' )

                                table.insert( aoes, AOE( 'rectangle', 0, 3.9, { x = x_aoe, y = y_aoe, w = 800, h = 200, rot = angle } ) )
                                aoes[#aoes]:start()
                            end


                        } ) )
                        aoes[#aoes]:start()
                    end


                }

                -- players の上から順番に与えるデバフのリスト
                local debufflist = {}

                local grouping = lume.shuffle( { 1, 1, 1, 2, 2, 3, 3, 3 } )
                local group = { {}, {}, {} } -- { {'MT', 'H2', 'D3'}, {...}, {...} }

                for i, pl in ipairs( players ) do
                    local rand = grouping[i]
                    table.insert( group[rand], pl )
                end

                for i, pl in ipairs( grouping ) do
                    print( 'grouping', i, pl )
                end

                for i, g in ipairs( group ) do
                    print( 'group', i )
                    for j, pl in ipairs( g ) do
                        print( 'player', j, pl:getName() )
                    end
                end

                for i, g in ipairs( group ) do
                    -- サイコロ i のグループから処理

                    -- はじめに処理するプレイヤーをランダムに選ぶ
                    local rand = math.random( 1, #g )
                    local idx = rand

                    -- [j j j] or [s e j]
                    local jumpdebuffgroup = math.random( 1, 2 )
                    local func = nil

                    for j, pl in ipairs( g ) do

                        -- [j j j] or [s e j]
                        if jumpdebuffgroup == 1 then
                            -- [j j [j]]
                            func = function()
                                establishTower[3]( pl )
                            end


                            table.insert( debufflist, {
                                -- サイコロ
                                rand = Debuff( randlist[i].name, randlist[i].image.debuff, func, randlist[i].timer, 'onEnd', randlist[i].image.marker, spelltime ),
                                -- ジャンプ(詠唱完了後にHUDに追加)
                                jump = Debuff( jumplist[3].name, jumplist[3].image, nullfunc, randlist[i].timer, 'onEnd' )
                            } )
                        else
                            -- [s e [j]]
                            local temp = establishTower[idx]
                            func = function()
                                temp( pl )
                            end


                            table.insert( debufflist, {
                                -- サイコロ
                                rand = Debuff( randlist[i].name, randlist[i].image.debuff, func, randlist[i].timer, 'onEnd', randlist[i].image.marker, spelltime ),
                                -- ジャンプ(詠唱完了後にHUDに追加)
                                jump = Debuff( jumplist[idx].name, jumplist[idx].image, nullfunc, randlist[i].timer, 'onEnd' )
                            } )
                            idx = idx % #g + 1
                        end
                    end
                end

                -- デバフを与える
                local idx = 1
                for i, g in ipairs( group ) do
                    for j, pl in ipairs( g ) do
                        pl:addDebuff( debufflist[idx].rand )
                        pl:addDebuff( debufflist[idx].jump )
                        if pl:isMe() then
                            huds.debuffList:add( debufflist[idx].rand )
                        end
                        idx = idx + 1
                    end

                end

                local func = function()
                    local idx = 1
                    for i, g in ipairs( group ) do
                        for j, pl in ipairs( g ) do
                            if pl:isMe() then
                                huds.debuffList:add( debufflist[idx].jump )
                            end
                            idx = idx + 1
                        end
                    end
                end


                randDebuffGroup = lume.clone( group )

                huds.spellGauge:startSpell( '堕天のドラゴンダイブ ', func, 5.4 )
            end


        } ) )

        -- ギミック処理位置の計算
        table.insert( aoes, AOE( 'seriph', 0, 13.76 - delay, {
            effect = function()
                local positionsA = {
                    -- 1
                    {
                        -- B
                        { -200, 0 },
                        -- C
                        { 0, -200 },
                        -- D
                        { 200, 0 }
                    },
                    -- 2
                    {
                        -- 1
                        { -200, 350 },
                        -- 2
                        { 200, 350 }
                    },
                    -- 3
                    {
                        -- B
                        { -200, 0 },
                        -- C
                        { 0, -200 },
                        -- D
                        { 200, 0 }
                    }
                }
                local positionsB = {
                    -- 1
                    {
                        -- B
                        { -230, 0 },
                        -- C
                        { 0, -230 },
                        -- D
                        { 230, 0 }
                    },
                    -- 2
                    {
                        -- 1
                        { -230, 350 },
                        -- 2 
                        { 230, 350 }
                    },
                    -- 3
                    {
                        -- B
                        { -230, 0 },
                        -- C
                        { 0, -230 },
                        -- D
                        { 230, 0 }
                    }
                }
                for i, pl in ipairs( players ) do
                    for j, posgroup in ipairs( positionsA ) do
                        -- rand[j] のグループであるとき
                        if lume.find( randDebuffGroup[j], pl ) then
                            dropDebuffPosition[j] = dropDebuffPosition[j] or {}
                            table.insert( dropDebuffPosition[j], posgroup[1] )
                            lume.remove( posgroup, posgroup[1] )
                        end
                    end
                    for j, posgroup in ipairs( positionsB ) do
                        -- rand[j] のグループであるとき
                        if lume.find( randDebuffGroup[j], pl ) then
                            towerManagePosition[j] = towerManagePosition[j] or {}
                            table.insert( towerManagePosition[j], posgroup[1] )
                            lume.remove( posgroup, posgroup[1] )
                        end
                    end
                end

            end


        } ) )

        -- 一回目
        local rand = lume.randomchoice( { '尾牙の連旋', '牙尾の連旋' } )
        table.insert( aoes, AOE( 'seriph', 0, 20.91 - delay, {
            effect = function()
                local nullfunc = function()

                end


                huds.spellGauge:startSpell( rand, nullfunc, 7.27 )
            end


        } ) )

        -- PLのサイコロ処理移動1
        table.insert( aoes, AOE( 'seriph', 0, 21.55 - delay, {
            effect = function()
                local idx = 1
                for i, pl in ipairs( players ) do
                    if lume.find( randDebuffGroup[1], pl ) then
                        -- サイコロ1のグループの移動
                        local x, y = 0, 0
                        if not pl:isMe() then

                            x, y = dropDebuffPosition[1][idx][1], dropDebuffPosition[1][idx][2]

                            -- イルスパの確認
                            local elusive, spine = pl:getDebuff( 'elusive' ), pl:getDebuff( 'spine' )
                            if elusive then
                                if idx == 1 then
                                    x = dropDebuffPosition[1][idx][1] + 400
                                    pl:move( 1, 0 )
                                elseif idx == 2 then
                                    y = dropDebuffPosition[1][idx][2] - 400
                                    pl:move( 0, -1 )
                                elseif idx == 3 then
                                    x = dropDebuffPosition[1][idx][1] - 400
                                    pl:move( -1, 0 )
                                end
                            elseif spine then
                                if idx == 1 then
                                    x = dropDebuffPosition[1][idx][1] + 400
                                    pl:move( -1, 0 )
                                elseif idx == 2 then
                                    y = dropDebuffPosition[1][idx][2] - 400
                                    pl:move( 0, 1 )
                                elseif idx == 3 then
                                    x = dropDebuffPosition[1][idx][1] - 400
                                    pl:move( 1, 0 )
                                end
                            end
                            pl:setPosition( x, -y )
                        end
                        idx = idx + 1
                    else
                        -- その他のグループの移動
                        if not pl:isMe() then
                            pl:setPosition( 0, -200 )
                        end
                    end

                end
            end


        } ) )

        -- 頭割り
        table.insert( aoes, AOE( 'seriph', 0, 26.55 - delay, {
            effect = function()
                FieldMarker( { image = NIDHOGG_DISTRIBUTION_IMAGE, x = 0, y = 200, duration = 1 } )
            end


        } ) )
        table.insert( aoes, AOE( 'circle', 27.55 - delay, 27.55 - delay, { x = 0, y = -200, rad = 100, hole = 0 } ) )

        -- PLの塔処理移動1
        table.insert( aoes, AOE( 'seriph', 0, 32.10 - delay, {
            effect = function()
                local idx = 1
                for i, pl in ipairs( players ) do
                    if lume.find( randDebuffGroup[3], pl ) then
                        -- サイコロ3のグループの移動
                        if not pl:isMe() then
                            pl:setPosition( towerManagePosition[1][idx][1], -towerManagePosition[1][idx][2] )
                        end
                        idx = idx + 1
                    else
                        -- その他のグループの移動
                        if not pl:isMe() then
                            pl:setPosition( 0, -200 )
                        end
                    end

                end
            end


        } ) )

        if rand == '尾牙の連旋' then
            table.insert( aoes, AOE( 'circle', 31.66 - delay, 31.66 - delay, { x = 0, y = 0, rad = 900, hole = 200 } ) )
            table.insert( aoes, AOE( 'circle', 34.21 - delay, 34.21 - delay, { x = 0, y = 0, rad = 200, hole = 0 } ) )
        else
            table.insert( aoes, AOE( 'circle', 31.66 - delay, 31.66 - delay, { x = 0, y = 0, rad = 200, hole = 0 } ) )
            table.insert( aoes, AOE( 'circle', 34.21 - delay, 34.21 - delay, { x = 0, y = 0, rad = 900, hole = 200 } ) )
        end

        -- PLのサイコロ処理移動2
        table.insert( aoes, AOE( 'seriph', 0, 36.81 - delay, {
            effect = function()
                local idx = 1
                for i, pl in ipairs( players ) do
                    if lume.find( randDebuffGroup[2], pl ) then
                        local x, y = 0, 0

                        -- サイコロ2のグループの移動
                        if not pl:isMe() then

                            x, y = dropDebuffPosition[2][idx][1], dropDebuffPosition[2][idx][2]

                            -- イルスパの確認
                            local elusive, spine = pl:getDebuff( 'elusive' ), pl:getDebuff( 'spine' )
                            if elusive then
                                if idx == 1 then
                                    pl:move( 1, 0 )
                                elseif idx == 2 then
                                    pl:move( -1, 0 )
                                end
                            elseif spine then
                                if idx == 1 then
                                    pl:move( -1, 0 )
                                elseif idx == 2 then
                                    pl:move( 1, 0 )
                                end
                            end
                            pl:setPosition( x, -y )
                        end
                        idx = idx + 1
                    elseif lume.find( randDebuffGroup[1], pl ) then
                        -- サイコロ1のグループの移動
                        -- 関与しない位置に移動
                        if not pl:isMe() then
                            pl:setPosition( 0, -200 )
                        end
                    end
                    -- サイコロ3は塔処理のため移動しない

                end
            end


        } ) )

        -- 二回目
        local rand2 = lume.randomchoice( { '尾牙の連旋', '牙尾の連旋' } )
        table.insert( aoes, AOE( 'seriph', 0, 41.76 - delay, {
            effect = function()
                local nullfunc = function()

                end


                huds.spellGauge:startSpell( rand2, nullfunc, 7.1 )
            end


        } ) )

        -- PLの塔処理移動2
        table.insert( aoes, AOE( 'seriph', 0, 42.20 - delay, {
            effect = function()
                local idx = 1
                for i, pl in ipairs( players ) do
                    if lume.find( randDebuffGroup[1], pl ) then
                        -- サイコロ1のグループの移動
                        -- C以外の人間が移動
                        if idx ~= 2 and not pl:isMe() then
                            -- クソ実装
                            idx = idx == 3 and 2 or idx
                            print( 'idx: ', idx )
                            pl:setPosition( towerManagePosition[2][idx][1], -towerManagePosition[2][idx][2] )
                        end
                        idx = idx + 1
                    else
                        -- その他のグループの移動
                        if not pl:isMe() then
                            pl:setPosition( 0, -200 )
                        end
                    end

                end
            end


        } ) )

        -- PLのサイコロ処理移動3
        table.insert( aoes, AOE( 'seriph', 0, 48.60 - delay, {
            effect = function()
                local idx = 1
                for i, pl in ipairs( players ) do
                    if lume.find( randDebuffGroup[3], pl ) then
                        local x, y = 0, 0

                        -- サイコロ1のグループの移動
                        if not pl:isMe() then

                            x, y = dropDebuffPosition[3][idx][1], dropDebuffPosition[3][idx][2]
                            -- イルスパの確認
                            local elusive, spine = pl:getDebuff( 'elusive' ), pl:getDebuff( 'spine' )
                            if elusive then
                                if idx == 1 then
                                    x = dropDebuffPosition[3][idx][1] + 400
                                    pl:move( 1, 0 )
                                elseif idx == 2 then
                                    y = dropDebuffPosition[3][idx][2] - 400
                                    pl:move( 0, -1 )
                                elseif idx == 3 then
                                    x = dropDebuffPosition[3][idx][1] - 400
                                    pl:move( -1, 0 )
                                end
                            elseif spine then
                                if idx == 1 then
                                    x = dropDebuffPosition[3][idx][1] + 400
                                    pl:move( -1, 0 )
                                elseif idx == 2 then
                                    y = dropDebuffPosition[3][idx][2] - 400
                                    pl:move( 0, 1 )
                                elseif idx == 3 then
                                    x = dropDebuffPosition[3][idx][1] - 400
                                    pl:move( 1, 0 )
                                end
                            end
                            pl:setPosition( x, -y )
                        end
                        idx = idx + 1
                    else
                        -- その他のグループの移動
                        if not pl:isMe() then
                            pl:setPosition( 0, -200 )
                        end
                    end

                end
            end


        } ) )

        -- 頭割り
        table.insert( aoes, AOE( 'seriph', 0, 47.86 - delay, {
            effect = function()
                FieldMarker( { image = NIDHOGG_DISTRIBUTION_IMAGE, x = 0, y = 200, duration = 1 } )
            end


        } ) )
        table.insert( aoes, AOE( 'circle', 48.86 - delay, 48.86 - delay, { x = 0, y = -200, rad = 100, hole = 0 } ) )

        -- PLの塔処理移動3
        table.insert( aoes, AOE( 'seriph', 0, 53.13 - delay, {
            effect = function()
                local idx1 = 1
                local idx2 = 1
                for i, pl in ipairs( players ) do
                    if lume.find( randDebuffGroup[1], pl ) then
                        -- サイコロ1のグループの移動
                        -- Cの人間が移動
                        if idx1 == 2 and not pl:isMe() then
                            pl:setPosition( towerManagePosition[3][idx1][1], -towerManagePosition[3][idx1][2] )
                        end
                        idx1 = idx1 + 1

                    elseif lume.find( randDebuffGroup[2], pl ) then
                        -- サイコロ2のグループの移動
                        if not pl:isMe() then
                            pl:setPosition( towerManagePosition[3][idx2][1], -towerManagePosition[3][idx2][2] )
                        end
                        idx2 = idx2 + 2
                    else
                        -- その他のグループの移動
                        if not pl:isMe() then
                            pl:setPosition( 0, -200 )
                        end
                    end

                end
            end


        } ) )

        if rand2 == '尾牙の連旋' then
            table.insert( aoes, AOE( 'circle', 53.13 - delay, 53.13 - delay, { x = 0, y = 0, rad = 900, hole = 200 } ) )
            table.insert( aoes, AOE( 'circle', 55.31 - delay, 55.31 - delay, { x = 0, y = 0, rad = 200, hole = 0 } ) )
        else
            table.insert( aoes, AOE( 'circle', 53.13 - delay, 53.13 - delay, { x = 0, y = 0, rad = 200, hole = 0 } ) )
            table.insert( aoes, AOE( 'circle', 55.31 - delay, 55.31 - delay, { x = 0, y = 0, rad = 900, hole = 200 } ) )
        end
    end

    for k, aoe in pairs( aoes ) do
        gimmickManager:add( aoe )
    end

end


function nidhogg:update( dt )
    keyManager:update( dt )
    gimmickManager:update( dt )
    huds.debuffList:update( dt )
    huds.spellGauge:update( dt )
    huds.battletalkwindow:update( dt )
end


function nidhogg:draw()
    huds.debuffList:draw()
    huds.spellGauge:draw()
    huds.battletalkwindow:draw()

end


function nidhogg:leave()
    for k, pl in pairs( players ) do
        pl:delete()
    end
    ground:delete()
    enemy:delete()

    for k, aoe in pairs( aoes ) do
        aoe:delete()
    end

    for k, fieldMarker in pairs( fieldMarkers ) do
        fieldMarker:delete()
    end

    gimmickManager:delete()
    huds.debuffList:delete()
    huds.spellGauge:delete()
    huds.battletalkwindow:delete()

end


return nidhogg
