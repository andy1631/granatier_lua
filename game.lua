Bitser = require "lib.bitser.bitser"
Socket = require "socket"
MapParser = require "mapParser"
Map = require "map"
Player = require "player"
Field = require "field"
Bomb = require "bomb"
LibDeflate = require "lib.LibDeflate"

local host = false
local updaterate = 0.00
local timer = 0
local connections = {}
local game = {}
local playerId = 0

function game:enter(curr, address, port)
    mapParser = MapParser()
    mapParser:parse()

    udp = Socket.udp()
    udp:settimeout(0)
    if address ~= nil and port ~= nil then
        --repeat
        --    data = udp:receive()
        --until data
        udp:setpeername(address, port)
        udp:send("connect")
        local data
        repeat
            data = udp:receive()
        until data
        playerId = tonumber(data)
    else
        host = true
        udp:setsockname("*", 12345)
    end
    --Bitser.registerClass("map", Map)
end

function game:update(dt)
    timer = timer + dt
    if not host then
        --end
        --if timer > updaterate then
        local dump = udp:receive()
        if dump ~= nil then
            --local id, cmd, x, y = string.match(dump, "([^:,]+),([^:,]+):([^:,]+),([^:,]+)")
            --if cmd == "pos" and map.players[tonumber(id)] ~= nil then
            --map.players[tonumber(id)].position.x = tonumber(x)
            --map.players[tonumber(id)].position.y = tonumber(y)
            --elseif cmd ~= "pos" then
            local decompressed = LibDeflate:DecompressDeflate(dump)
            local data = Bitser.loads(decompressed)
            map:setData(data)
        --end
        end
    else
        local data, msg_or_ip, port_or_nil = udp:receivefrom()
        if data then
            if data == "connect" then
                --self:sendPlayerPos(newPlayer.id)
                connections[#connections] = {msg_or_ip, port_or_nil}
                local newPlayer = map:spawn()
                udp:sendto(tostring(newPlayer.id), msg_or_ip, port_or_nil)
            else
                id, cmd, data = string.match(data, "([^:,]+),([^:,]+):([^:,]+)")
                --love.window.showMessageBox("info", cmd)
                if cmd == "walk" then
                    --self:sendPlayerPos(tonumber(id))
                    --local id = get_key_for_value(connections, {msg_or_ip, port_or_nil})
                    map.players[tonumber(id)]:walk(data)
                elseif cmd == "setBomb" then
                    map:setBomb(tonumber(id))
                end
            end
        end
        if timer > updaterate then
            local dump = Bitser.dumps(map:getData())
            local compressed = LibDeflate:CompressDeflate(dump)
            for key, value in pairs(connections) do
                udp:sendto(compressed, value[1], value[2])
            end
        end
    end
    map:update(dt)
end

function game:draw()
    map:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("host: " .. tostring(host), 0, 0)
end

function game:keypressed(key, scancode, isrepeat)
    if host then
        if key == "w" then
            map.players[0]:walk("up")
        elseif key == "a" then
            map.players[0]:walk("left")
        elseif key == "s" then
            map.players[0]:walk("down")
        elseif key == "d" then
            map.players[0]:walk("right")
        end

        if key == "q" then
            map:setBomb()
        end
    else
        if key == "w" then
            udp:send(playerId .. ",walk:up")
        elseif key == "a" then
            udp:send(playerId .. ",walk:left")
        elseif key == "s" then
            udp:send(playerId .. ",walk:down")
        elseif key == "d" then
            udp:send(playerId .. ",walk:right")
        end
        if key == "q" then
            --map:setBomb()
            udp:send(playerId .. ",setBomb:_")
        end
    end
end

function game:keyreleased(key, scancode, isrepeat)
    if
        not love.keyboard.isDown("w") and not love.keyboard.isDown("a") and not love.keyboard.isDown("s") and
            not love.keyboard.isDown("d")
     then
        map.players[0].movement = false
    end
end

function game:resize(w, h)
    map:resize()
end

function game:sendPlayerPos(id)
    for key, value in pairs(connections) do
        udp:sendto(
            id ..
                ",pos:" ..
                    tostring(map.players[tonumber(id)].position.x) ..
                        "," .. tostring(map.players[tonumber(id)].position.x),
            value[1],
            value[2]
        )
    end
end

return game
