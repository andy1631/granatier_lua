PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpRestrain = Class{__includes = PowerUp}

function PowerUpRestrain:init(pos) 
  PowerUp.init(self, pos)
  self.Texture = love.filesystem.read("resources/SVG/bonus_bad_restrain.svg")
  self.Texture = tove.newGraphics(self.Texture)
end

function PowerUpRestrain:usePowerUp(player)
  
end

return PowerUpRestrain