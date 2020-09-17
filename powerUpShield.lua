PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpShield = Class{__includes = PowerUp}

function PowerUpShield:init(pos) 
  PowerUp.init(self, pos)
  self.Texture = love.filesystem.read("resources/SVG/bonus_shield.svg")
  self.Texture = tove.newGraphics(self.Texture)
end

function PowerUpShield:usePowerUp(player)
  
end

return PowerUpShield