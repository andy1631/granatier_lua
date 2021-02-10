PowerUp = require "powerUp"
Class = require "lib.hump.class"

local PowerUpPower = Class {__includes = PowerUp}

function PowerUpPower:init(pos)
    self.Texture = love.filesystem.read("resources/SVG/bonus_power.svg")
    self.Texture = Tove.newGraphics(self.Texture)
    PowerUp.init(self, pos)
end

function PowerUpPower:usePowerUp(player)
    player.stats.power = player.stats.power + 1
end

return PowerUpPower
