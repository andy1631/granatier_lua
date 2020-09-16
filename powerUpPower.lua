PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpPower = Class.include{__includes = PowerUp}

function PowerUpPower:init(pos) 
  PowerUp.init(self, pos)
  self.Texture = love.filesystem.read("resources/SVG/bonus_power.svg")
  self.Texture = tove.newGraphics(self.Texture)
end

function PowerUpPower:usePowerUp(player)
  
end

return PowerUpPower