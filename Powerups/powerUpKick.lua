PowerUp = require "powerUp"
Class = require "lib.hump.class"

local PowerUpKick = Class {__includes = PowerUp}

function PowerUpKick:init(pos, origin)
    --self.Texture = love.filesystem.read("resources/SVG/bonus_kick.svg")
    self.Texture = Tove.newGraphics(Textures["bonus_kick"])
    PowerUp.init(self, pos, origin)
end

function PowerUpKick:usePowerUp(player)
    player.stats.kick = true
end

return PowerUpKick
