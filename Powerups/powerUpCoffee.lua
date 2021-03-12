PowerUp = require "powerUp"
Class = require "lib.hump.class"

local PowerUpCoffee = Class {__includes = PowerUp}

function PowerUpCoffee:init(pos, origin)
    --self.Texture = love.filesystem.read("resources/SVG/bonus_bad_hyperactive.svg")
    self.Texture = GetToveGraphics("bonus_bad_hyperactive", map.fieldSize)
    PowerUp.init(self, pos, origin)
end

function PowerUpCoffee:usePowerUp(player)
    player.stats.hyperactive = true
end

return PowerUpCoffee
