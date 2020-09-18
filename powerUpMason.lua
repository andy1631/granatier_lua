PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpMason = Class{__includes = PowerUp}

function PowerUpMason:init(pos) 
  self.Texture = love.filesystem.read("resources/SVG/bonus_mason.svg")
  self.Texture = tove.newGraphics(self.Texture)
  PowerUp.init(self, pos)
end

function PowerUpMason:usePowerUp(player)
  -- player.stats.mason = true
end

return PowerUpMason