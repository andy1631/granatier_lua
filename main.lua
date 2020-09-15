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
