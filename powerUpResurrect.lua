PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpResurrect = Class{__includes = PowerUp}

function PowerUpResurrect:init(pos) 
  self.Texture = love.filesystem.read("resources/SVG/bonus_neutral_resurrect.svg")
  self.Texture = tove.newGraphics(self.Texture)
  PowerUp.init(self, pos)
end

function PowerUpResurrect:usePowerUp(player)
  -- player.stats.resurrect = true
end

return PowerUpResurrect