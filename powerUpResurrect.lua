PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpResurrect = Class.include{__includes = PowerUp}

function PowerUpResurrect:init(cords) 
  PowerUp.init(self, cords)
end

function PowerUpResurrect:usePowerUp(player)
  
end

function PowerUpResurrect:draw()
  resurrect = love.filesystem.read("resources/SVG/bonus_neutral_resurrect.svg")
  resurrect = tove.newGraphics(resurrect)
  resurrect:draw()
end

return PowerUpResurrect