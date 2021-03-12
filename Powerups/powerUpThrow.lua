PowerUp = require "powerUp"
Class = require "lib.hump.class"

local PowerUpThrow = Class {__includes = PowerUp}

function PowerUpThrow:init(pos, origin)
    --self.Texture = love.filesystem.read("resources/SVG/bonus_throw.svg")
    self.Texture = GetToveGraphics("bonus_throw", map.fieldSize)
    PowerUp.init(self, pos, origin)
end

function PowerUpThrow:usePowerUp(player)
    player.stats.throw = true
end

return PowerUpThrow
