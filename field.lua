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

function Field:init(pos, size, t, cords)
    self.type = t
    self.hitbox = HC.rectangle(pos.x, pos.y, size, size)
    local x, y = self.hitbox:center()
    self.position = Vector.new(x, y)
    self.hitboxshow = false
    self.cords = cords
    self.hitbox.solid = (self.type == "arena_greenwall" or self.type == "arena_wall")
    self.hitbox.cords = self.cords
    self.Texture = love.filesystem.read("resources/SVG/" .. self.type .. ".svg")
    self.bombs = 0
    self.Texture = Tove.newGraphics(self.Texture)
    self.Texture:rescale(40)
    self.pandora = false
end
--Festlegen der Position der Mauer

function Field:__tostring()
    return string.format("type: %s", self.type)
end
--Konvertierung des Objekts Field zu String

function Field:draw()
    if self.type ~= "air" then
        self.Texture:draw(self.position.x, self.position.y)
    end
    if self.PowerUp ~= nil then
        self.PowerUp:draw()
    end
    if self.hitboxshow then
        love.graphics.setColor(255,0,0,255)
        self.hitbox:draw((self.type == 'wall') and 'fill' or 'line') -- shows hitbox
        love.graphics.setColor(255,255,255,255)
    end
end
--Zeichnen der Linie der Hitbox

function Field:update(dt)
    if self.PowerUp ~= nil then
        local collide, dx, dy = map.players[0].hitbox:collidesWith(self.hitbox)
        if collide and (dx > 1 or dx < -1 or dy > 1 or dy < -1) then
            if self.pandora then
                self:spawnPowerUp()
            end
            self.PowerUp:usePowerUp(map.players[0])
            self.PowerUp = nil
            source = love.audio.newSource("resources/sounds/wow.wav", "static")
            love.audio.play(source)
        end
    end
end

function Field:spawnPowerUp()
  local randomNumber = math.random(1, 18)
  -- Spiegel:
  if randomNumber == 1 then
    self.PowerUp = PowerUpMirror(self.position)

  -- Kaffee:
  elseif randomNumber == 2 then
    self.PowerUp = PowerUpCoffee(self.position)
  
  -- Fessel:
  elseif randomNumber == 3 then
    self.PowerUp = PowerUpRestrain(self.position)
  
  -- Wirft Bomben zu zufälligen Positionen (Scatty):
  elseif randomNumber == 4 then
    self.PowerUp = PowerUpScatty(self.position)
  
  -- Schnecke:
  elseif randomNumber == 5 then
    self.PowerUp = PowerUpSlow(self.position)
  
  -- Bombe:
elseif randomNumber == 6 then
    self.PowerUp = PowerUpThrow(self.position)
  
  -- Fußball:
  elseif randomNumber == 7 then
    self.PowerUp = PowerUpKick(self.position)
  
  -- Werfen:
  elseif randomNumber == 8 then
    self.PowerUp = PowerUpBomb(self.position)
  
  -- Zufallbox:
  elseif randomNumber == 9 then
    self.PowerUp = PowerUpPandora(self.position)
    self.pandora = true
  -- Power:
  elseif randomNumber == 10 then
    self.PowerUp = PowerUpPower(self.position)
  
  -- Schild:
  elseif randomNumber == 11 then
    self.PowerUp = PowerUpShield(self.position)
  
  -- Schneller bewegen:
  elseif randomNumber == 12 then
    self.PowerUp = PowerUpSpeed(self.position)
    
    -- Teleporter:  --no fuctionality
  elseif randomNumber == 26 then
    self.PowerUp = PowerUpTeleport(self.position)
    
    -- Ein zufälliger Spieler wird nach dem Tod wiederbelebt (Resurrect): --no functionality
  elseif randomNumber == 27 then
    self.PowerUp = PowerUpResurrect(self.position)
 
  -- Mauern bauen:  no functionality
  elseif randomNumber == 28 then
    self.PowerUp = PowerUpMason(self.position)
    end
end

function Field:setType(t)
    self.type = t
    self.hitbox.solid = (self.type == "arena_greenwall" or self.type == "arena_wall")
    self.Texture = love.filesystem.read("resources/SVG/" .. self.type .. ".svg")
    self.Texture = Tove.newGraphics(self.Texture)
    self.Texture:rescale(40)
end

function Field:getType()
    return self.type
end
--Festlegen des Types als HitBox

function setData(data)
  self.type = data.type
  self.hitbox:moveTo(data.hitbox.x,data.hitbox.y)
  self.hitbox.solid=data.hitbox.solid
  self.hitbox.cords=self.cords
  self.position.x = data.position.x
  self.position.y = data.position.y
  self.hitboxshow = data.hitboxshow
  self.cords.x = data.cords.x
  self.cords.y = data.cords.y
  self.bombs = data.bombs
  self.pandora = data.pandora
  self:spawnPowerUp(data.powerup)
  end

return Field
--Rückgabe des Objekts Field
