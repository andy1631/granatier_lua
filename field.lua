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
  -- self.hitbox.solid = self.type == 'wall'
  self.Texture = love.filesystem.read("resources/SVG/" .. self.type .. '.svg')
  self.Texture = tove.newGraphics(self.Texture)
  self.Texture:rescale(40)
  -- self:loadTextures()
end
--Festlegen der Position der Mauer

function Field:__tostring()
  return string.format('type: %s', self.type)
end
--Konvertierung des Objekts Field zu String

function Field:draw()
  self.hitbox:draw((self.type == 'wall') and 'fill' or 'line')
  love.graphics.translate(self.position.x, self.position.y)
  self.Texture:draw()
  love.graphics.translate(-self.position.x, -self.position.y)
  
end
--Zeichnen der Linie der Hitbox

function Field:setType(t)
  self.type = t
  self.hitbox.solid = self.type == 'wall'
end
--Festlegen des Types als HitBox
function Field:loadTextures()
  arenaArrowDown = love.filesystem.read("resources/SVG/arena_arrow_down.svg")
  arenaArrowDown = tove.newGraphics(arenaArrowDown)
  arenaArrowLeft = love.filesystem.read("resources/SVG/arena_arrow_left.svg")
  arenaArrowLeft = tove.newGraphics(arenaArrowLeft)
  arenaArrowRight = love.filesystem.read("resources/SVG/arena_arrow_right.svg")
  arenaArrowRight = tove.newGraphics(arenaArrowRight)
  arenaArrowUp = love.filesystem.read("resources/SVG/arena_arrow_up.svg")
  arenaArrowUp = tove.newGraphics(arenaArrowUp)
  arenaBombMortar = love.filesystem.read("resources/SVG/arena_bomb_mortar.svg")
  arenaBombMortar = tove.newGraphics(arenaBombMortar)
  arenaGreenwall = love.filesystem.read("resources/SVG/arena_greenwall.svg")
  arenaGreenwall = tove.newGraphics(arenaGreenwall)
  arenaIce = love.filesystem.read("resources/SVG/arena_ice.svg")
  arenaIce = tove.newGraphics(arenaIce)
  arenaMine = love.filesystem.read("resources/SVG/arena_mine.svg")
  arenaMine = tove.newGraphics(arenaMine)
  arenaWall = love.filesystem.read("resources/SVG/arena_wall.svg")
  arenaWall = tove.newGraphics(arenaWall)
  end
return Field
--Rückgabe des Objekts Field
