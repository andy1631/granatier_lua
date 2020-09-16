PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpScatty = Class.include{__includes = PowerUp}

function PowerUpScatty:init(pos) 
  PowerUp.init(self, pos)
  self.Texture = love.filesystem.read("resources/SVG/bonus_bad_scatty.svg")
  self.Texture = tove.newGraphics(self.Texture)
end

function PowerUpScatty:usePowerUp(player)
  
end

return PowerUpScatty