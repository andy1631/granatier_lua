Player = require "player"
Map = require 'map'
MapParser= require 'mapParser'

local game = {}

function game:enter()
  mapParser=MapParser()
  mapParser:parse()
end

function game:update(dt)
  map:update(dt)
end

function game:draw()
  map:draw()
end

function game:keypressed(key, scancode, isrepeat)
  if key == 'w' then
    map.players[0].direction = 'up'
    map.players[0].movement = true
  elseif key == 'a' then
    map.players[0].direction = 'left'
    map.players[0].movement = true
  elseif key == 's' then
    map.players[0].direction = 'down'
    map.players[0].movement = true
  elseif key == 'd' then
    map.players[0].direction = 'right'
    map.players[0].movement = true
  end

  if key == 'q' then
    map:setBomb()
  end
end

function game:keyreleased(key, scancode, isrepeat)
  if not love.keyboard.isDown('w') and not love.keyboard.isDown('a') and not love.keyboard.isDown('s') and not       love.keyboard.isDown('d') then
    map.players[0].movement = false
  end
end

return game