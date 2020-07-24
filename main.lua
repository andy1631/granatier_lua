Player = require "player"
Map = require 'map'

local player
local direction = ''
local dir_lock = false
function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  love.window.setMode(1200, 800, {resizable = true})
  map = Map()
  map:spawn(Player())
  --print(player)
end

function love.update(dt)
  map:update(dt)
end

function love.draw()
  map:draw()
end
