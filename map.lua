HC = require 'lib.HC'
Class = require 'lib.hump.class'
Player = require 'player'
Field = require 'field'
vector = require 'lib.hump.vector'
<<<<<<< HEAD
Bomb = require 'bomb'
=======
tove = require 'lib.tove'
>>>>>>> 030ea88e9903f970c1c023d1ba9d3df39d481f2e

Map = Class{}

function Map:init(x,y)
  if x == nil or y == nil then
    self.x=10
    self.y=10
  else
    self.x=x
    self.y=y
  end
  self.width = 400
  self.height = 400
  self.position = vector.new((love.graphics:getWidth() / 2) - (self.width / 2), (love.graphics:getHeight() / 2) - (self.height / 2))
  self.playerCount = 0
  self.players = {}
  self.fields = {}
  self.bombs = {}

  for i = 0, self.x, 1 do
    self.fields[i] = {}
    for j = 0, self.y, 1 do

      local field = Field(self.position + vector.new(i * (self.width / self.x), j * (self.height / self.y)), 40)

      self.fields[i][j] = field
    end
  end

  self.fields[3][5]:setType('wall')

end

function Map:spawn(player)
  self.players[self.playerCount] = player
  self.players[self.playerCount]:setPosition(self.fields[0][0].position.x, self.fields[0][0].position.y)
  self.players[self.playerCount]:setId(self.playerCount)
  self.playerCount = self.playerCount + 1
end

function Map:update(dt)
  -- local player move events
  if love.keyboard.isDown('w') and (not dir_lock or direction == 'w') then
    self.players[0]:move(0, -1)
    direction = 'w'
    dir_lock = true
  elseif love.keyboard.isDown('a') and (not dir_lock or direction == 'a') then
    self.players[0]:move(-1, 0)
    direction = 'a'
    dir_lock = true
  elseif love.keyboard.isDown('s') and (not dir_lock or direction == 's') then
    self.players[0]:move(0, 1)
    direction = 's'
    dir_lock = true
  elseif love.keyboard.isDown('d') and (not dir_lock or direction == 'd') then
    self.players[0]:move(1, 0)
    direction = 'd'
    dir_lock = true
  else
    dir_lock = false
    direction = ''
  end

  -- send player[0] (own player) position to server
  -- get position of other players from server

  -- update players
  for key, value in pairs(self.players) do
    self.players[key]:update(dt)
  end
  
end

function Map:draw()
  for key, value in pairs(self.players) do
    self.players[key]:draw()
  end

  for i = 0, self.x, 1 do
    for j = 0, self.y, 1 do
      self.fields[i][j]:draw()
    end
  end
end

function Map:setBomb(x, y)
    
end

return Map
