Bitser = require "lib.bitser.bitser"
Socket = require "socket"
MapParser = require "mapParser"
Map = require "map"
Player = require "player"
Field = require "field"
Bomb = require "bomb"

local host = false
local updaterate = 0.1
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
    if not host then
        local data
        local dump = ""
        for i = 1, 2, 1 do
            data = udp:receive()
            if data ~= nil then
                dump = dump .. data
            end
        end

        if dump ~= "" then
            local copy = Bitser.loads(dump)
            if ok then
                map = copy
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
        local dump = Bitser.dumps(map)
        map = Bitser.loads(dump)
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
            udp:sendto(string.sub(dump, 1, #dump / 2), value[1], value[2])
            udp:sendto(string.sub(dump, #dump / 2 + 1, -1), value[1], value[2])
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
