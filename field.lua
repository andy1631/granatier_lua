HC = require "lib.HC"
Class = require "lib.hump.class"
Tove = require "lib.tove"
PowerUpBomb = require "Powerups.powerUpBomb"
PowerUpCoffee = require "Powerups.powerUpCoffee"
PowerUpKick = require "Powerups.powerUpKick"
PowerUpMason = require "Powerups.powerUpMason"
PowerUpMirror = require "Powerups.powerUpMirror"
PowerUpPandora = require "Powerups.powerUpPandora"
PowerUpPower = require "Powerups.powerUpPower"
PowerUpRestrain = require "Powerups.powerUpRestrain"
PowerUpResurrect = require "Powerups.powerUpResurrect"
PowerUpScatty = require "Powerups.powerUpScatty"
PowerUpShield = require "Powerups.powerUpShield"
PowerUpSlow = require "Powerups.powerUpSlow"
PowerUpSpeed = require "Powerups.powerUpSpeed"
PowerUpTeleport = require "Powerups.powerUpTeleport"
PowerUpThrow = require "Powerups.powerUpThrow"
--Laden den oben gennanten Module

Field = Class {}
--Field als Objekt festlegen

function Field:init(pos, size, t, cords, origin)
    self.origin = origin
    self.size = size
    self.type = t
    self.hitbox = HC.rectangle(pos.x, pos.y, size, size)
    local x, y = self.hitbox:center()
    self.position = Vector.new(x, y) - origin
    self.hitboxshow = false
    self.cords = cords
    self.hitbox.solid = (self.type == "arena_greenwall" or self.type == "arena_wall")
    self.hitbox.cords = self.cords
    --self.TexturePath = Textures[self.type]
    self.bombs = 0
    self.Texture = Tove.newGraphics(Textures[self.type], self.size)
    self.pandora = false
    math.randomseed(os.time())
end
--Festlegen der Position der Mauer

function Field:__tostring()
    return string.format("type: %s", self.type)
end
--Konvertierung des Objekts Field zu String

function Field:draw()
    if self.type ~= "air" then
        self.Texture:draw(self.position.x + self.origin.x, self.position.y + self.origin.y)
    end
    if self.PowerUp ~= nil then
        self.PowerUp:draw()
    end
    if self.hitboxshow then
        love.graphics.setColor(255, 0, 0, 255)
        self.hitbox:draw((self.type == "wall") and "fill" or "line") -- shows hitbox
        love.graphics.setColor(255, 255, 255, 255)
    end
end
--Zeichnen der Linie der Hitbox

function Field:update(dt)
    if self.PowerUp ~= nil then
        for k, player in pairs(map.players) do
            if player.hitbox:collidesWith(self.hitbox) then
                if self.pandora then
                    self:spawnPowerUp()
                end
                if self.powerupNo < 6 and self.powerupNo > 0 then
                    if
                        player.stats.slow == false and player.stats.hyperactive == false and
                            player.stats.mirror == false and
                            player.stats.scatty == false and
                            player.stats.restrain == false
                     then
                        self.PowerUp:usePowerUp(player)
                    end
                else
                    self.PowerUp:usePowerUp(player)
                end
                self.PowerUp = nil
                self.powerupNo = nil
                local source = love.audio.newSource("resources/sounds/wow.wav", "static")
                love.audio.play(source)
            end
        end
    end
    if self.type == "arena_mine" then
        for k, player in pairs(map.players) do
            local collide, dx, dy = player.hitbox:collidesWith(self.hitbox)
            if collide and Vector.new(dx, dy):len() > (map.fieldSize / 2) then
                if map.fields[self.cords.x][self.cords.y].bombs == 0 then
                    local bomb =
                        Bomb(map.fields[self.cords.x][self.cords.y].position, 1, self.cords, map.position, player.id)
                    map.bombs[#map.bombs + 1] = bomb
                    bomb.time = 0
                    map.fields[self.cords.x][self.cords.y].bombs = 1
                    self:setType("arena_ground")
                end
            end
        end
    end
end

function Field:spawnPowerUp(number)
    local randomNumber
    if number == nil then
        randomNumber = math.random(1, 18)
    else
        randomNumber = number
    end
    --randomNumber = 12
    -- Spiegel:
    if randomNumber == 1 then
        -- Kaffee:
        self.PowerUp = PowerUpMirror(self.position, self.origin)
    elseif randomNumber == 2 then
        -- Fessel:
        self.PowerUp = PowerUpCoffee(self.position, self.origin)
    elseif randomNumber == 3 then
        -- Wirft Bomben zu zufälligen Positionen (Scatty):
        self.PowerUp = PowerUpRestrain(self.position, self.origin)
    elseif randomNumber == 4 then
        -- Schnecke:
        self.PowerUp = PowerUpScatty(self.position, self.origin)
    elseif randomNumber == 5 then
        -- Bombe:
        self.PowerUp = PowerUpSlow(self.position, self.origin)
    elseif randomNumber == 6 then
        -- Fußball:
        self.PowerUp = PowerUpThrow(self.position, self.origin)
    elseif randomNumber == 7 then
        -- Werfen:
        self.PowerUp = PowerUpKick(self.position, self.origin)
    elseif randomNumber == 8 then
        -- Zufallbox:
        self.PowerUp = PowerUpBomb(self.position, self.origin)
    elseif randomNumber == 9 then
        -- Power:
        self.PowerUp = PowerUpPandora(self.position, self.origin)
        self.pandora = true
    elseif randomNumber == 10 then
        -- Schild:
        self.PowerUp = PowerUpPower(self.position, self.origin)
    elseif randomNumber == 11 then
        -- Schneller bewegen:
        self.PowerUp = PowerUpShield(self.position, self.origin)
    elseif randomNumber == 12 then
        -- Teleporter:  --no fuctionality
        self.PowerUp = PowerUpSpeed(self.position, self.origin)
    elseif randomNumber == 26 then
        -- Ein zufälliger Spieler wird nach dem Tod wiederbelebt (Resurrect): --no functionality
        self.PowerUp = PowerUpTeleport(self.position, self.origin)
    elseif randomNumber == 27 then
        -- Mauern bauen:  no functionality
        self.PowerUp = PowerUpResurrect(self.position, self.origin)
    elseif randomNumber == 28 then
        self.PowerUp = PowerUpMason(self.position, self.origin)
    end
    if self.PowerUp ~= nil then
        self.powerupNo = randomNumber
    end
end

function Field:setType(t)
    if t ~= self.type then
        self.type = t
        self.hitbox.solid = (self.type == "arena_greenwall" or self.type == "arena_wall")
        self.Texture = Tove.newGraphics(Textures[self.type], self.size)
    end
end

function Field:getType()
    return self.type
end
--Festlegen des Types als HitBox

function Field:getData()
    local hx, hy = self.hitbox:center()
    local data = {
        ["type"] = self.type,
        hitbox = {x = hx, y = hy, solid = self.hitbox.solid},
        position = {x = self.position.x, y = self.position.y},
        hitboxshow = self.hitboxshow,
        cords = {x = self.cords.x, y = self.cords.y},
        bombs = self.bombs,
        pandora = self.pandora,
        powerup = self.powerupNo
    }
    return data
end

function Field:setData(data)
    self:setType(data.type)
    --self.type = data.type
    self.hitbox:moveTo(data.hitbox.x, data.hitbox.y)
    self.hitbox.solid = data.hitbox.solid
    self.hitbox.cords = self.cords
    self.position.x = data.position.x
    self.position.y = data.position.y
    self.hitboxshow = data.hitboxshow
    self.cords.x = data.cords.x
    self.cords.y = data.cords.y
    self.bombs = data.bombs
    self.pandora = data.pandora
    self.powerupNo = nil
    self.PowerUp = nil
    if data.powerup ~= nil then
        self:spawnPowerUp(data.powerup)
    end
end

function Field:hasPlayer()
    for k, v in pairs(map.players) do
        local collide, dx, dy = v.hitbox:collidesWith(self.hitbox)
        if collide and Vector.new(dx, dy):len() > (map.fieldSize / 2) then
            return true
        else
            return false
        end
    end
end

return Field
--Rückgabe des Objekts Field
