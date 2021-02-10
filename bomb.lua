HC = require "lib.HC"
Timer = require "lib.hump.timer"
Class = require "lib.hump.class"
Tove = require "lib.tove"
Vector = require "lib.hump.vector"

Bomb = Class {}

function Bomb:init(pos, power, cords)
    self.position = pos
    self.power = power
    self.time = 3
    --self.hitbox = HC.circle(self.position.x,self.position.y, 17.5)
    self.hitbox = HC.rectangle(self.position.x - 20, self.position.y - 20, 40, 40)
    self.toDelete = false
    self.cords = cords
    self.bomb = love.filesystem.read("resources/SVG/bomb.svg")
    self.bomb = Tove.newGraphics(self.bomb)
    self.bomb:rescale(35)
    self.scale = 35
    self.scaleFactor = -0.25
end

function Bomb:draw()
    --self.hitbox:draw()
    self.bomb:draw(self.position.x, self.position.y)
end

function Bomb:update(dt)
    self.time = self.time - dt
    if self.scale <= 32 then
        self.scaleFactor = 12 * dt
    elseif self.scale >= 35 then
        self.scaleFactor = -12 * dt
    end
    self.scale = self.scale + self.scaleFactor
    self.bomb:rescale(self.scale)
    if self.time <= 0 then
        self:explode()
    end

    local solid = true

    if not self.hitbox.solid and HC.collisions(self.hitbox) ~= {} then
        for shape, delta in pairs(HC.collisions(self.hitbox)) do
            if Vector.new(delta.x, delta.y):len() ~= 0 then
                solid = false
            end
        end
    end
    self.hitbox.solid = solid
end

function Bomb:explode()
    source = love.audio.newSource("resources/sounds/explode.wav", "static")
    love.audio.play(source)
    self.toDelete = true
    local fieldsCords = {}
    map.fields[self.cords.x][self.cords.y].bombs = 0
    map.players[0].stats.bombs = map.players[0].stats.bombs + 1
    if map.fields[self.cords.x][self.cords.y]:getType() == "arena_ground" then
        map.fields[self.cords.x][self.cords.y].PowerUp = nil
        table.insert(fieldsCords, Vector.new(self.cords.x, self.cords.y))
    end
    for i = 1, self.power, 1 do
        if self.cords.x + i > map.x then
            break
        end
        if map.fields[self.cords.x + i][self.cords.y]:getType() == "arena_wall" then
            map.fields[self.cords.x + i][self.cords.y]:setType("arena_ground")
            map.fields[self.cords.x + i][self.cords.y]:spawnPowerUp()
            break
        end
        if map.fields[self.cords.x + i][self.cords.y]:getType() == "arena_greenwall" then
            break
        end
        if map.fields[self.cords.x + i][self.cords.y]:getType() == "arena_ground" then
            if map.fields[self.cords.x + i][self.cords.y].PowerUp ~= nil then
                map.fields[self.cords.x + i][self.cords.y].PowerUp = nil
                break
            end
            table.insert(fieldsCords, Vector.new(self.cords.x + i, self.cords.y))
            break
        end
    end
    for i = 1, self.power, 1 do
        if self.cords.x - i < 1 then
            break
        end
        if map.fields[self.cords.x - i][self.cords.y]:getType() == "arena_wall" then
            map.fields[self.cords.x - i][self.cords.y]:setType("arena_ground")
            map.fields[self.cords.x - i][self.cords.y]:spawnPowerUp()
            break
        end
        if map.fields[self.cords.x - i][self.cords.y]:getType() == "arena_greenwall" then
            break
        end
        if map.fields[self.cords.x - i][self.cords.y]:getType() == "arena_ground" then
            if map.fields[self.cords.x - i][self.cords.y].PowerUp ~= nil then
                map.fields[self.cords.x - i][self.cords.y].PowerUp = nil
                break
            end
            table.insert(fieldsCords, Vector.new(self.cords.x - i, self.cords.y))
        end
    end
    for i = 1, self.power, 1 do
        if self.cords.y + i > map.y then
            break
        end
        if map.fields[self.cords.x][self.cords.y + i]:getType() == "arena_wall" then
            map.fields[self.cords.x][self.cords.y + i]:setType("arena_ground")
            map.fields[self.cords.x][self.cords.y + i]:spawnPowerUp()
            break
        end
        if map.fields[self.cords.x][self.cords.y + i]:getType() == "arena_greenwall" then
            break
        end
        if map.fields[self.cords.x][self.cords.y + i]:getType() == "arena_ground" then
            if map.fields[self.cords.x][self.cords.y + i].PowerUp ~= nil then
                map.fields[self.cords.x][self.cords.y + i].PowerUp = nil
                break
            end
            table.insert(fieldsCords, Vector.new(self.cords.x, self.cords.y + i))
        end
    end
    for i = 1, self.power, 1 do
        if self.cords.y - i < 1 then
            break
        end
        if map.fields[self.cords.x][self.cords.y - i]:getType() == "arena_wall" then
            map.fields[self.cords.x][self.cords.y - i]:setType("arena_ground")
            map.fields[self.cords.x][self.cords.y - i]:spawnPowerUp()
            break
        end
        if map.fields[self.cords.x][self.cords.y - i]:getType() == "arena_greenwall" then
            break
        end
        if map.fields[self.cords.x][self.cords.y - i]:getType() == "arena_ground" then
            if map.fields[self.cords.x][self.cords.y - i].PowerUp ~= nil then
                map.fields[self.cords.x][self.cords.y - i].PowerUp = nil
                break
            end
            table.insert(fieldsCords, Vector.new(self.cords.x, self.cords.y - i))
        end
    end
    --[[for k, v in pairs(fieldsCords) do -- TODO What is this?
        for j, l in pairs(fieldsCords) do
        end
      end]]
    HC.remove(self.hitbox)
end
return Bomb
