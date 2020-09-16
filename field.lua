HC = require 'lib.HC'
Class = require 'lib.hump.class'
tove = require 'lib.tove'
PowerUpBomb = require "powerUpBomb"
--Laden den oben gennanten Module

Field = Class{}
--Field als Objekt festlegen

function Field:init(pos, size, t , cords)
  self.type = t
  self.hitbox = HC.rectangle(pos.x , pos.y, size, size)
  local x,y = self.hitbox:center()
  self.position = vector.new(x, y)

  self.cords=cords
  self.hitbox.solid = (self.type == 'arena_greenwall' or self.type == 'arena_wall')
  self.hitbox.cords=self.cords
  self.Texture = love.filesystem.read("resources/SVG/" .. self.type .. '.svg')
  
  self.Texture = tove.newGraphics(self.Texture)
  self.Texture:rescale(40)
end
--Festlegen der Position der Mauer

function Field:__tostring()
  return string.format('type: %s', self.type)
end
--Konvertierung des Objekts Field zu String

function Field:draw()
  if self.type ~= 'air' then
    --self.hitbox:draw((self.type == 'wall') and 'fill' or 'line')
    love.graphics.translate(self.position.x, self.position.y)
    self.Texture:draw()
    love.graphics.translate(-self.position.x, -self.position.y)
  end
  if self.PowerUp ~= nil then
    self.PowerUp:draw()
  end
end
--Zeichnen der Linie der Hitbox

function Field:spawnPowerUp(position)
  local randomNumber = math.random(1, 15)
  randomNumber = 6
  -- Spiegel:
  if randomNumber == 1 then
    self.PowerUp = PowerUpMirror(position)
  
  -- Kaffee:
  elseif randomNumber == 2 then
    self.PowerUp = PowerUpCoffee(position)
  
  -- Fessel:
  elseif randomNumber == 3 then
    self.PowerUp = PowerUpRestrain(position)
  
  -- Wirft Bomben zu zufälligen Positionen (Scatty):
  elseif randomNumber == 4 then
    self.PowerUp = PowerUpScatty(position)
  
  -- Schnecke:
  elseif randomNumber == 5 then
    self.PowerUp = PowerUpSlow(position)
  
  -- bombe:
  elseif randomNumber == 6 then
    self.PowerUp = PowerUpBomb(position)
  -- Fußball:
  elseif randomNumber == 7 then
    self.PowerUp = PowerUpKick(position)
  
  -- Schaufel:
  elseif randomNumber == 8 then
    self.PowerUp = PowerUpMason(position)
  
  -- Zufallbox:
  elseif randomNumber == 9 then
    self.PowerUp = PowerUpPandora(position)
  
  -- Ein zufälliger Spieler wird nach dem Tod wiederbelebt (Resurrect):
  elseif randomNumber == 10 then
    self.PowerUp = PowerUpResurrect(position)
  
  -- Teleporter:
  elseif randomNumber == 11 then
    self.PowerUp = PowerUpTeleport()
  
  -- Power:
  elseif randomNumber == 12 then
    self.PowerUp = PowerUpPower()
  
  -- Schild:
  elseif randomNumber == 13 then
    self.PowerUp = PowerUpShield()
  
  -- Schneller bewegen:
  elseif randomNumber == 14 then
    self.PowerUp = PowerUpSpeed()
 
  -- Werfen:
  elseif randomNumber == 15 then
    self.PowerUp = PowerUpThrow()
    end
  
end

function Field:setType(t)
  self.type = t
  self.hitbox.solid = (self.type == 'arena_greenwall' or self.type == 'arena_wall')
  self.Texture = love.filesystem.read("resources/SVG/" .. self.type .. '.svg')
  self.Texture = tove.newGraphics(self.Texture)
  self.Texture:rescale(40)
end
--Festlegen des Types als HitBox

return Field
--Rückgabe des Objekts Field
