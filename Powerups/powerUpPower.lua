PowerUp = require "powerUp"
Class = require "lib.hump.class"

local PowerUpPower = Class {__includes = PowerUp}

function PowerUpPower:init(pos, origin)
    --self.Texture = love.filesystem.read("resources/SVG/bonus_power.svg")
    self.Texture = Tove.newGraphics(Textures["bonus_power"])
    PowerUp.init(self, pos, origin)
end

function PowerUpPower:usePowerUp(player)
    player.stats.power = player.stats.power + 1
end

return PowerUpPower
