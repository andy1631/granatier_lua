PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpMason = Class.include{__includes = PowerUp}

function PowerUpMason:init(cords) 
  PowerUp.init(self, cords)
end

function PowerUpMason:usePowerUp(player)
  
end

function PowerUpMason:draw()
  mason = love.filesystem.read("resources/SVG/bonus_mason.svg")
  mason = tove.newGraphics(mason)
  mason:draw()
end

return PowerUpMason