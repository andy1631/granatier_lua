PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpBomb = Class.include(PowerUp)

function PowerUpBomb:init(cords) 
  PowerUp.init(PowerUpBomb, cords)
  bomb = love.filesystem.read("resources/SVG/bonus_bomb.svg")
  bomb = tove.newGraphics(bomb)
end

function PowerUpBomb:usePowerUp(player)
  
end

function PowerUpBomb:draw()
  bomb:draw()
end

return PowerUpBomb