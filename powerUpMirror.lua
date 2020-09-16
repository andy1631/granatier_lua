PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpMirror = Class.include{__includes = PowerUp}

function PowerUpMirror:init(pos) 
  PowerUp.init(self, pos)
  self.Texture = love.filesystem.read("resources/SVG/bonus_bad_mirror.svg")
  self.Texture = tove.newGraphics(self.Texture)
end

function PowerUpMirror:usePowerUp(player)
  
end

return PowerUpMirror