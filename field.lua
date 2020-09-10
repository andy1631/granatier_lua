HC = require 'lib.HC'
Class = require 'lib.hump.class'

Field = Class{}

function Field:init(pos, size, t)
  self.type = t
  self.hitbox = HC.rectangle(pos.x , pos.y, size, size)
  local x,y = self.hitbox:center()
  self.position = vector.new(x, y)
  self.hitbox.solid = self.type == 'wall'
end

function Field:__tostring()
  return string.format('type: %s', self.type)
end

function Field:draw()
  self.hitbox:draw((self.type == 'wall') and 'fill' or 'line')
end

function Field:setType(t)
  self.type = t
  self.hitbox.solid = self.type == 'wall'
  
end

return Field
