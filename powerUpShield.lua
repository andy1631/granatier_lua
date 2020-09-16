PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpShield = Class.include{__includes = PowerUp}

function PowerUpShield:init(cords) 
  PowerUp.init(self, cords)
end

function PowerUpShield:usePowerUp(player)
  
end

function PowerUpShield:draw()
  shield = love.filesystem.read("resources/SVG/bonus_shield.svg")
  shield = tove.newGraphics(shield)
  shield:draw()
end

return PowerUpShield