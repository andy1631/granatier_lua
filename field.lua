HC = require 'lib.HC'
Class = require 'lib.hump.class'
tove = require 'lib.tove'
--Laden den oben gennanten Module

Field = Class{}
--Field als Objekt festlegen

function Field:init(pos, size, t)
  self.type = t
  self.hitbox = HC.rectangle(pos.x , pos.y, size, size)
  local x,y = self.hitbox:center()
  self.position = vector.new(x, y)

  self.hitbox.solid = (self.type == 'arena_greenwall' or self.type == 'arena_wall')
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
    self.hitbox:draw((self.type == 'wall') and 'fill' or 'line')
    love.graphics.translate(self.position.x, self.position.y)
    self.Texture:draw()
    love.graphics.translate(-self.position.x, -self.position.y)
  end
end
--Zeichnen der Linie der Hitbox

function Field:spawnPowerUp(type)
  randomNumber = math.random(1, 15)
  -- Spiegel:
  if randomNumber == 1 then
    self.PowerUp = PowerUpMirror()
  end
  -- Kaffee:
  if randomNumber == 2 then
    self.PowerUp = PowerUpCoffee()
  end
  -- Fessel:
  if randomNumber == 3 then
    self.PowerUp = PowerUpRestrain()
  end
  -- Wirft Bomben zu zufälligen Positionen (Scatty):
  if randomNumber == 4 then
    self.PowerUp = PowerUpScatty()
  end
  -- Schnecke:
  if randomNumber == 5 then
    self.PowerUp = PowerUpSlow()
  end
  -- Bombe:
  if randomNumber == 6 then
    self.PowerUp = PowerUpBomb()
  end
  -- Fußball:
  if randomNumber == 7 then
    self.PowerUp = PowerUpKick()
  end
  -- Schaufel:
  if randomNumber == 8 then
    self.PowerUp = PowerUpMason()
  end
  -- Zufallbox:
  if randomNumber == 9 then
    self.PowerUp = PowerUpPandora()
  end
  -- Ein zufälliger Spieler wird nach dem Tod wiederbelebt (Resurrect):
  if randomNumber == 10 then
    self.PowerUp = PowerUpResurrect()
  end
  -- Teleporter:
  if randomNumber == 11 then
    self.PowerUp = PowerUpTeleport()
  end
  -- Power:
  if randomNumber == 12 then
    self.PowerUp = PowerUpPower()
  end
  -- Schild:
  if randomNumber == 13 then
    self.PowerUp = PowerUpShield()
  end
  -- Schneller bewegen:
  if randomNumber == 14 then
    self.PowerUp = PowerUpSpeed()
  end
  -- Werfen:
  if randomNumber == 15 then
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
