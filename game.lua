MapParser = require "mapParser"
Player = require "player"

local game = {}

function game:enter()
    mapParser = MapParser()
    mapParser:parse()
end

function game:update(dt)
    map:update(dt)
end

function game:draw()
    map:draw()
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
return game
