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
    self.hitbox = HC.rectangle(self.position.x - 20, self.position.y - 20, 40, 40)
    self.toDelete = false
    self.cords = cords
    self.bomb = love.filesystem.read("resources/SVG/bomb.svg")
    self.bomb = Tove.newGraphics(self.bomb)
    self.bomb:rescale(35)
    self.scale = 35
    self.scaleFactor = -0.25
    self.north = 0
    self.south = 0
    self.west = 0
    self.east = 0
    self.isExploding = false
    self.explodeState = 0
    self.explodeTime = 0
    self.size = 35
    self.northCords = {}
    self.southCords = {}
    self.eastCords = {}
    self.westCords = {}
end

function Bomb:draw()
    --self.hitbox:draw()
    if not self.isExploding then
        self.bomb:draw(self.position.x, self.position.y)
    end

    --love.graphics.print(tostring(self.isExploding),0,0)
    self:explodeAnimation()
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
    if self.time <= 0 and not self.isExploding then
        self:explode()
    end

    if not self.hitbox:collidesWith(map.players[0].hitbox) and not self.isExploding then
        self.hitbox.solid = true
    end

    if self.isExploding then
        self.explodeTime = self.explodeTime + dt
        if self.explodeTime >= 1.0 then
            self.toDelete = true
        elseif self.explodeTime >= 0.8 then
            self.explodeState = 4
        elseif self.explodeTime >= 0.6 then
            self.explodeState = 3
        elseif self.explodeTime >= 0.4 then
            self.explodeState = 2
        elseif self.explodeTime >= 0.2 then
            self.explodeState = 1
        end
    end
end

function Bomb:explodeAnimation()
    if self.isExploding == true then
        if self.explodeState == 0 then
            self.texture = love.filesystem.read("resources/SVG/bomb_blast_core_0.svg")
            self.texture = Tove.newGraphics(self.texture, self.size)
            self.texture:draw(self.position.x, self.position.y)
            if self.north > 0 then
                for k, v in pairs(self.northCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_north_0.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x, self.position.y - (v))
                end
            end
            if self.south > 0 then
                for k, v in pairs(self.southCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_south_0.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x, self.position.y + (v))
                end
            end
            if self.east > 0 then
                for k, v in pairs(self.eastCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_east_0.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x + (v), self.position.y)
                end
            end
            if self.west > 0 then
                for k, v in pairs(self.westCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_west_0.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x - (v), self.position.y)
                end
            end
        end
        if self.explodeState == 1 then
            self.texture = love.filesystem.read("resources/SVG/bomb_blast_core_1.svg")
            self.texture = Tove.newGraphics(self.texture, self.size)
            self.texture:draw(self.position.x, self.position.y)
            if self.north > 0 then
                for k, v in pairs(self.northCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_north_1.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x, self.position.y - (v))
                end
            end
            if self.south > 0 then
                for k, v in pairs(self.southCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_south_1.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x, self.position.y + (v))
                end
            end
            if self.east > 0 then
                for k, v in pairs(self.eastCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_east_1.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x + (v), self.position.y)
                end
            end
            if self.west > 0 then
                for k, v in pairs(self.westCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_west_1.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x - (v), self.position.y)
                end
            end
        end
        if self.explodeState == 2 then
            self.texture = love.filesystem.read("resources/SVG/bomb_blast_core_2.svg")
            self.texture = Tove.newGraphics(self.texture, self.size)
            self.texture:draw(self.position.x, self.position.y)
            if self.north > 0 then
                for k, v in pairs(self.northCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_north_2.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x, self.position.y - (v))
                end
            end
            if self.south > 0 then
                for k, v in pairs(self.southCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_south_2.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x, self.position.y + (v))
                end
            end
            if self.east > 0 then
                for k, v in pairs(self.eastCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_east_2.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x + (v), self.position.y)
                end
            end
            if self.west > 0 then
                for k, v in pairs(self.westCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_west_2.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x - (v), self.position.y)
                end
            end
        end
        if self.explodeState == 3 then
            self.texture = love.filesystem.read("resources/SVG/bomb_blast_core_3.svg")
            self.texture = Tove.newGraphics(self.texture, self.size)
            self.texture:draw(self.position.x, self.position.y)
            if self.north > 0 then
                for k, v in pairs(self.northCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_north_3.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x, self.position.y - (v))
                end
            end
            if self.south > 0 then
                for k, v in pairs(self.southCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_south_3.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x, self.position.y + (v))
                end
            end
            if self.east > 0 then
                for k, v in pairs(self.eastCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_east_3.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x + (v), self.position.y)
                end
            end
            if self.west > 0 then
                for k, v in pairs(self.westCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_west_3.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x - (v), self.position.y)
                end
            end
        end
        if self.explodeState == 4 then
            self.texture = love.filesystem.read("resources/SVG/bomb_blast_core_4.svg")
            self.texture = Tove.newGraphics(self.texture, self.size)
            self.texture:draw(self.position.x, self.position.y)
            if self.north > 0 then
                for k, v in pairs(self.northCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_north_4.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x, self.position.y - (v))
                end
            end
            if self.south > 0 then
                for k, v in pairs(self.southCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_south_4.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x, self.position.y + (v))
                end
            end
            if self.east > 0 then
                for k, v in pairs(self.eastCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_east_4.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x + (v), self.position.y)
                end
            end
            if self.west > 0 then
                for k, v in pairs(self.westCords) do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_west_4.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(self.position.x - (v), self.position.y)
                end
            end
        end
    end
end

function Bomb:explode()
    source = love.audio.newSource("resources/sounds/explode.wav", "static")
    love.audio.play(source)
    --self.toDelete = true
    self.isExploding = true
    local fieldsCords = {}
    map.fields[self.cords.x][self.cords.y].bombs = 0
    map.players[0].stats.bombs = map.players[0].stats.bombs + 1
    if map.fields[self.cords.x][self.cords.y]:getType() == "arena_ground" then
        map.fields[self.cords.x][self.cords.y].PowerUp = nil
        map.fields[self.cords.x][self.cords.y].powerupNo = nil
        table.insert(fieldsCords, Vector.new(self.cords.x, self.cords.y))
    end
    for i = 1, self.power, 1 do
        if self.cords.x + i > map.x then
            break
        end
        if map.fields[self.cords.x + i][self.cords.y]:getType() == "arena_wall" then
            map.fields[self.cords.x + i][self.cords.y]:setType("arena_ground")
            map.fields[self.cords.x + i][self.cords.y]:spawnPowerUp()
            self.east = self.east + map.fieldSize
            table.insert(self.eastCords, self.east)
            break
        end
        if map.fields[self.cords.x + i][self.cords.y]:getType() == "arena_greenwall" then
            break
        end
        if map.fields[self.cords.x + i][self.cords.y]:getType() == "arena_ground" then
            if map.fields[self.cords.x + i][self.cords.y].PowerUp ~= nil then
                map.fields[self.cords.x + i][self.cords.y].PowerUp = nil
                map.fields[self.cords.x + i][self.cords.y].powerupNo = nil
                break
            end
            table.insert(fieldsCords, Vector.new(self.cords.x + i, self.cords.y))
        end
        if map.fields[self.cords.x + i][self.cords.y]:getType() ~= "arena_greenwall" then
            self.east = self.east + map.fieldSize
            table.insert(self.eastCords, self.east)
            table.insert(fieldsCords, Vector.new(self.cords.x + i, self.cords.y))
        end
    end
    for i = 1, self.power, 1 do
        if self.cords.x - i < 1 then
            break
        end
        if map.fields[self.cords.x - i][self.cords.y]:getType() == "arena_wall" then
            map.fields[self.cords.x - i][self.cords.y]:setType("arena_ground")
            map.fields[self.cords.x - i][self.cords.y]:spawnPowerUp()
            self.west = self.west + map.fieldSize
            table.insert(self.westCords, self.west)
            break
        end
        if map.fields[self.cords.x - i][self.cords.y]:getType() == "arena_greenwall" then
            break
        end
        if map.fields[self.cords.x - i][self.cords.y]:getType() == "arena_ground" then
            if map.fields[self.cords.x - i][self.cords.y].PowerUp ~= nil then
                map.fields[self.cords.x - i][self.cords.y].PowerUp = nil
                map.fields[self.cords.x - i][self.cords.y].powerupNo = nil
                break
            end
            table.insert(fieldsCords, Vector.new(self.cords.x - i, self.cords.y))
        end
        if map.fields[self.cords.x - i][self.cords.y]:getType() ~= "arena_greenwall" then
            self.west = self.west + map.fieldSize
            table.insert(self.westCords, self.west)
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
            self.south = self.south + map.fieldSize
            table.insert(self.southCords, self.south)
            break
        end
        if map.fields[self.cords.x][self.cords.y + i]:getType() == "arena_greenwall" then
            break
        end
        if map.fields[self.cords.x][self.cords.y + i]:getType() == "arena_ground" then
            if map.fields[self.cords.x][self.cords.y + i].PowerUp ~= nil then
                map.fields[self.cords.x][self.cords.y + i].PowerUp = nil
                map.fields[self.cords.x][self.cords.y + i].powerupNo = nil
                break
            end
            table.insert(fieldsCords, Vector.new(self.cords.x, self.cords.y + i))
        end
        if map.fields[self.cords.x][self.cords.y + i]:getType() ~= "arena_greenwall" then
            self.south = self.south + map.fieldSize
            table.insert(self.southCords, self.south)
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
            self.north = self.north + map.fieldSize
            table.insert(self.northCords, self.north)
            break
        end
        if map.fields[self.cords.x][self.cords.y - i]:getType() == "arena_greenwall" then
            break
        end
        if map.fields[self.cords.x][self.cords.y - i]:getType() == "arena_ground" then
            if map.fields[self.cords.x][self.cords.y - i].PowerUp ~= nil then
                map.fields[self.cords.x][self.cords.y - i].PowerUp = nil
                map.fields[self.cords.x][self.cords.y - i].powerupNo = nil
                break
            end
            table.insert(fieldsCords, Vector.new(self.cords.x, self.cords.y - i))
        end
        if map.fields[self.cords.x][self.cords.y - i]:getType() ~= "arena_greenwall" then
            self.north = self.north + map.fieldSize
            table.insert(self.northCords, self.north)
            table.insert(fieldsCords, Vector.new(self.cords.x, self.cords.y - i))
        end
    end
    for k, v in pairs(fieldsCords) do -- TODO What is this?
        for j, l in pairs(map.players) do
            if l:playerOnField(v) == true then
                l:explode()
            end
        end
    end
    self.hitbox.solid = false
end

function Bomb:getData()
    local hx, hy = self.hitbox:center()
    local data = {
        position = {x = self.position.x, y = self.position.y},
        power = self.power,
        time = self.time,
        hitbox = {x = hx, y = hy, self.hitbox.solid},
        toDelete = self.toDelete,
        cords = {x = self.cords.x, y = self.cords.y},
        scale = self.scale,
        scaleFactor = self.scaleFactor,
        north = self.north,
        south = self.south,
        west = self.west,
        east = self.east,
        isExploding = self.isExploding,
        explodeState = self.explodeState,
        explodeTime = self.explodeTime,
        northCords = self.northCords,
        southCords = self.southCords,
        eastCords = self.eastCords,
        westCords = self.westCords
    }
    return data
end

function Bomb:setData(data)
    self.position.x = data.position.x
    self.position.y = data.position.y
    self.power = data.power
    self.time = data.time
    self.hitbox:moveTo(data.hitbox.x, data.hitbox.y)
    self.hitbox.solid = data.hitbox.solid
    self.toDelete = data.toDelete
    self.cords.x = data.cords.x
    self.cords.y = data.cords.y
    self.scale = data.scale
    self.scaleFactor = data.scaleFactor
    self.north = data.north
    self.south = data.south
    self.west = data.west
    self.east = data.east
    self.isExploding = data.isExploding
    self.explodeState = data.explodeState
    self.explodeTime = data.explodeTime
    self.northCords = data.northCords
    self.southCords = data.southCords
    self.eastCords = data.eastCords
    self.westCords = data.westCords
end

return Bomb
