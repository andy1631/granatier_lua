PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpMirror = Class.include(PowerUp)

function PowerUpMirror:init(cords) 
  PowerUp.init(self, cords)
end

function PowerUpMirror:usePowerUp(player)
  
end

function PowerUpMirror:draw()
  mirror = love.filesystem.read("resources/SVG/bonus_bad_mirror.svg")
  mirror = tove.newGraphics(mirror)
  mirror:draw()
end

return PowerUpMirror