PowerUp = require "powerUp"
Class = require "lib.hump.class"

local PowerUpMirror = Class {__includes = PowerUp}

function PowerUpMirror:init(pos,origin)
    self.Texture = love.filesystem.read("resources/SVG/bonus_bad_mirror.svg")
    self.Texture = Tove.newGraphics(self.Texture)
    PowerUp.init(self, pos,origin)
end

function PowerUpMirror:usePowerUp(player)
    player.stats.mirror = true
end

return PowerUpMirror
