PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpRestrain = Class.include{__includes = PowerUp}

function PowerUpRestrain:init(cords) 
  PowerUp.init(self, cords)
end

function PowerUpRestrain:usePowerUp(player)
  
end

function PowerUpRestrain:draw()
  restrain = love.filesystem.read("resources/SVG/bonus_bad_restrain.svg")
  restrain = tove.newGraphics(restrain)
  restrain:draw()
end

return PowerUpRestrain