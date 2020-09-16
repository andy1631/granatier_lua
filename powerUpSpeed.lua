PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpSpeed = Class.include{__includes = PowerUp}

function PowerUpSpeed:init(pos) 
  PowerUp.init(self, pos)
  self.Texture = love.filesystem.read("resources/SVG/bonus_speed.svg")
  self.Texture = tove.newGraphics(self.Texture)
end

function PowerUpSpeed:usePowerUp(player)
  
end

return PowerUpSpeed