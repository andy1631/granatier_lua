Gamestate = require "lib.hump.gamestate"
game = require "game"
menu = require "menu"

Textures = {}

local player
function love.load()
    if arg[#arg] == "-debug" then
        require("mobdebug").start()
    end
    for k, v in pairs(love.filesystem.getDirectoryItems("resources/SVG/")) do
        local key = string.match(v, "[^.]+")
        Textures[key] = love.filesystem.read("resources/SVG/" .. v)
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
