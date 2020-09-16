PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpSlow = Class.include{__includes = PowerUp}

function PowerUpSlow:init(cords) 
  PowerUp.init(self, cords)
end

function PowerUpSlow:usePowerUp(player)
  
end

function PowerUpSlow:draw()
  slow = love.filesystem.read("resources/SVG/bonus_bad_slow.svg")
  slow = tove.newGraphics(slow)
  slow:draw()
end

return PowerUpSlow