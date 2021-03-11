HC = require "lib.HC"
Timer = require "lib.hump.timer"
Class = require "lib.hump.class"
Tove = require "lib.tove"
Vector = require "lib.hump.vector"

Bomb = Class {}

function Bomb:init(pos, power, cords, origin, ownerId)
    self.ownerId = ownerId
    self.position = pos:clone()
    self.power = power
    self.time = 3
    self.origin = origin
    --self.hitbox = HC.circle(self.position.x,self.position.y, 17.5)
    self.hitbox = HC.rectangle(self.position.x - 20 + self.origin.x, self.position.y - 20 + self.origin.y, 40, 40)
    self.hitbox.isBomb = true
    self.toDelete = false
    self.cords = cords:clone()
    self.size = 7 / 8 * map.fieldSize
    --self.bomb = love.filesystem.read("resources/SVG/bomb.svg")
    self.texture = Tove.newGraphics(Textures["bomb"])
    self.texture:rescale(self.size)
    self.scale = self.size
    self.scaleFactor = -0.25
    self.north = 0
    self.south = 0
    self.west = 0
    self.east = 0
    self.isExploding = false
    self.explodeState = 0
    self.explodeTime = 0
    self.northCords = {}
    self.southCords = {}
    self.eastCords = {}
    self.westCords = {}
    self.movedirection = nil
    self.stride = 0
    self.moveBomb = false
    self.dir = nil
    self.arrow = false
    self.kicked = false
    self.throw = false
    self.throwVector = nil
    self.throwDistance = nil
    self.throwDest = nil
    math.randomseed(os.time())
    self.explodeCords = {}
    self.explodedPlayers = {}
    self.morterTime = 0
    self.fall = false
    self.falltime = -1
end

function Bomb:draw()
    self.hitbox:draw()
    if self.fall == true then
        self.texture = Tove.newGraphics(Textures["bomb"], self.size * (self.falltime / 2))
    end
    if not self.isExploding then
        self.texture:draw(self.position.x + self.origin.x, self.position.y + self.origin.y)
    end

    --love.graphics.print(tostring(self.isExploding),0,0)
    self:explodeAnimation()
end

function Bomb:update(dt)
    if self.arrow or self.moveBomb then
        self:move(dt)
    elseif not self.arrow and not self.throw and not self.fall then
        self:arrowCheck()
    end
    self.time = self.time - dt
    if not self.throw and not self.moveBomb and not self.fall then
        if self.scale <= self.size * 0.914285714286 then
            self.scaleFactor = 12 * dt
        elseif self.scale >= self.size then
            self.scaleFactor = -12 * dt
        end
        self.scale = self.scale + self.scaleFactor
        self.texture:rescale(self.scale)
    end
    if
        self.time <= 0 and not self.isExploding and not self.moveBomb and self.cords.x > 0 and self.cords.y > 0 and
            not self.throw and
            not self.fall
     then
        self:explode()
    end
    if not self.throw then
        self.hitbox.solid = true
    end
    for k, v in pairs(map.players) do
        if self.hitbox:collidesWith(v.hitbox) or self.isExploding then
            self.hitbox.solid = false
        end
    end

    --if not self.hitbox:collidesWith(map.players[0].hitbox) and not self.isExploding then
    --    self.hitbox.solid = true
    --end

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
    if self.throw then
        self:throwAnimation(dt)
    end
    if not self.throw and self.morterTime <= 0 and self.cords.x > 0 and self.cords.y > 0 then
        if map.fields[self.cords.x][self.cords.y]:getType() == "arena_bomb_mortar" then
            self.arrow = false
            self.moveBomb = false
            self.morterTime = 1
            self.texture:clear()
        end
    end
    if self.morterTime > 0 then
        self.morterTime = self.morterTime - dt
        if self.morterTime <= 0 then
            self.texture = Tove.newGraphics(Textures["bomb"])
            local RandomX
            local RandomY
            repeat
                RandomX = love.math.random(1, map.x)
                RandomY = love.math.random(1, map.y)
            until self.cords.x ~= RandomX and self.cords.y ~= RandomY
            self:throwBomb(Vector.new(RandomX, RandomY))
        end
    end
    self:kickPowerUp(dt)

    if self.isExploding then
        for j, p in pairs(map.players) do
            for k, v in pairs(self.explodeCords) do
                if p:playerOnField(v) == true then
                    if not self.explodedPlayers[p.id] then
                        self.explodedPlayers[p.id] = true
                        if not p.stats.shield then
                            p:explode()
                        else
                            p.stats.shield = false
                        end
                    end
                end
            end
        end
    end
    if self.fall == true then
        if self.falltime - dt >= 0 then
            self.falltime = self.falltime - dt
        else
            self.fall = false
            self.falltime = -1
            self.toDelete = true
            map.players[self.ownerId].stats.bombs=map.players[self.ownerId].stats.bombs+1
        end
    end
    local vec=self:getRelPos()
    if not self.fall then
      if not vec or map.fields[vec.x][vec.y]:getType()=="air"then
        self.fall = true
        self.falltime = 2
        self.arrow=false
        self.moveBomb=false
        self.scale = self.size
        self.scaleFactor = -0.25
      end
    end
end

function Bomb:kickPowerUp(dt)
    for k, v in pairs(map.players) do
        if v.stats.kick == true and self.hitbox.hitByPlayer and not self.arrow and not self.kicked then
            self.movedirection = v.velocity:normalized() * 5
            self.dir = v.direction
            self.arrow = true
            self.kicked = true
            self:move(dt)
        end
    end
end

function Bomb:arrowCheck()
    if not self.moveBomb and self.cords.x > 0 and self.cords.y > 0 then
        if map.fields[self.cords.x][self.cords.y]:getType() == "arena_arrow_up" then
            self.movedirection = Vector.new(0, -5)
            self.dir = "up"
            self.arrow = true
        elseif map.fields[self.cords.x][self.cords.y]:getType() == "arena_arrow_down" then
            self.movedirection = Vector.new(0, 5)
            self.dir = "down"
            self.arrow = true
        elseif map.fields[self.cords.x][self.cords.y]:getType() == "arena_arrow_right" then
            self.movedirection = Vector.new(5, 0)
            self.dir = "right"
            self.arrow = true
        elseif map.fields[self.cords.x][self.cords.y]:getType() == "arena_arrow_left" then
            self.movedirection = Vector.new(-5, 0)
            self.dir = "left"
            self.arrow = true
        end
    end
end

function Bomb:nextIsSolid(dir)
    if dir == "up" then
        if self.cords.y ~= 1 then
            if
                map.fields[self.cords.x][self.cords.y - 1]:getType() ~= "arena_greenwall" and
                    map.fields[self.cords.x][self.cords.y - 1]:getType() ~= "arena_wall" and
                    not map.fields[self.cords.x][self.cords.y - 1]:hasPlayer()
             then
                return false
            end
        else
            return nil
        end
    elseif dir == "down" then
        if self.cords.y ~= map.y then
            if
                map.fields[self.cords.x][self.cords.y + 1]:getType() ~= "arena_greenwall" and
                    map.fields[self.cords.x][self.cords.y + 1]:getType() ~= "arena_wall" and
                    not map.fields[self.cords.x][self.cords.y + 1]:hasPlayer()
             then
                return false
            end
        else
            return nil
        end
    elseif dir == "right" then
        if self.cords.x ~= map.x then
            if
                map.fields[self.cords.x + 1][self.cords.y]:getType() ~= "arena_greenwall" and
                    map.fields[self.cords.x + 1][self.cords.y]:getType() ~= "arena_wall" and
                    not map.fields[self.cords.x + 1][self.cords.y]:hasPlayer()
             then
                return false
            end
        else
            return nil
        end
    elseif dir == "left" then
        if self.cords.x ~= 1 then
            if
                map.fields[self.cords.x - 1][self.cords.y]:getType() ~= "arena_greenwall" and
                    map.fields[self.cords.x - 1][self.cords.y]:getType() ~= "arena_wall" and
                    not map.fields[self.cords.x - 1][self.cords.y]:hasPlayer()
             then
                return false
            end
        else
            return nil
        end
    end
    return true
end

function Bomb:move(dt)
    if not self.isExploding then
        if not self.moveBomb then
            if not self:nextIsSolid(self.dir) then
                self.moveBomb = true
            end
        end

        if self.moveBomb and self.arrow then
            self.stride = self.stride + self.movedirection:len() * (dt * 50)
            self.hitbox:move(self.movedirection.x * (dt * 50), self.movedirection.y * (dt * 50))
            local posx, posy = self.hitbox:center()
            self.position.x = posx - self.origin.x
            self.position.y = posy - self.origin.y
        end

        if self.stride >= map.fieldSize then
            self.moveBomb = false
            self.stride = 0
            map.fields[self.cords.x][self.cords.y].bombs = 0
            if self:nextIsSolid(self.dir) ~= nil then
                self.cords = self.cords + self.movedirection:normalized()
                map.fields[self.cords.x][self.cords.y].bombs = 1
                self.hitbox:moveTo(
                    map.fields[self.cords.x][self.cords.y].position.x + self.origin.x,
                    map.fields[self.cords.x][self.cords.y].position.y + self.origin.y
                )
                self.position = map.fields[self.cords.x][self.cords.y].position:clone()
                if self:nextIsSolid(self.dir) then
                    self.arrow = false
                end
            else
                map.fields[self.cords.x][self.cords.y].bombs = 0
                self.cords.x = -1
                self.cords.y = -1
                self.arrow = false
            end
        end

        if not self.moveBomb then
            self:arrowCheck()
        end
    --[[local oldCords = self.cords:clone()
      local posx, posy = self.hitbox:center()
      self.position.x = posx - self.origin.x
      self.position.y = posy - self.origin.y
      self.cords = self:getRelPos()
      if oldCords ~= self.cords then
        map.fields[oldCords.x][oldCords.y].bombs = 0
        map.fields[self.cords.x][self.cords.y].bombs = 1
      end]]
    end
end

function Bomb:explodeAnimation()
    local explodeString = "bomb_blast_"
    if self.isExploding == true then
        if self.north > 0 then
            for i = table.getn(self.northCords), 1, -1 do
                self.texture =
                    Tove.newGraphics(Textures[explodeString .. "north_" .. self.explodeState], (self.size * 2))
                self.texture:draw(
                    self.position.x + self.origin.x,
                    self.position.y - (self.northCords[i]) + self.origin.y
                )
            end
        end
        if self.south > 0 then
            for i = table.getn(self.southCords), 1, -1 do
                self.texture =
                    Tove.newGraphics(Textures[explodeString .. "south_" .. self.explodeState], (self.size * 2))
                self.texture:draw(
                    self.position.x + self.origin.x,
                    self.position.y + (self.southCords[i]) + self.origin.y
                )
            end
        end
        if self.east > 0 then
            for i = table.getn(self.eastCords), 1, -1 do
                self.texture =
                    Tove.newGraphics(Textures[explodeString .. "east_" .. self.explodeState], (self.size * 2))
                self.texture:draw(
                    self.position.x + self.origin.x + (self.eastCords[i]),
                    self.position.y + self.origin.y
                )
            end
        end
        if self.west > 0 then
            for i = table.getn(self.westCords), 1, -1 do
                self.texture =
                    Tove.newGraphics(Textures[explodeString .. "west_" .. self.explodeState], (self.size * 2))
                self.texture:draw(
                    self.position.x + self.origin.x - (self.westCords[i]),
                    self.position.y + self.origin.y
                )
            end
        end
        self.texture = Tove.newGraphics(Textures[explodeString .. "core_" .. self.explodeState], self.size)
        self.texture:draw(self.position.x + self.origin.x, self.position.y + self.origin.y)
    end
end

function Bomb:explode()
    source = love.audio.newSource("resources/sounds/explode.wav", "static")
    love.audio.play(source)
    --self.toDelete = true
    self.isExploding = true
    local fieldsCords = {}
    map.fields[self.cords.x][self.cords.y].bombs = 0
    map.players[self.ownerId].stats.bombs = map.players[self.ownerId].stats.bombs + 1
    if map.fields[self.cords.x][self.cords.y]:getType() == "arena_ground" then
        map.fields[self.cords.x][self.cords.y].PowerUp = nil
        map.fields[self.cords.x][self.cords.y].powerupNo = nil
        table.insert(fieldsCords, Vector.new(self.cords.x, self.cords.y))
    elseif map.fields[self.cords.x][self.cords.y]:getType() == "arena_wall" then
        map.fields[self.cords.x][self.cords.y]:setType("arena_ground")
        map.fields[self.cords.x][self.cords.y]:spawnPowerUp()
        map.fields[self.cords.x][self.cords.y].solid = false
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

    self.explodeCords = fieldsCords
    --[[for j, l in pairs(map.players) do
        if l.stats.shield == false then
            for k, v in pairs(fieldsCords) do
                if l:playerOnField(v) == true then
                    l:explode()
                end
            end
        else
            l.stats.shield = false
        end
    end]]
    self.hitbox.solid = false
end

function Bomb:getRelPos()
    local col = {}
    local cords = {}
    for shape, delta in pairs(HC.collisions(self.hitbox)) do
        if shape.cords ~= nil then
            col[#col + 1] = Vector.new(delta.x, delta.y):len()
            cords[#cords + 1] = shape.cords
        end
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

function Bomb:getData()
    local hx, hy = self.hitbox:center()
    local data = {
        ownerId = self.ownerId,
        position = {x = self.position.x, y = self.position.y},
        power = self.power,
        time = self.time,
        hitbox = {x = hx, y = hy, solid = self.hitbox.solid, isBomb = self.hitbox.isBomb},
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
        westCords = self.westCords,
        arrow = self.arrow,
        stride = self.stride,
        kicked = self.kicked,
        throw = self.throw,
        explodeCords = self.explodeCords,
        explodedPlayers = self.explodedPlayers,
        morterTime = self.morterTime,
        fall = self.fall,
        falltime = self.falltime
    }
    if self.movedirection ~= nil then
        data.movedirection = {x = self.movedirection.x, y = self.movedirection.y}
    else
        data.movedirection = nil
    end
    if self.throw then
        data.throwVector = {x = self.throwVector.x, y = self.throwVector.y}
        data.throwDistance = self.throwDistance
        data.throwDest = {x = self.throwDest.x, y = self.throwDest.y}
    end
    return data
end

function Bomb:setData(data)
    self.ownerId = data.ownerId
    self.position.x = data.position.x
    self.position.y = data.position.y
    self.power = data.power
    self.time = data.time
    self.hitbox:moveTo(data.hitbox.x, data.hitbox.y)
    self.hitbox.solid = data.hitbox.solid
    self.hitbox.isBomb = data.hitbox.isBomb
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
    self.arrow = data.arrow
    self.kicked = data.kicked
    self.throw = data.throw
    self.morterTime = data.morterTime
    if data.throwVector then
        if self.throwVector then
            self.throwVector.x = data.throwVector.x
            self.throwVector.y = data.throwVector.y
        else
            self.throwVector = Vector.new(data.throwVector.x, data.throwVector.y)
        end
    end
    self.throwDistance = data.throwDistance
    if data.throwDest then
        if self.throwDest then
            self.throwDest.x = data.throwDest.x
            self.throwDest.y = data.throwDest.y
        else
            self.throwDest = Vector.new(data.throwDest.x, data.throwDest.y)
        end
    end
    if data.movedirection ~= nil and self.movedirection ~= nil then
        self.movedirection.x = data.movedirection.x
        self.movedirection.y = data.movedirection.y
    end
    self.stride = data.stride
    self.explodeCords = data.explodeCords
    self.explodedPlayers = data.explodedPlayers
    self.fall = data.fall
    self.falltime = data.falltime
end

function Bomb:throwBomb(cords)
    map.fields[self.cords.x][self.cords.y].bombs = 0
    local destPos
    if cords.x > 0 and cords.x <= map.x and cords.y > 0 and cords.y <= map.y then
        local destPos = map.fields[cords.x][cords.y].position
        self.throwVector = destPos - self.position
    else
        local t = (cords - self.cords):normalized()
        self.throwVector = (cords - self.cords):normalized() * 2 * map.fieldSize
    end
    self.throwDest = cords:clone()
    self.throwDistance = self.throwVector:len()
    self.throw = true
    self.hitbox.solid = false
    self.arrow = false
    self.moveBomb = false
end

function Bomb:throwAnimation(dt)
    local norm = self.throwVector:normalized()
    self.hitbox:move(norm.x * dt * 250, norm.y * dt * 250)
    self.throwDistance = self.throwDistance - Vector.new(norm.x * dt * 250, norm.y * dt * 250):len()
    if self.throwDistance < 0 then
        if self.throwDest.x > 0 and self.throwDest.x <= map.x and self.throwDest.y > 0 and self.throwDest.y <= map.y then
            self.hitbox:moveTo(
                map.fields[self.throwDest.x][self.throwDest.y].position.x + self.origin.x,
                map.fields[self.throwDest.x][self.throwDest.y].position.y + self.origin.y
            )
            self.cords = self:getRelPos()
            map.fields[self.cords.x][self.cords.y].bombs = map.fields[self.cords.x][self.cords.y].bombs + 1
        else
            local correct = self.throwVector:normalized() * (self.throwDistance+1)
            self.hitbox:move(correct.x, correct.y)
            self.cords.x = -1
            self.cords.y = -1
        end
        self.throw = false
        self.scale = self.size
        self.scaleFactor = -0.25
    end
    if self.throwDistance > self.throwVector:len() / 2 then
        self.scaleFactor = 15 * dt
    else
        self.scaleFactor = -15 * dt
    end
    self.scale = self.scale + self.scaleFactor
    self.texture:rescale(self.scale)
    local posx, posy = self.hitbox:center()
    self.position.x = posx - self.origin.x
    self.position.y = posy - self.origin.y
end
return Bomb
