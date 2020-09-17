PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpTeleport = Class{__includes = PowerUp}

function PowerUpTeleport:init(pos) 
  PowerUp.init(self, pos)
  self.Texture = love.filesystem.read("resources/SVG/bonus_neutral_teleport.svg")
  self.Texture = tove.newGraphics(self.Texture)
end

function PowerUpTeleport:usePowerUp(player)
  
end

return PowerUpTeleport