PowerUp = require "powerUp"
Class = require "lib.hump.class"

local PowerUpThrow = Class {__includes = PowerUp}

function PowerUpThrow:init(pos,origin)
    self.Texture = love.filesystem.read("resources/SVG/bonus_throw.svg")
    self.Texture = Tove.newGraphics(self.Texture)
    PowerUp.init(self, pos,origin)
end

function PowerUpThrow:usePowerUp(player)
    player.stats.throw = true
end

return PowerUpThrow
