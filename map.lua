--Loads the rewuired Modules
HC = require "lib.HC"
Class = require "lib.hump.class"
Player = require "player"
Field = require "field"
Vector = require "lib.hump.vector"
Bomb = require "bomb"
--Tove = require "lib.tove"
StatusBar = require "statusBar"
Bitser = require "lib.bitser.bitser"

Map = Class {}

function Map:init(x, y)
    if x == nil or y == nil then
        self.x = 10
        self.y = 10
    else
        self.x = tonumber(x)
        self.y = tonumber(y)
    end
    self.fieldSize = 40
    self.width = self.x * self.fieldSize
    self.height = self.y * self.fieldSize
    self.position =
        Vector.new(
        (love.graphics:getWidth() / 2) - (self.width / 2),
        (love.graphics:getHeight() / 2) - (self.height / 2)
    )
    self.playerCount = 0
    self.players = {}
    self.fields = {}
    self.bombs = {}
    self.spawns = {}
    self.death = true

    --if self.type == 'arena_greenwall' then
    for i = 1, self.x, 1 do
        self.fields[i] = {}
        for j = 1, self.y, 1 do
            local field =
                Field(
                self.position + Vector.new(i * (self.width / self.x), j * (self.height / self.y)),
                40,
                "arena_wall",
                Vector.new(i, j),
                self.position
            )

            self.fields[i][j] = field
        end
    end

    -- Show the background
    self.background = Tove.newGraphics(Textures["background"], 1200)
    self.statusBar = StatusBar()
    --self.statusBar:createTextBox(self.playerCount)
end

--Bitser.register('Map:init', Map.init)
--Spawns the Player
function Map:spawn()
    local rnd = love.math.random(1, table.getn(self.spawns))
    local relX = self.spawns[rnd].x
    local relY = self.spawns[rnd].y
    table.remove(self.spawns, rnd)
    self.players[self.playerCount] =
        Player(
        self.fields[relX][relY].position.x,
        self.fields[relX][relY].position.y,
        self.playerCount,
        self.position,
        self.fieldSize
    )
    self.playerCount = self.playerCount + 1
    return self.players[self.playerCount - 1]
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
            table.remove(self.bombs, key)
        end
    end

    for key, value in pairs(self.fields) do
        for k, v in pairs(value) do
            v:update(dt)
        end
    end
    self.statusBar:update()
end

--shows the map
function Map:draw()
    love.graphics.reset()
    self.background:draw(600, 337.5) -- Hintergrund zeichnen lassen

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
    self.statusBar:draw()
end

--Method to set bombs and set bombs to a whole field
function Map:setBomb(id)
    --TODO use getRelPos()-------------------------------------------------------
    if id == nil then
        id = 0
    end
    local col = {}
    local cords = {}
    if self.players[id].stats.restrain == false and self.players[id].dead == false and self.players[id].fallen == false then
        for shape, delta in pairs(HC.collisions(self.players[id].hitbox)) do
            if shape.cords ~= nil then
                col[#col + 1] = Vector.new(delta.x, delta.y):len()
                cords[#cords + 1] = shape.cords
            end
        end
        col[0] = 0
        local index = 0
        for k, v in pairs(col) do
            if v ~= 0 then
                if col[index] < v then
                    index = k
                end
            end
        end
        if index ~= 0 and map.fields[cords[index].x][cords[index].y].bombs == 0 then
            if self.players[id].stats.bombs > 0 then
                table.insert(
                    self.bombs,
                    Bomb(
                        map.fields[cords[index].x][cords[index].y].position,
                        self.players[id].stats.power,
                        cords[index],
                        self.position,
                        id
                    )
                )
                map.fields[cords[index].x][cords[index].y].bombs = 1
                self.players[id].stats.bombs = self.players[id].stats.bombs - 1
                love.audio.play(love.audio.newSource("resources/sounds/putbomb.wav", "static"))
            end
        elseif map.fields[cords[index].x][cords[index].y].bombs > 0 then
            local bomb
            for k, v in pairs(map.bombs) do
                if v.cords == cords[index] then
                    bomb = v
                end
            end
            local vect
            if self.players[id].direction == "right" then
                vect = Vector.new(cords[index].x + 2, cords[index].y)
            elseif self.players[id].direction == "left" then
                vect = Vector.new(cords[index].x - 2, cords[index].y)
            elseif self.players[id].direction == "up" then
                vect = Vector.new(cords[index].x, cords[index].y - 2)
            elseif self.players[id].direction == "down" then
                vect = Vector.new(cords[index].x, cords[index].y + 2)
            end
            bomb:throwBomb(vect)
        end
    end
end

--Set the types for Fields
function Map:changeType(x, y, typ)
    self.fields[x][y]:setType(typ)
end

--adds spawnpoints to the map
function Map:addSpawn(x, y)
    table.insert(self.spawns, Vector(x, y))
end

function Map:resize(w, h)
end

function Map:getData()
    local data = {
        playerCount = self.playerCount,
        players = {},
        fields = {},
        bombs = {},
        x = self.x,
        y = self.y
    }
    for k, player in pairs(self.players) do
        table.insert(data.players, player:getData())
    end
    for i, fields in pairs(self.fields) do
        data.fields[i] = {}
        for j, field in pairs(fields) do
            data.fields[i][j] = field:getData()
        end
    end
    for k, bomb in pairs(self.bombs) do
        table.insert(data.bombs, bomb:getData())
    end

    return data
end

function Map:setData(data)
  self.x = data.x
  self.y = data.y
    if data.playerCount ~= self.playerCount then
        for i = 0, data.playerCount - self.playerCount - 1, 1 do
            self.players[i] = Player(0, 0, i, self.position, self.fieldSize)
        end
    end
    for k, player in pairs(self.players) do
        player:setData(data.players[k+1])
    end
    self.playerCount = data.playerCount
    if #self.fields == 0 then
      self.width = self.x * self.fieldSize
    self.height = self.y * self.fieldSize
    self.position =
        Vector.new(
        (love.graphics:getWidth() / 2) - (self.width / 2),
        (love.graphics:getHeight() / 2) - (self.height / 2)
    )
        for i = 1, table.getn(data.fields), 1 do
          self.fields[i] = {}
          for j = 1, table.getn(data.fields[i]), 1 do
                self.fields[i][j] =
                    Field(Vector.new(data.fields[i][j].position.x, data.fields[i][j].position.y), map.fieldSize,data.fields[i][j].type, Vector.new(i, j), self.position)
          end
        end
    else
        for i, fields in pairs(self.fields) do
            for j, field in pairs(fields) do
                field:setData(data.fields[i][j])
            end
        end
    end

    if table.getn(data.bombs) ~= table.getn(self.bombs) then
        for i = 1, table.getn(data.bombs) - table.getn(self.bombs), 1 do
            table.insert(self.bombs, Bomb(Vector.new(0, 0), 0, Vector.new(0, 0), self.position))
        end
    end
    for k, bomb in pairs(self.bombs) do
        if data.bombs[k] ~= nil then
            bomb:setData(data.bombs[k])
        end
    end
end

return Map
