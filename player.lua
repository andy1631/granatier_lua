HC = require 'lib.HC'
Vector = require 'lib.hump.vector'
Class = require 'lib.hump.class'
tove = require 'lib.tove'
--Laden der oben genannten Module

Player = Class{}

--Player wird als Objekt festgelegt
   function Player:init(x, y, id)
    self.hitbox = HC.rectangle(x or 0, y or 0, 40, 40)
    local posX, posY = self.hitbox:center()
    self.position = Vector.new(posX or 0, posY or 0)
    self.velocity = Vector.new(0, 0)
    self.acceleration = 30
    self.frictionRatio = 0.3
    self.direction = "right"
    self.movement = false
    self.powerUpTime = 10
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
    player = love.filesystem.read("resources/player2.svg")
    myPlayer = tove.newGraphics(player)
    myPlayer:rescale(38)
  end
  --Anzeige der SVG-Spielers
  function Player:__tostring()
    return string.format("x = %.16g, y = %.16g", self.position:unpack())
  end
  --ÜBergabe der aktuellen Position des Spielers als String
  function Player:draw()
    local dir=0
    love.graphics.translate(self.position.x, self.position.y)
    if self.direction == "up" then
      love.graphics.rotate(-math.pi / 2)
      dir = math.pi / 2
    elseif self.direction == "down" then
      love.graphics.rotate(math.pi / 2)
      dir = -math.pi / 2
    elseif self.direction == "left" then
      love.graphics.rotate(math.pi)
      dir = -math.pi
    end
    --Rotation des Spielers bei Richtungswechsel
    myPlayer:draw()
    love.graphics.rotate(dir)
    love.graphics.translate(-(self.position.x), -(self.position.y))
    --love.graphics.setColor(255,255,255,1)
    --self.hitbox:draw('line')
    --Zeigen der Spielfigur und zeichnen der HitBox
  end
  function Player:move(x, y)
    self.velocity = (self.velocity + self.acceleration * Vector.new(x, y))
    if x == 0 then self.velocity.x = 0 elseif y == 0 then self.velocity.y = 0 end
  end
  --Bewegen des Spielers
  function Player:update(dt)
    if self.stats.slow then
      self.acceleration = 15
      self.powerUpTime = self.powerUpTime - dt
    else
      self.acceleration = 30
    end
    if self.powerUpTime <= 0 then
      self.powerUpTime = 10 -- Die Zeit des aktiven Power-Ups zurücksetzen
      self.speedBoost = 0
      self.bombs = 1
      self.power = 1
      self.stats.shield = false
      self.stats.throw = false
      self.stats.kick = false
      self.stats.slow = false
      self.stats.hyperactive = false
      self.stats.mirror = false
      self.stats.scatty = false
      self.stats.restrain = false
    end
    if self.movement then
      local x, y
     if self.direction == 'left' then x = -1 elseif self.direction == 'right' then x = 1 else x = 0 end
     if self.direction == 'up' then y = -1 elseif self.direction == 'down' then y = 1 else y = 0 end
        self:move(x,y)
    end
    local vec = self:getRelPos()
    if map.fields[vec.x][vec.y]:getType() == 'arena_ice' then
      self.frictionRatio=0.1
    else
      self.frictionRatio=0.3
    end

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
  end
   --Update-Funktion (Aktualisieren der UI)
  function Player:setPosition(x, y)
    self.position = Vector.new(x, y)
    self.hitbox:moveTo(self.position.x, self.position.y)
  end
  
  function Player:collision(v)
    if (v.y > 0 and v.x == 0 and self.direction == 'up') 
    or (v.y < 0 and v.x == 0 and self.direction == 'down')
    or (v.x > 0 and v.y == 0 and self.direction == 'left')
    or (v.x < 0 and v.y == 0 and self.direction == 'right')
    then
    self.velocity.x = 0
    self.velocity.y = 0
    self.hitbox:move(v.x, v.y)
    local posX, posY = self.hitbox:center()
    self.position = Vector.new(posX or 0, posY or 0)
    end
  end
  --Bewegung der Hitbox
  function Player:setId(id)
    self.id = id
    self.hitbox.PlayerId = self.id
  end
  
  --Zuweisen der HitBox zu einem Spieler

function Player:getRelPos()
  local col={}
  local cords={}
  for shape, delta in pairs(HC.collisions(self.hitbox)) do
    if shape.cords ~= nil then
      col[#col+1] = vector.new(delta.x,delta.y):len()
      cords[#cords+1] = shape.cords
    end
  end
  col[0]=0
  local index=0
  for k,v in pairs(col) do
    if v~=0 then
      if col[index]<v then
      index=k
      end
    end
  end
  return cords[index]
end

function Player:playerOnField(pos)
    local collide, dx, dy = map.fields[pos.x][pos.y].hitbox:collidesWith(self.hitbox)
    if collide and (dx~=0 or dy~=0) then            
      return true
    else
      return false
    end
  end

function Player:die() 
  
  end
return Player
--Rückgabe des Objekts Player