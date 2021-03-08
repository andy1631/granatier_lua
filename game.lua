Bitser = require "lib.bitser.bitser"
Socket = require "socket"
MapParser = require "mapParser"
Map = require "map"
Player = require "player"
Field = require "field"
Bomb = require "bomb"
LibDeflate = require "lib.LibDeflate"

local host = false
local updaterate = 0.03
local timer = 0
local connections = {}
local game = {}

function game:enter(curr, address, port)
    mapParser = MapParser()
    mapParser:parse()

    udp = Socket.udp()
    udp:settimeout(0)
    if address ~= nil and port ~= nil then
        udp:setpeername(address, port)
        udp:send("connect")
    else
        host = true
        udp:setsockname("*", 12345)
    end
    --Bitser.registerClass("map", Map)
end

function game:update(dt)
    timer = timer + dt
    if not host then
        if timer > updaterate then
            local dump = udp:receive()
            if dump ~= "" then
                local data = Bitser.loads(dump)
                local decompressed = LibDeflate:DecompressDeflate(data)
                map:setData(decompressed)
            end
        end
    else
        local data, msg_or_ip, port_or_nil = udp:receivefrom()
        if data then
            if data == "connect" then
                connections[#connections] = {msg_or_ip, port_or_nil}
            else
                cmd, data = data.match("([^,]+),([^,]+)")
                if cmd == "walk" then
                    local id = get_key_for_value(connections, {msg_or_ip, port_or_nil})
                    map.players[id].walk(data)
                end
            end
        end

        if timer > updaterate then
            local dump = Bitser.dumps(map:getData())
            local compressed = LibDeflate:CompressDeflate(dump)
            local decompressed = LibDeflate:DecompressDeflate(compressed)
            -- map:setData(Bitser.loads(decompressed))
            --local bytes = {string.byte(dump, 1, -1)}
            --local data = ""
            --for k, v in pairs(bytes) do
            --    data = data .. tostring(v) .. ","
            --end
            --for key, value in pairs(connections) do
            --    for i = 1, 4 do
            --        udp:sendto(data.sub(#data / 4 * (i - 1) + 1, i * (#data / 4)), value[1], value[2])
            --    end
            --end
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
    --love.graphics.print(Serpent.block(connections), 0, 50)
end

function game:keypressed(key, scancode, isrepeat)
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

function get_key_for_value(t, value)
    for k, v in pairs(t) do
        if v == value then
            return k
        end
    end
    return nil
end

function utf8(decimal)
    if decimal < 128 then
        return string.char(decimal)
    end
    local charbytes = {}
    for bytes, vals in ipairs(bytemarkers) do
        if decimal <= vals[1] then
            for b = bytes + 1, 2, -1 do
                local mod = decimal % 64
                decimal = (decimal - mod) / 64
                charbytes[b] = string.char(128 + mod)
            end
            charbytes[1] = string.char(vals[2] + decimal)
            break
        end
    end
    return table.concat(charbytes)
end

function utf8frompoints(...)
    local chars, arg = {}, {...}
    for i, n in ipairs(arg) do
        chars[i] = utf8(arg[i])
    end
    return table.concat(chars)
end

return game
