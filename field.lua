HC = require 'lib.HC'
Class = require 'lib.hump.class'

Field = Class{}

function Field:init(pos, size, content)
  self.content = content
  self.hitbox = HC.rectangle(pos.x , pos.y, size, size)
  local x,y = self.hitbox:center()
  self.position = vector.new(x, y)
  self.hitbox.solid = self.content == 'wall'
end

function Field:__tostring()
  return string.format('content: %s', self.content)
end

function Field:draw()
  self.hitbox:draw((self.content == 'wall') and 'fill' or 'line')
end

function Field:addContent(c)
  self.content = c
  self.hitbox.solid = self.content == 'wall'
  
end

return Field
