PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpScatty = Class.include(PowerUp)

function PowerUpScatty:init(cords) 
  PowerUp.init(self, cords)
end

function PowerUpScatty:usePowerUp(player)
  
end

function PowerUpScatty:draw()
  scatty = love.filesystem.read("resources/SVG/bonus_bad_scatty.svg")
  scatty = tove.newGraphics(scatty)
  scatty:draw()
end

return PowerUpScatty