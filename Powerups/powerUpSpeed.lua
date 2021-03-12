PowerUp = require "powerUp"
Class = require "lib.hump.class"

local PowerUpSpeed = Class {__includes = PowerUp}

function PowerUpSpeed:init(pos, origin)
    --self.Texture = love.filesystem.read("resources/SVG/bonus_speed.svg")
    self.Texture = GetToveGraphics("bonus_speed", map.fieldSize)
    PowerUp.init(self, pos, origin)
end

function PowerUpSpeed:usePowerUp(player)
    player.stats.speedBoost = player.stats.speedBoost + 1
end

return PowerUpSpeed
