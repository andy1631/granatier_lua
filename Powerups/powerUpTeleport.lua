PowerUp = require "powerUp"
Class = require "lib.hump.class"

local PowerUpTeleport = Class {__includes = PowerUp}

function PowerUpTeleport:init(pos,origin)
    self.Texture = love.filesystem.read("resources/SVG/bonus_neutral_teleport.svg")
    self.Texture = Tove.newGraphics(self.Texture)
    PowerUp.init(self, pos,origin)
end

function PowerUpTeleport:usePowerUp(player)
    -- player.stats.teleport = true
end

return PowerUpTeleport
