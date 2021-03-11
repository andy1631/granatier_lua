PowerUp = require "powerUp"
Class = require "lib.hump.class"

local PowerUpRestrain = Class {__includes = PowerUp}

function PowerUpRestrain:init(pos, origin)
    --self.Texture = love.filesystem.read("resources/SVG/bonus_bad_restrain.svg")
    self.Texture = Tove.newGraphics(Textures["bonus_bad_restrain"])
    PowerUp.init(self, pos, origin)
end

function PowerUpRestrain:usePowerUp(player)
    player.stats.restrain = true
end

return PowerUpRestrain
