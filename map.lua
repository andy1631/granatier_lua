--Loads the rewuired Modules
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
    self.x=tonumber(x)
    self.y=tonumber(y)
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

        local field = Field(self.position + vector.new(i * (self.width / self.x), j * (self.height / self.y)),40, 'arena_wall', vector.new(i,j))

        self.fields[i][j] = field
      end
    end
  
  -- Show the background
  background = love.filesystem.read("resources/SVG/background.svg")
  background = tove.newGraphics(background)
  background:rescale(1200)
end

--Spawns the Player
function Map:spawn(player)
  self.players[self.playerCount] = player
  local num=love.math.random(1,table.getn(self.spawns))
  local posx=self.spawns[num].x
  local posy=self.spawns[num].y
  table.remove(self.spawns,num)
  self.players[self.playerCount]:setPosition(self.fields[posx][posy].position.x, self.fields[posx][posy].position.y)
  self.players[self.playerCount]:setId(self.playerCount)
  self.playerCount = self.playerCount + 1
end

function Map:update(dt)
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
  
  for key, value in pairs(self.fields) do
    for k, v in pairs (value) do
      v:update(dt)
    end
  end
  
end

--shows the map
function Map:draw()
  love.graphics.reset()
  love.graphics.translate(600, 337.5)
  background:draw() -- Hintergrund zeichnen lassen
  love.graphics.translate(-(600), -(337.5))

  for i = 1, self.x, 1 do
    for j = 1, self.y, 1 do
      self.fields[i][j]:draw() 
    end
  end
  for key, value in pairs(self.bombs) do
    self.bombs[key]:draw()
  end
  for key, value in pairs(self.players) do
    self.players[key]:draw()
  end
end

--Method to set bombs and set bombs to a whole field
function Map:setBomb()
  local col={}
  local cords={}
  if self.players[0].stats.bombs>0 then
    for shape, delta in pairs(HC.collisions(self.players[0].hitbox)) do
      if shape.cords ~= nil then
        col[#col+1] = vector.new(delta.x,delta.y):len()
        cords[#cords+1] = shape.cords
        end
    end
    col[0]=0
    local index=0
    for k,v in pairs(col) do
      if v~=0 then
        if col[index]<v then
        index=k
        end
      end
    end
    if index~=0 and map.fields[cords[index].x][cords[index].y].bombs==0 then
      table.insert(self.bombs, Bomb(map.fields[cords[index].x][cords[index].y].position, self.players[0].stats.power, cords[index]))
      map.fields[cords[index].x][cords[index].y].bombs=1
      self.players[0].stats.bombs=self.players[0].stats.bombs-1
      source = love.audio.newSource( 'resources/sounds/putbomb.wav' , 'static' )
      love.audio.play(source)
    end
  end
end

--Set the types for Fields
function Map:changeType(x,y,typ)
  self.fields[x][y]:setType(typ)
end

--adds spawnpoints to the map
function Map:addSpawn(x,y)
  table.insert(self.spawns,Vector(x,y))
end

return Map
