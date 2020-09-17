PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpThrow = Class{__includes = PowerUp}

function PowerUpThrow:init(pos) 
  self.Texture = love.filesystem.read("resources/SVG/bonus_throw.svg")
  self.Texture = tove.newGraphics(self.Texture)
  PowerUp.init(self, pos)
end

function PowerUpThrow:usePowerUp(player)
  
end

return PowerUpThrow