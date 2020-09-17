PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpMirror = Class{__includes = PowerUp}

function PowerUpMirror:init(pos) 
  self.Texture = love.filesystem.read("resources/SVG/bonus_bad_mirror.svg")
  self.Texture = tove.newGraphics(self.Texture)
  PowerUp.init(self, pos)
end

function PowerUpMirror:usePowerUp(player)
  
end

return PowerUpMirror