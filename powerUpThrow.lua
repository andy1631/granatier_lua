PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpThrow = Class.include{__includes = PowerUp}

function PowerUpThrow:init(pos) 
  PowerUp.init(self, pos)
  self.Texture = love.filesystem.read("resources/SVG/bonus_throw.svg")
  self.Texture = tove.newGraphics(self.Texture)
end

function PowerUpThrow:usePowerUp(player)
  
end

return PowerUpThrow