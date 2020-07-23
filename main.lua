Player = require "player"

local player
local direction = ''
local dir_lock = false
function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  love.window.setMode(1200, 800, {resizable = true})
  player = Player(10, 10)
  --print(player)
end

function love.update(dt)
  --player.move(100 * dt, 100 * dt)
  if love.keyboard.isDown('w') and (not dir_lock or direction == 'w') then
    player.move(0, -1)
    direction = 'w'
    dir_lock = true
  elseif love.keyboard.isDown('a') and (not dir_lock or direction == 'a') then
    player.move(-1, 0)
    direction = 'a'
    dir_lock = true
  elseif love.keyboard.isDown('s') and (not dir_lock or direction == 's') then
    player.move(0, 1)
    direction = 's'
    dir_lock = true
  elseif love.keyboard.isDown('d') and (not dir_lock or direction == 'd') then
    player.move(1, 0)
    direction = 'd'
    dir_lock = true
  else
    dir_lock = false
    direction = ''
  end
  player.update(dt)
end

function love.draw()
  player.draw()
end
