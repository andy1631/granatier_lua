HC = require "lib.HC"
Timer = require "lib.hump.timer"
Class = require "lib.hump.class"
Tove = require "lib.tove"
Vector = require "lib.hump.vector"

Bomb = Class {}

function Bomb:init(pos, power, cords, origin)
    self.position = pos:clone()
    self.power = power
    self.time = 3
    self.origin = origin
    --self.hitbox = HC.circle(self.position.x,self.position.y, 17.5)
    self.hitbox = HC.rectangle(self.position.x - 20 + self.origin.x, self.position.y - 20 + self.origin.y, 40, 40)
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
    self.movedirection = nil
end

function Bomb:draw()
    --self.hitbox:draw()
    if not self.isExploding then
        self.bomb:draw(self.position.x + self.origin.x, self.position.y + self.origin.y)
    end

    --love.graphics.print(tostring(self.isExploding),0,0)
    self:explodeAnimation()
end

function Bomb:update(dt)
    self:arrowCheck()
    if self.movedirection ~= nil then
        self:move()
    else
        self.time = self.time - dt
    end
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

function Bomb:arrowCheck()
    if map.fields[self.cords.x][self.cords.y]:getType() == "arena_arrow_up" then
        self.movedirection = Vector.new(0, -40)
    elseif map.fields[self.cords.x][self.cords.y]:getType() == "arena_arrow_down" then
        self.movedirection = Vector.new(0, 40)
    elseif map.fields[self.cords.x][self.cords.y]:getType() == "arena_arrow_right" then
        self.movedirection = Vector.new(40, 0)
    elseif map.fields[self.cords.x][self.cords.y]:getType() == "arena_arrow_left" then
        self.movedirection = Vector.new(-40, 0)
    end
end

function Bomb:move()
    local oldCords = self.cords:clone()
    self.hitbox:move(self.movedirection.x, self.movedirection, y)
    for shapes, delta in pairs(HC.collisions(self.hitbox)) do
        if shapes.solid then
            self.hitbox:move(delta.x, delta.y)
            if math.sqrt(delta.x ^ 2 + delta.y ^ 2) > 0 then
                self.movedirection = nil
            end
        end
    end
    local posx, posy = self.hitbox:center()
    self.position.x = posx - self.origin.x
    self.position.y = posy - self.origin.y
    self.cords = self:getRelPos()
    if oldCords ~= self.cords then
        map.fields[oldCords.x][oldCords.y].bombs = 0
        map.fields[self.cords.x][self.cords.y].bombs = 1
    end
end

function Bomb:explodeAnimation()
    if self.isExploding == true then
        if self.explodeState == 0 then
            if self.north > 0 then
                for i = table.getn(self.northCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_north_0.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x,
                        self.position.y - (self.northCords[i]) + self.origin.y
                    )
                end
            end
            if self.south > 0 then
                for i = table.getn(self.southCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_south_0.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x,
                        self.position.y + (self.southCords[i]) + self.origin.y
                    )
                end
            end
            if self.east > 0 then
                for i = table.getn(self.eastCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_east_0.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x + (self.eastCords[i]),
                        self.position.y + self.origin.y
                    )
                end
            end
            if self.west > 0 then
                for i = table.getn(self.westCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_west_0.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x - (self.westCords[i]),
                        self.position.y + self.origin.y
                    )
                end
            end
            self.texture = love.filesystem.read("resources/SVG/bomb_blast_core_0.svg")
            self.texture = Tove.newGraphics(self.texture, self.size)
            self.texture:draw(self.position.x + self.origin.x, self.position.y + self.origin.y)
        end
        if self.explodeState == 1 then
            if self.north > 0 then
                for i = table.getn(self.northCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_north_1.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x,
                        self.position.y - (self.northCords[i]) + self.origin.y
                    )
                end
            end
            if self.south > 0 then
                for i = table.getn(self.southCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_south_1.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x,
                        self.position.y + (self.southCords[i]) + self.origin.y
                    )
                end
            end
            if self.east > 0 then
                for i = table.getn(self.eastCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_east_1.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x + (self.eastCords[i]),
                        self.position.y + self.origin.y
                    )
                end
            end
            if self.west > 0 then
                for i = table.getn(self.westCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_west_1.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x - (self.westCords[i]),
                        self.position.y + self.origin.y
                    )
                end
            end
            self.texture = love.filesystem.read("resources/SVG/bomb_blast_core_1.svg")
            self.texture = Tove.newGraphics(self.texture, self.size)
            self.texture:draw(self.position.x + self.origin.x, self.position.y + self.origin.y)
        end
        if self.explodeState == 2 then
            if self.north > 0 then
                for i = table.getn(self.northCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_north_2.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x,
                        self.position.y - (self.northCords[i]) + self.origin.y
                    )
                end
            end
            if self.south > 0 then
                for i = table.getn(self.southCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_south_2.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x,
                        self.position.y + (self.southCords[i]) + self.origin.y
                    )
                end
            end
            if self.east > 0 then
                for i = table.getn(self.eastCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_east_2.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x + (self.eastCords[i]),
                        self.position.y + self.origin.y
                    )
                end
            end
            if self.west > 0 then
                for i = table.getn(self.westCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_west_2.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x - (self.westCords[i]),
                        self.position.y + self.origin.y
                    )
                end
            end
            self.texture = love.filesystem.read("resources/SVG/bomb_blast_core_2.svg")
            self.texture = Tove.newGraphics(self.texture, self.size)
            self.texture:draw(self.position.x + self.origin.x, self.position.y + self.origin.y)
        end
        if self.explodeState == 3 then
            if self.north > 0 then
                for i = table.getn(self.northCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_north_3.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x,
                        self.position.y - (self.northCords[i]) + self.origin.y
                    )
                end
            end
            if self.south > 0 then
                for i = table.getn(self.southCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_south_3.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x,
                        self.position.y + (self.southCords[i]) + self.origin.y
                    )
                end
            end
            if self.east > 0 then
                for i = table.getn(self.eastCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_east_3.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x + (self.eastCords[i]),
                        self.position.y + self.origin.y
                    )
                end
            end
            if self.west > 0 then
                for i = table.getn(self.westCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_west_3.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x - (self.westCords[i]),
                        self.position.y + self.origin.y
                    )
                end
            end
            self.texture = love.filesystem.read("resources/SVG/bomb_blast_core_3.svg")
            self.texture = Tove.newGraphics(self.texture, self.size)
            self.texture:draw(self.position.x + self.origin.x, self.position.y + self.origin.y)
        end
        if self.explodeState == 4 then
            if self.north > 0 then
                for i = table.getn(self.northCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_north_4.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x,
                        self.position.y - (self.northCords[i]) + self.origin.y
                    )
                end
            end
            if self.south > 0 then
                for i = table.getn(self.southCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_south_4.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x,
                        self.position.y + (self.southCords[i]) + self.origin.y
                    )
                end
            end
            if self.east > 0 then
                for i = table.getn(self.eastCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_east_4.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x + (self.eastCords[i]),
                        self.position.y + self.origin.y
                    )
                end
            end
            if self.west > 0 then
                for i = table.getn(self.westCords), 1, -1 do
                    self.texture = love.filesystem.read("resources/SVG/bomb_blast_west_4.svg")
                    self.texture = Tove.newGraphics(self.texture, (self.size * 2))
                    self.texture:draw(
                        self.position.x + self.origin.x - (self.westCords[i]),
                        self.position.y + self.origin.y
                    )
                end
            end
            self.texture = love.filesystem.read("resources/SVG/bomb_blast_core_4.svg")
            self.texture = Tove.newGraphics(self.texture, self.size)
            self.texture:draw(self.position.x + self.origin.x, self.position.y + self.origin.y)
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
            map.fields[self.cords.x + i][self.cords.y].solid = false
            self.east = ((i - 1 + 0.75) * map.fieldSize)
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
                self.east = ((i - 1 + 0.75) * map.fieldSize)
                table.insert(self.eastCords, self.east)
                break
            end
            table.insert(fieldsCords, Vector.new(self.cords.x + i, self.cords.y))
        end
        if map.fields[self.cords.x + i][self.cords.y]:getType() ~= "arena_greenwall" then
            self.east = ((i - 1 + 0.75) * map.fieldSize)
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
            map.fields[self.cords.x - i][self.cords.y].solid = false
            self.west = ((i - 1 + 0.75) * map.fieldSize)
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
                self.west = ((i - 1 + 0.75) * map.fieldSize)
                table.insert(self.westCords, self.west)
                break
            end
            table.insert(fieldsCords, Vector.new(self.cords.x - i, self.cords.y))
        end
        if map.fields[self.cords.x - i][self.cords.y]:getType() ~= "arena_greenwall" then
            self.west = ((i - 1 + 0.75) * map.fieldSize)
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
            map.fields[self.cords.x][self.cords.y + i].solid = false
            self.south = ((i - 1 + 0.75) * map.fieldSize)
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
                self.south = ((i - 1 + 0.75) * map.fieldSize)
                table.insert(self.southCords, self.south)
                break
            end
            table.insert(fieldsCords, Vector.new(self.cords.x, self.cords.y + i))
        end
        if map.fields[self.cords.x][self.cords.y + i]:getType() ~= "arena_greenwall" then
            self.south = ((i - 1 + 0.75) * map.fieldSize)
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
            map.fields[self.cords.x][self.cords.y - i].solid = false
            self.north = ((i - 1 + 0.75) * map.fieldSize)
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
                self.north = ((i - 1 + 0.75) * map.fieldSize)
                table.insert(self.northCords, self.north)
                break
            end
            table.insert(fieldsCords, Vector.new(self.cords.x, self.cords.y - i))
        end
        if map.fields[self.cords.x][self.cords.y - i]:getType() ~= "arena_greenwall" then
            self.north = ((i - 1 + 0.75) * map.fieldSize)
            table.insert(self.northCords, self.north)
            table.insert(fieldsCords, Vector.new(self.cords.x, self.cords.y - i))
        end
    end
    for j, l in pairs(map.players) do
      if l.stats.shield == false then
        for k, v in pairs(fieldsCords) do
          if l:playerOnField(v) == true then
            l:explode()
          end
        end
      else
        l.stats.shield = false
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
function Bomb:moveOld(dt)
    local oldCords = self.cords:clone()
    self.hitbox:move(self.movedirection.x * (dt * 50), self.movedirection.y * (dt * 50))
    for shapes, delta in pairs(HC.collisions(self.hitbox)) do
        if shapes.solid then
            self.hitbox:move(delta.x, delta.y)
            if math.sqrt(delta.x ^ 2 + delta.y ^ 2) > 0 then
                self.movedirection = nil
            end
        end
    end
    local posx, posy = self.hitbox:center()
    self.position.x = posx - self.origin.x
    self.position.y = posy - self.origin.y
    self.cords = self:getRelPos()
    if oldCords ~= self.cords then
        map.fields[oldCords.x][oldCords.y].bombs = 0
        map.fields[self.cords.x][self.cords.y].bombs = 1
    end
end

function Bomb:getRelPos()
    local col = {}
    local cords = {}
    for shape, delta in pairs(HC.collisions(self.hitbox)) do
        col[#col + 1] = Vector.new(delta.x, delta.y):len()
        cords[#cords + 1] = shape.cords
    end
    --col[0] = 0
    local index = 1
    for k, v in pairs(col) do
        if v ~= 0 then
            if col[index] < v then
                index = k
            end
        end
    end
    return cords[index]
end

return Bomb
