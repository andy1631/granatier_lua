PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpPandora = Class.include{__includes = PowerUp}

function PowerUpPandora:init(cords) 
  PowerUp.init(self, cords)
end

function PowerUpPandora:usePowerUp(player)
  
end

function PowerUpPandora:draw()
  pandora = love.filesystem.read("resources/SVG/bonus_neutral_pandora.svg")
  pandora = tove.newGraphics(pandora)
  pandora:draw()
end

return PowerUpPandora