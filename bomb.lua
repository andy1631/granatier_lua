HC = require 'lib.HC'
Timer = require 'lib.hump.timer'
Class = require 'lib.hump.class'
Bomb = Class{}

function Bomb:init(pos, power)
  self.position = pos
  self.power = power
  self.time = 3
  self.hitbox = HC.circle(self.position.x,self.poistion.y,20)
  Timer.after(3,Bomb:explode())
end

function Bomb:draw()
  love.graphics.setColor(255,255,255)
  self.hitbox:draw()  
end

function Bomb:update()
  
end

function Bomb:explode()
  
  end