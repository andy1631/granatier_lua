PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpScatty = Class{__includes = PowerUp}

function PowerUpScatty:init(pos) 
  self.Texture = love.filesystem.read("resources/SVG/bonus_bad_scatty.svg")
  self.Texture = tove.newGraphics(self.Texture)
  PowerUp.init(self, pos)
end

function PowerUpScatty:usePowerUp(player)
  
end

return PowerUpScatty