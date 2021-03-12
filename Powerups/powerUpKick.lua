PowerUp = require "powerUp"
Class = require "lib.hump.class"

local PowerUpKick = Class {__includes = PowerUp}

function PowerUpKick:init(pos, origin)
    --self.Texture = love.filesystem.read("resources/SVG/bonus_kick.svg")
    self.Texture = GetToveGraphics("bonus_kick", map.fieldSize)
    PowerUp.init(self, pos, origin)
end

function PowerUpKick:usePowerUp(player)
    player.stats.kick = true
end

return PowerUpKick
