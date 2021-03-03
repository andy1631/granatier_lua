Gamestate = require "lib.hump.gamestate"
game = require "game"
menu = require "menu"

local player
function love.load()
    if arg[#arg] == "-debug" then
        require("mobdebug").start()
    end
    love.window.setMode(1200, 675, {resizable = true})

    Gamestate.registerEvents()
    Gamestate.switch(game)
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
