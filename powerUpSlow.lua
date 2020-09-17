PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpSlow = Class{__includes = PowerUp}

function PowerUpSlow:init(pos) 
  PowerUp.init(self, pos)
  self.Texture = love.filesystem.read("resources/SVG/bonus_bad_slow.svg")
  self.Texture = tove.newGraphics(self.Texture)
end

function PowerUpSlow:usePowerUp(player)
  
end

return PowerUpSlow