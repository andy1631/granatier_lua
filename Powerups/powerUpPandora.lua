PowerUp = require "powerUp"
Class = require "lib.hump.class"

local PowerUpPandora = Class {__includes = PowerUp}

function PowerUpPandora:init(pos,origin)
    self.Texture = love.filesystem.read("resources/SVG/bonus_neutral_pandora.svg")
    self.Texture = Tove.newGraphics(self.Texture)
    PowerUp.init(self, pos,origin)
end

function PowerUpPandora:usePowerUp(player)
    -- Zufälliges Power-Up auswählen:
    --  local x = (self.position.x - map.position.x) / 40
    --  local y = (self.position.y - map.position.y) / 40
    --  map.fields[x][y]:spawnPowerUp()
end

return PowerUpPandora
