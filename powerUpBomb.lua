PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpBomb = Class{__includes = PowerUp}

function PowerUpBomb:init(pos) 
  PowerUp.init(self, pos)
  self.Texture = love.filesystem.read("resources/SVG/bonus_bomb.svg")
  self.Texture= tove.newGraphics(self.Texture)
end

function PowerUpBomb:usePowerUp(player)
  
end

return PowerUpBomb