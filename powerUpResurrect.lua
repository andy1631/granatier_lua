PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpResurrect = Class{__includes = PowerUp}

function PowerUpResurrect:init(pos) 
  PowerUp.init(self, pos)
  self.Texture = love.filesystem.read("resources/SVG/bonus_neutral_resurrect.svg")
  self.Texture = tove.newGraphics(self.Texture)
end

function PowerUpResurrect:usePowerUp(player)
  
end

return PowerUpResurrect