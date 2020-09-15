HC = require 'lib.HC'
Class = require 'lib.hump.class'
tove = require 'lib.tove'
--Laden den oben gennanten Module

Field = Class{}
--Field als Objekt festlegen

function Field:init(pos, size, t)
  self.type = t
  self.hitbox = HC.rectangle(pos.x , pos.y, size, size)
  local x,y = self.hitbox:center()
  self.position = vector.new(x, y)

  self.hitbox.solid = (self.type == 'arena_greenwall' or self.type == 'arena_wall')
  self.Texture = love.filesystem.read("resources/SVG/" .. self.type .. '.svg')
  
  self.Texture = tove.newGraphics(self.Texture)
  self.Texture:rescale(40)
end
--Festlegen der Position der Mauer

function Field:__tostring()
  return string.format('type: %s', self.type)
end
--Konvertierung des Objekts Field zu String

function Field:draw()
  if self.type ~= 'air' then
    --self.hitbox:draw((self.type == 'wall') and 'fill' or 'line')
    love.graphics.translate(self.position.x, self.position.y)
    self.Texture:draw()
    love.graphics.translate(-self.position.x, -self.position.y)
  end
end
--Zeichnen der Linie der Hitbox

function Field:setType(t)
  self.type = t
  self.hitbox.solid = (self.type == 'arena_greenwall' or self.type == 'arena_wall')
  self.Texture = love.filesystem.read("resources/SVG/" .. self.type .. '.svg')
  self.Texture = tove.newGraphics(self.Texture)
  self.Texture:rescale(40)
end
--Festlegen des Types als HitBox

return Field
--Rückgabe des Objekts Field
