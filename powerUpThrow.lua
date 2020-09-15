PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpThrow = Class.include(PowerUp)

function PowerUpThrow:init(cords) 
  PowerUp.init(self, cords)
end

function PowerUpThrow:usePowerUp(player)
  
end

function PowerUpThrow:draw()
  throw = love.filesystem.read("resources/SVG/bonus_throw.svg")
  throw = tove.newGraphics(throw)
  throw:draw()
end

return PowerUpThrow