HC = require 'lib.HC'
Timer = require 'lib.hump.timer'
Class = require 'lib.hump.class'
tove = require 'lib.tove'


Bomb = Class{}


function Bomb:init(pos, power,cords)
  self.position = pos
  self.power = power
  self.time = 3
  self.hitbox = HC.circle(self.position.x,self.position.y, 17.5)
  self.toDelete = false
  self.cords=cords
  self.hitbox.solid = true
  self.bomb = love.filesystem.read("resources/SVG/bomb.svg")
  self.bomb = tove.newGraphics(self.bomb)
  self.bomb:rescale(35)
end

function Bomb:draw()
  --self.hitbox:draw()  
  love.graphics.translate(self.position.x, self.position.y)
  self.bomb:draw()
  love.graphics.translate(-self.position.x, -self.position.y)
end

function Bomb:update(dt)
  self.time = self.time - dt
  if self.time <= 0 then
    self:explode()
    end
end

function Bomb:explode()
  source = love.audio.newSource( 'resources/sounds/explode.wav' , 'static' )
  love.audio.play(source)
  self.toDelete = true
  map.fields[self.cords.x][self.cords.y].bombs=0
  map.players[0].stats.bombs=map.players[0].stats.bombs+1
  for i=1,self.power,1 do
    if map.fields[self.cords.x+i][self.cords.y]:getType() == "arena_wall" then
      map.fields[self.cords.x+i][self.cords.y]:setType("arena_ground")
      map.fields[self.cords.x+i][self.cords.y]:spawnPowerUp()
      break
    end
    if map.fields[self.cords.x+i][self.cords.y]:getType() == "arena_greenwall" then
      break
    end
  end
  for i=1,self.power,1 do
    if map.fields[self.cords.x-i][self.cords.y]:getType() == "arena_wall" then
      map.fields[self.cords.x-i][self.cords.y]:setType("arena_ground")
      map.fields[self.cords.x-i][self.cords.y]:spawnPowerUp()
      break
    end
    if map.fields[self.cords.x-i][self.cords.y]:getType() == "arena_greenwall" then
      break
    end
  end
  for i=1,self.power,1 do
    if map.fields[self.cords.x][self.cords.y+i]:getType() == "arena_wall" then
      map.fields[self.cords.x][self.cords.y+i]:setType("arena_ground")
      map.fields[self.cords.x][self.cords.y+i]:spawnPowerUp()
      break
    end
    if map.fields[self.cords.x][self.cords.y+i]:getType() == "arena_greenwall" then
      break
    end
  end
  for i=1,self.power,1 do
    if map.fields[self.cords.x][self.cords.y-i]:getType() == "arena_wall" then
      map.fields[self.cords.x][self.cords.y-i]:setType("arena_ground")
      map.fields[self.cords.x][self.cords.y-i]:spawnPowerUp()
      break
    end
    if map.fields[self.cords.x][self.cords.y-i]:getType() == "arena_greenwall" then
      break
    end
  end
  HC.remove(self.hitbox)
end
return Bomb