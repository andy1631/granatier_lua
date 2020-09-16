PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpPower = Class.include{__includes = PowerUp}

function PowerUpPower:init(cords) 
  PowerUp.init(self, cords)
end

function PowerUpPower:usePowerUp(player)
  
end

function PowerUpPower:draw()
  power = love.filesystem.read("resources/SVG/bonus_power.svg")
  power = tove.newGraphics(power)
  power:draw()
end

return PowerUpPower