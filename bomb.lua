HC = require 'lib.HC'
class = "lib.hump.class"
Bomb = class{}

function Bomb:init(pos, power)
  self.position = pos
  self.power = power
  self.time = 3
  self.hitbox = HC.circle(self.position.x,self.poistion.y,20)
end

function Bomb:draw()
  
  love.graphics.setColor(255,255,255)
  self.hitbox:draw()
  
end

function Bomb:update()
  
end

function Bomb:explode()
  
  end