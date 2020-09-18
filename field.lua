HC = require 'lib.HC'
Class = require 'lib.hump.class'
tove = require 'lib.tove'
PowerUpBomb = require "powerUpBomb"
PowerUpCoffee = require "powerUpCoffee"
PowerUpKick = require "powerUpKick"
PowerUpMason = require "powerUpMason"
PowerUpMirror = require "powerUpMirror"
PowerUpPandora = require "powerUpPandora"
PowerUpPower = require "powerUpPower"
PowerUpRestrain = require "powerUpRestrain"
PowerUpResurrect = require "powerUpResurrect"
PowerUpScatty = require "powerUpScatty"
PowerUpShield = require "powerUpShield"
PowerUpSlow = require "powerUpSlow"
PowerUpSpeed = require "powerUpSpeed"
PowerUpTeleport = require "powerUpTeleport"
PowerUpThrow = require "powerUpThrow"
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
  self.bombs=0
  self.Texture = tove.newGraphics(self.Texture)
  self.Texture:rescale(40)
  local pandora = false
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
  if self.PowerUp ~= nil then
    self.PowerUp:draw()
  end
end
--Zeichnen der Linie der Hitbox

function Field:update(dt)
  if self.PowerUp ~= nil then
<<<<<<< Updated upstream
    local collide, dx, dy = map.players[0].hitbox:collidesWith(self.hitbox)
    if collide and (dx~=0 or dy~=0) then            
        self.PowerUp:usePowerUp(map.players[0])
        self.PowerUp = nil
        source = love.audio.newSource( 'resources/sounds/wow.wav' , 'static' )
        love.audio.play(source)
=======
    if map.players[0].hitbox:collidesWith(self.hitbox) then
      if self.pandora then
        self:spawnPowerUp()
      end
      self.PowerUp:usePowerUp(map.players[0])
      self.PowerUp = nil
>>>>>>> Stashed changes
    end
  end
end

function Field:spawnPowerUp()
  local randomNumber = math.random(8, 10)
  -- local pandora = false
  --if pandora == false then
    -- randomNumber = 9
  --else
    --randomNumber = 6
  --end
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
    self.PowerUp = PowerUpBomb(self.position)
  
  -- Fußball:
  elseif randomNumber == 7 then
    self.PowerUp = PowerUpKick(self.position)
  
  -- Schaufel:
  elseif randomNumber == 8 then
    self.PowerUp = PowerUpMason(self.position)
  
  -- Zufallbox:
  elseif randomNumber == 9 then
    self.PowerUp = PowerUpPandora(self.position)
    self.pandora = true
    self:spawnPowerUp()
  -- Ein zufälliger Spieler wird nach dem Tod wiederbelebt (Resurrect):
  elseif randomNumber == 10 then
    self.PowerUp = PowerUpResurrect(self.position)
  
  -- Teleporter:
  elseif randomNumber == 11 then
    self.PowerUp = PowerUpTeleport(self.position)
  
  -- Power:
  elseif randomNumber == 12 then
    self.PowerUp = PowerUpPower(self.position)
  
  -- Schild:
  elseif randomNumber == 13 then
    self.PowerUp = PowerUpShield(self.position)
  
  -- Schneller bewegen:
  elseif randomNumber == 14 then
    self.PowerUp = PowerUpSpeed(self.position)
 
  -- Werfen:
  elseif randomNumber == 15 then
    self.PowerUp = PowerUpThrow(self.position)
    end
  
end

function Field:setType(t)
  self.type = t
  self.hitbox.solid = (self.type == 'arena_greenwall' or self.type == 'arena_wall')
  self.Texture = love.filesystem.read("resources/SVG/" .. self.type .. '.svg')
  self.Texture = tove.newGraphics(self.Texture)
  self.Texture:rescale(40)
end

function Field:getType()
  return self.type
end
--Festlegen des Types als HitBox

return Field
--Rückgabe des Objekts Field
