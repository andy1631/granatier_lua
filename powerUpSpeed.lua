PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpSpeed = Class.include{__includes = PowerUp}

function PowerUpSpeed:init(cords) 
  PowerUp.init(self, cords)
end

function PowerUpSpeed:usePowerUp(player)
  
end

function PowerUpSpeed:draw()
  speed = love.filesystem.read("resources/SVG/bonus_speed.svg")
  speed = tove.newGraphics(speed)
  speed:draw()
end

return PowerUpSpeed