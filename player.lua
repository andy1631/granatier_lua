HC = require 'lib.HC'
Vector = require 'lib.hump.vector'
Class = require 'lib.hump.class'
tove = require 'lib.tove'
--Laden der oben genannten Module

Player = Class{
  --Player wird als Objekt festgelegt
  init = function(self, x, y, id)
    self.hitbox = HC.rectangle(x or 0, y or 0, 35, 35)
    local posX, posY = self.hitbox:center()
    self.position = Vector.new(posX or 0, posY or 0)
    self.velocity = Vector.new(0, 0)
    self.acceleration = 20
    self.frictionRatio = 0.1
    --Position des Spielers und Standardwerte
    self.stats = {
      speedBoost = 0, 
      bombs = 1,
      power = 1,
      shield = false,
      throw = false,
      kick = false,
      slow = false,
      hyperactive = false,
      mirror = false,
      scatty = false,
      restrain = false
    }
    --Standard-Boni und Ort ob und falls wie viele Power-Ups aktiv sind
    self.id = id or 0
    self.hitbox.playerId = self.id
  end,
  __tostring = function(self)
    return string.format("x = %.16g, y = %.16g", self.position:unpack())
  end,
  draw = function(self)
    love.graphics.setColor(255,255,255,1)
    self.hitbox:draw('line')
  end,
  move = function(self, x, y)
    self.velocity = (self.velocity + self.acceleration * Vector.new(x, y))
  end,
  update = function(self, dt)

    local frictionVector = self.velocity * self.frictionRatio

    self.velocity = self.velocity - frictionVector

    self.hitbox:move(self.velocity.x * dt, self.velocity.y * dt)
    local x,y = self.hitbox:center()
    self.position = Vector.new(x, y)

    for shape, delta in pairs(HC.collisions(self.hitbox)) do
      if shape.solid then
        self:collision(vector.new(delta.x, delta.y))
      end
    end

  end,
  setPosition = function(self, x, y)
    self.position = Vector.new(x, y)
    self.hitbox:moveTo(self.position.x, self.position.y)
  end,
  collision = function(self, v)
    --self.velocity = Vector.new(0, 0)
    self.hitbox:move(v.x, v.y)
    local posX, posY = self.hitbox:center()
    self.position = Vector.new(posX or 0, posY or 0)
  end,
  setId = function(self, id)
    self.id = id
    self.hitbox.PlayerId = self.id
  end
}


return Player
--Rückgabe des Objekts Player