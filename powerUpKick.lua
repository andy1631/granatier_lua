PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpKick = Class.include(PowerUp)

function PowerUpKick:init(cords) 
  PowerUp.init(self, cords)
end

function PowerUpKick:usePowerUp(player)
  
end

function PowerUpKick:draw()
  kick = love.filesystem.read("resources/SVG/bonus_kick.svg")
  kick = tove.newGraphics(kick)
  kick:draw()
end

return PowerUpKick