PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpMason = Class.include{__includes = PowerUp}

function PowerUpMason:init(pos) 
  PowerUp.init(self, pos)
  self.Texture = love.filesystem.read("resources/SVG/bonus_mason.svg")
  self.Texture = tove.newGraphics(self.Texture)
end

function PowerUpMason:usePowerUp(player)
  
end

return PowerUpMason