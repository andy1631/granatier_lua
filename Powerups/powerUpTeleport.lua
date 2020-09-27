PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpTeleport = Class{__includes = PowerUp}

function PowerUpTeleport:init(pos) 
  self.Texture = love.filesystem.read("resources/SVG/bonus_neutral_teleport.svg")
  self.Texture = tove.newGraphics(self.Texture)
  PowerUp.init(self, pos)
end

function PowerUpTeleport:usePowerUp(player)
  -- player.stats.teleport = true
end

return PowerUpTeleport