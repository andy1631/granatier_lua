PowerUp = require "powerUp"
Class = require "lib.hump.class"

local PowerUpBomb = Class {__includes = PowerUp}

function PowerUpBomb:init(pos,origin)
    self.Texture = love.filesystem.read("resources/SVG/bonus_bomb.svg")
    self.Texture = Tove.newGraphics(self.Texture)
    PowerUp.init(self, pos,origin)
end

function PowerUpBomb:usePowerUp(player)
    player.stats.bombs = player.stats.bombs + 1
    -- HC.remove(self.hitbox)
end

return PowerUpBomb
