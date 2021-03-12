PowerUp = require "powerUp"
Class = require "lib.hump.class"

local PowerUpResurrect = Class {__includes = PowerUp}

function PowerUpResurrect:init(pos, origin)
    --self.Texture = love.filesystem.read("resources/SVG/bonus_neutral_resurrect.svg")
    self.Texture = GetToveGraphics("bonus_neutral_resurrect", map.fieldSize)
    PowerUp.init(self, pos, origin)
end

function PowerUpResurrect:usePowerUp(player)
    -- player.stats.resurrect = true
end

return PowerUpResurrect
