PowerUp = require "powerUp"
Class = require "lib.hump.class"

local PowerUpShield = Class {__includes = PowerUp}

function PowerUpShield:init(pos, origin)
    --self.Texture = love.filesystem.read("resources/SVG/bonus_shield.svg")
    self.Texture = GetToveGraphics("bonus_shield", map.fieldSize)
    PowerUp.init(self, pos, origin)
end

function PowerUpShield:usePowerUp(player)
    player.stats.shield = true
end

return PowerUpShield
