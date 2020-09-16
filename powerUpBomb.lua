PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpBomb = Class{__includes = PowerUp}

function PowerUpBomb:init(cords)
  PowerUp.init(self, cords)
  self.Texture = love.filesystem.read("resources/SVG/bonus_bomb.svg")
  self.Texture= tove.newGraphics(self.Texture)
end

function PowerUpBomb:usePowerUp(player)
  
end

function PowerUpBomb:draw()
  love.graphics.translate((self.cords.x - 1 * 40) + map.position.x, (self.cords.y - 1 * 40) + map.position.y)
  self.Texture:draw()
  love.graphics.translate(-((self.cords.x - 1 * 40) + map.position.x), -((self.cords.y - 1 * 40) + map.position.y))
end

return PowerUpBomb