Class = require "lib.hump.class"
Map = require "map"
Xml = require "lib.xml2lua.xml2lua"

MapParser = Class {}

function MapParser:init()
    self.filePath = "resources/arenas/granatier.xml"
end

function MapParser:parse()
    handler = require "lib.xml2lua.xmlhandler.tree"
    self.xmlString = love.filesystem.read(self.filePath)
    self.xmlString = Xml.loadFile(self.filePath)
    local parser = Xml.parser(handler)
    parser:parse(self.xmlString)
    local t = handler.root.Arena[1]
    local x = t._attr.colCount
    local y = t._attr.rowCount
    t.Row.n = nil
    math.randomseed(os.time())
    map = Map(x, y)
    for i, v in pairs(t.Row) do
        local xcord = v[1]
        for j = 1, x, 1 do
            local ycord = string.sub(xcord, j, j)
            local temp = "arena_ground"
            if ycord == " " then
                temp = "air"
            elseif ycord == "=" then
                temp = "arena_greenwall"
            elseif ycord == "_" then
                temp = "arena_ground"
            elseif ycord == "+" then
                temp = "arena_wall"
            elseif ycord == "x" then
                number = love.math.random(1, 100)
                if number > 50 then
                    temp = "arena_ground"
                else
                    temp = "arena_wall"
                end
            elseif ycord == "-" then
                temp = "arena_ice"
            elseif ycord == "o" then
                temp = "arena_bomb_mortar"
            elseif ycord == "u" then
                temp = "arena_arrow_up"
            elseif ycord == "r" then
                temp = "arena_arrow_right"
            elseif ycord == "d" then
                temp = "arena_arrow_down"
            elseif ycord == "l" then
                temp = "arena_arrow_left"
            elseif ycord == "p" then
                map:addSpawn(j, i)
                temp = "arena_ground"
            elseif ycord == "m" then
                temp = "arena_mine"
            end
            map:changeType(j, i, temp)
        end
    end

    map:spawn()
end

return MapParser
