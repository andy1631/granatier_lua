PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpKick = Class{__includes = PowerUp}

function PowerUpKick:init(pos) 
  PowerUp.init(self, pos)
  self.Texture = love.filesystem.read("resources/SVG/bonus_kick.svg")
  self.Texture = tove.newGraphics(self.Texture)
end

function PowerUpKick:usePowerUp(player)
  
end

return PowerUpKick