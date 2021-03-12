Bitser = require "lib.bitser.bitser"
Socket = require "socket"
MapParser = require "mapParser"
Map = require "map"
Player = require "player"
Field = require "field"
Bomb = require "bomb"
LibDeflate = require "lib.LibDeflate.LibDeflate"

local host = false
local updaterate = 0.03
local timer = 0
local connections = {}
local game = {}
local playerId = 0
map = nil

function game:enter(curr, address, port)
    udp = Socket.udp()
    if address ~= nil and port ~= nil then
        map = Map(0, 0)
        udp:settimeout(5)
        udp:setpeername(address, port)
        repeat
            udp:send("connect")
            data = udp:receive()
        until data ~= nil
        playerId = tonumber(data)
        local dump = udp:receive()
        if dump ~= nil then
            local decompressed = LibDeflate:DecompressDeflate(dump)
            local data = Bitser.loads(decompressed)
            map:setData(data)
        end
    else
        host = true
        udp:setsockname("*", 12345)
        mapParser = MapParser("resources/arenas/granatier.xml")
        map = mapParser:parse()
        map:spawn()
    end
    udp:settimeout(0)
    --Bitser.registerClass("map", Map)
end

function game:update(dt)
    local start
    if not host then
        local dump = udp:receive()
        if dump ~= nil then
            local decompressed = LibDeflate:DecompressDeflate(dump)
            local data = Bitser.loads(decompressed)
            map:setData(data)
            map:update(dt)
        end
    else
        local data, msg_or_ip, port_or_nil = udp:receivefrom()
        if data then
            if data == "connect" then
                --self:sendPlayerPos(newPlayer.id)
                table.insert(connections, {msg_or_ip, port_or_nil})
                local newPlayer = map:spawn()
                udp:sendto(tostring(newPlayer.id), msg_or_ip, port_or_nil)
            else
                id, cmd, data = string.match(data, "([^:,]+),([^:,]+),([^:,]+)")
                --love.window.showMessageBox("info", cmd)
                if cmd == "walk" then
                    --self:sendPlayerPos(tonumber(id))
                    --local id = get_key_for_value(connections, {msg_or_ip, port_or_nil})
                    map.players[tonumber(id)]:walk(data)
                elseif cmd == "stopWalk" then
                    love.window.showMessageBox("stop", "walking should be stopped...")
                    map.players[tonumber(id)].movement = false
                elseif cmd == "setBomb" then
                    map:setBomb(tonumber(id))
                end
            end
        end
        map:update(dt)
        if timer > updaterate then
            local dump = Bitser.dumps(map:getData())
            local compressed = LibDeflate:CompressDeflate(dump)
            for key, value in pairs(connections) do
                udp:sendto(compressed, value[1], value[2])
            end
        end
        timer = timer + dt
    end
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
            udp:send(playerId .. ",walk,up")
        elseif key == "a" then
            udp:send(playerId .. ",walk,left")
        elseif key == "s" then
            udp:send(playerId .. ",walk,down")
        elseif key == "d" then
            udp:send(playerId .. ",walk,right")
        end
        if key == "q" then
            --map:setBomb()
            udp:send(playerId .. ",setBomb,_")
        end

        local dump = udp:receive()
        if dump ~= nil then
            local decompressed = LibDeflate:DecompressDeflate(dump)
            local data = Bitser.loads(decompressed)
            map:setData(data)
        end
    end
end

function game:keyreleased(key, scancode, isrepeat)
    if
        not love.keyboard.isDown("w") and not love.keyboard.isDown("a") and not love.keyboard.isDown("s") and
            not love.keyboard.isDown("d")
     then
        if host then
            map.players[0].movement = false
        else
            udp:send(playerId .. ",stopWalk:_")
        end
    end
end

function game:resize(w, h)
    map:resize()
end

return game
