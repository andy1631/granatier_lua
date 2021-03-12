PowerUp = require "powerUp"
Class = require "lib.hump.class"

local PowerUpMason = Class {__includes = PowerUp}

function PowerUpMason:init(pos, origin)
    --self.Texture = love.filesystem.read("resources/SVG/bonus_mason.svg")
    self.Texture = GetToveGraphics("bonus_mason", map.fieldSize)
    PowerUp.init(self, pos, origin)
end

function PowerUpMason:usePowerUp(player)
    -- player.stats.mason = true
end

return PowerUpMason
