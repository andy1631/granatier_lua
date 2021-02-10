PowerUp = require "powerUp"
Class = require "lib.hump.class"

local PowerUpShield = Class {__includes = PowerUp}

function PowerUpShield:init(pos)
    self.Texture = love.filesystem.read("resources/SVG/bonus_shield.svg")
    self.Texture = Tove.newGraphics(self.Texture)
    PowerUp.init(self, pos)
end

function PowerUpShield:usePowerUp(player)
    player.stats.shield = true
end

return PowerUpShield
