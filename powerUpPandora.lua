PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpPandora = Class{__includes = PowerUp}

function PowerUpPandora:init(pos) 
  self.Texture = love.filesystem.read("resources/SVG/bonus_neutral_pandora.svg")
  self.Texture = tove.newGraphics(self.Texture)
  PowerUp.init(self, pos)
end

function PowerUpPandora:usePowerUp(player)
  
end

return PowerUpPandora