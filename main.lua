Gamestate = require "lib.hump.gamestate"
game = require "game"
menu = require "menu"
Tove = require "lib.tove"

Textures = {}
Sounds = {}
ToveBuffer = {}

local player
function love.load()
    if arg[#arg] == "-debug" then
        require("mobdebug").start()
    end
    for k, v in pairs(love.filesystem.getDirectoryItems("resources/textures/")) do
        local key = string.match(v, "[^.]+")
        Textures[key] = love.filesystem.read("resources/textures/" .. v)
    end
    for k, v in pairs(love.filesystem.getDirectoryItems("resources/sounds/")) do
        local key = string.match(v, "[^.]+")
        Sounds[key] = love.audio.newSource("resources/sounds/" .. v, "static")
    end
    love.window.setMode(1200, 675, {resizable = false})

    Gamestate.registerEvents()
    Gamestate.switch(menu)
end

function love.update(dt)
end

function love.draw()
    -- love.graphics.rotate(180)
end

function love.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode, isrepeat)
end

function GetToveGraphics(name, size)
    if ToveBuffer[name] ~= nil then
        for i, img in ipairs(ToveBuffer[name]) do
            if img:getWidth() == size then
                return ToveBuffer[name]
            end
        end
        if #ToveBuffer[name] >= 3 then
            table.remove(Tove.Buffer[name], 1)
        end
        table.insert(ToveBuffer[name], Tove.newGraphics(ToveBuffer[name], size))
        return ToveBuffer[name][#ToveBuffer[name]]
    else
        ToveBuffer[name] = {}
        table.insert(ToveBuffer[name], Tove.newGraphics(Textures[name], size))
        return ToveBuffer[name][#ToveBuffer[name]]
    end
end
