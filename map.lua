HC = require 'lib.HC'
Class = require 'lib.hump.class'
Player = require 'player'
Field = require 'field'
vector = require 'lib.hump.vector'
Bomb = require 'bomb'
tove = require 'lib.tove'

Map = Class{}

function Map:init(x,y)
  if x == nil or y == nil then
    self.x=10
    self.y=10
  else
    self.x=x
    self.y=y
  end
  self.width = self.x * 40
  self.height = self.y * 40
  self.position = vector.new((love.graphics:getWidth() / 2) - (self.width / 2), (love.graphics:getHeight() / 2) - (self.height / 2))
  self.playerCount = 0
  self.players = {}
  self.fields = {}
  self.bombs = {}
  self.spawns = {}

  --if self.type == 'arena_greenwall' then
    for i = 1, self.x, 1 do
      self.fields[i] = {}
      for j = 1, self.y, 1 do

        local field = Field(self.position + vector.new(i * (self.width / self.x), j * (self.height / self.y)), 40, 'arena_greenwall')

        self.fields[i][j] = field
      end
    end
  self.fields[3][5]:setType('air')
  
  -- Hintergrund anzeigen lassen:
  background = love.filesystem.read("resources/SVG/background.svg")
  background = tove.newGraphics(background)
  background:rescale(2500)
  

end

function Map:spawn(player)
  self.players[self.playerCount] = player
  self.players[self.playerCount]:setPosition(self.fields[1][1].position.x, self.fields[1][1].position.y)
  self.players[self.playerCount]:setId(self.playerCount)
  self.playerCount = self.playerCount + 1
end

function Map:update(dt)
  -- local player move events
--  if love.keyboard.isDown('w') and (not dir_lock or direction == 'w') then
--    self.players[0]:move(0, -1)
--    direction = 'w'
--    self.players[0].direction = "up"
--    dir_lock = true
--  elseif love.keyboard.isDown('a') and (not dir_lock or direction == 'a') then
--    self.players[0]:move(-1, 0)
--    direction = 'a'
--    self.players[0].direction = "left"
--    dir_lock = true  elseif love.keyboard.isDown('s') and (not dir_lock or direction == 's') then
--    self.players[0]:move(0, 1)
--    direction = 's'
--    self.players[0].direction = "down"
--    dir_lock = true
--  elseif love.keyboard.isDown('d') and (not dir_lock or direction == 'd') then
--    self.players[0]:move(1, 0)
--    direction = 'd'
--    self.players[0].direction = "right"
--    dir_lock = true
    
--  else
--    direction = ''
--    dir_lock = false
--  end
 
--  if love.keyboard.isDown('e') then
--    self:setBomb()
--  endif love.keyboard.isDown('w') and (not dir_lock or direction == 'w') then
--    self.players[0]:move(0, -1)
--    direction = 'w'
--    self.players[0].direction = "up"
--    dir_lock = true
--  elseif love.keyboard.isDown('a') and (not dir_lock or direction == 'a') then
--    self.players[0]:move(-1, 0)
--    direction = 'a'
--    self.players[0].direction = "left"
--    dir_lock = true  elseif love.keyboard.isDown('s') and (not dir_lock or direction == 's') then
--    self.players[0]:move(0, 1)
--    direction = 's'
--    self.players[0].direction = "down"
--    dir_lock = true
--  elseif love.keyboard.isDown('d') and (not dir_lock or direction == 'd') then
--    self.players[0]:move(1, 0)
--    direction = 'd'
--    self.players[0].direction = "right"
--    dir_lock = true
    
--  else
--    direction = ''
--    dir_lock = false
--  end
 
--  if love.keyboard.isDown('e') then
--    self:setBomb()
--  end

  -- send player[0] (own player) position to server
  -- get position of other players from server

  -- update players
  for key, value in pairs(self.players) do
    self.players[key]:update(dt)
  end
  
  for key, value in pairs(self.bombs) do
    self.bombs[key]:update(dt)
    if self.bombs[key].toDelete then
      table.remove(self.bombs,key)
    end
  end
  
end

function Map:draw()
  
  background:draw() -- Hintergrund zeichnen lassen

  for i = 1, self.x, 1 do
    for j = 1, self.y, 1 do
      self.fields[i][j]:draw() 
    end
  end
  
  for key, value in pairs(self.players) do
    self.players[key]:draw()
  end
  
  for key, value in pairs(self.bombs) do
    self.bombs[key]:draw()
  end
end

function Map:setBomb()
    table.insert(self.bombs, Bomb(self.players[0].position, self.players[0].stats.power))
end

function Map:changeType(x,y,typ)
  self.fields[x][y]:setType(typ)
end

function Map:addSpawn(x,y)
  table.insert(self.spawns,Vector(x,y))
end

return Map
