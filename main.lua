Player = require "player"
Map = require 'map'
MapParser= require 'mapParser'

local player
local direction = ''
local dir_lock = false
function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  love.window.setMode(1200, 675, {resizable = true})
  --print(player)
  mapParser=MapParser()
  mapParser:parse()
end

function love.update(dt)
  map:update(dt)
end

function love.draw()
  -- love.graphics.rotate(180)
  map:draw()
end

function love.keypressed(key, scancode, isrepeat)
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

function love.keyreleased(key, scancode, isrepeat)
  if not love.keyboard.isDown('w') and not love.keyboard.isDown('a') and not love.keyboard.isDown('s') and not    love.keyboard.isDown('d') then
  map.players[0].movement = false
  end
end
