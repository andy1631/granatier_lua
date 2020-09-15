PowerUp = require "powerUp"
Class = require 'lib.hump.class'

local PowerUpTeleport = Class.include(PowerUp)

function PowerUpTeleport:init(cords) 
  PowerUp.init(self, cords)
end

function PowerUpTeleport:usePowerUp(player)
  
end

function PowerUpTeleport:draw()
  teleport = love.filesystem.read("resources/SVG/bonus_neutral_teleport.svg")
  teleport = tove.newGraphics(teleport)
  teleport:draw()
end

return PowerUpTeleport