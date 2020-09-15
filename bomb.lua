HC = require 'lib.HC'
Timer = require 'lib.hump.timer'
Class = require 'lib.hump.class'
tove = require 'lib.tove'


Bomb = Class{}


function Bomb:init(pos, power)
  self.position = pos
  self.power = power
  self.time = 3
  self.hitbox = HC.circle(self.position.x,self.position.y,20)
  self.toDelete = false
  
  bomb = love.filesystem.read("resources/SVG/bomb.svg")
  mybomb = tove.newGraphics(bomb)
  
end

function Bomb:draw()
  love.graphics.setColor(255,255,255)
  self.hitbox:draw()  
  love.graphics.translate(self.position.x, self.position.y)
  mybomb:draw()
  love.graphics.translate(-self.position.x, -self.position.y)
end

function Bomb:update(dt)
  self.time = self.time - dt
  if self.time <= 0 then
    self:explode()
    end
end

function Bomb:explode()
  source = love.audio.newSource( 'resources/sounds/explode.wav' , 'stream' )
  love.audio.play(source)
  self.toDelete = true
end

return Bomb