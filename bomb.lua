HC = require 'lib.HC'
Timer = require 'lib.hump.timer'
Class = require 'lib.hump.class'
tove = require 'lib.tove'


Bomb = Class{}


function Bomb:init(pos, power,chords)
  self.position = pos
  self.power = power
  self.time = 3
  self.hitbox = HC.circle(self.position.x,self.position.y,17.5)
  self.toDelete = false
  self.cords=chords
  
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
end

return Bomb