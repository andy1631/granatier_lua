PowerUp = require "powerUp"
Class = require "lib.hump.class"

local PowerUpSlow = Class {__includes = PowerUp}

function PowerUpSlow:init(pos,origin)
    self.Texture = love.filesystem.read("resources/SVG/bonus_bad_slow.svg")
    self.Texture = Tove.newGraphics(self.Texture)
    PowerUp.init(self, pos,origin)
end

function PowerUpSlow:usePowerUp(player)
    player.stats.slow = true
end

return PowerUpSlow
