PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpSpeed = Class{__includes = PowerUp}

function PowerUpSpeed:init(pos) 
  self.Texture = love.filesystem.read("resources/SVG/bonus_speed.svg")
  self.Texture = tove.newGraphics(self.Texture)
  PowerUp.init(self, pos)
end

function PowerUpSpeed:usePowerUp(player)
  
end

return PowerUpSpeed