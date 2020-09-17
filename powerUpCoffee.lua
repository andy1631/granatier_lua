PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpCoffee = Class{__includes = PowerUp}

function PowerUpCoffee:init(pos) 
  self.Texture = love.filesystem.read("resources/SVG/bonus_bad_hyperactive.svg")
  self.Texture = tove.newGraphics(self.Texture)
  PowerUp.init(self, pos)
end

function PowerUpCoffee:usePowerUp(player)
  
end

return PowerUpCoffee