PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpBomb = Class.include(PowerUp)

function PowerUpBomb:init(cords) 
  PowerUp.init(self, cords)
end

function PowerUpBomb:usePowerUp(player)
  
end

function PowerUpBomb:draw()
  bomb = love.filesystem.read("resources/SVG/bonus_bomb.svg")
  bomb = tove.newGraphics(bomb)
  bomb:draw()
end

return PowerUpBomb