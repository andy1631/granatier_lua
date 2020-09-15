Class = require 'lib.hump.class'
Map = require 'map'
Xml = require 'lib.xml2lua.xml2lua'

MapParser= Class{}

function MapParser:init()
   self.filePath="resources/arenas/clanbomber_Arena.xml"
end

function MapParser:parse()
  handler = require 'lib.xml2lua.xmlhandler.tree'
  self.xmlString =love.filesystem.read(self.filePath)
  self.xmlString = Xml.loadFile(self.filePath)
  local parser =Xml.parser(handler)
  parser:parse(self.xmlString)
  local t=handler.root.Arena[1]
  local x=t._attr.colCount
  local y=t._attr.rowCount
  t.Row.n=nil
  map=Map(x,y)
  --[[for i=1,x,1 do
    local xcord=t.Row[i][1]
    for j=1,y,1 do
      local ycord=string.sub(xcord,j,j)
    end
  end]]
  
  for i, v in pairs(t.Row) do
    local xcord=v[1]
    for j=1,x,1 do
      local ycord=string.sub(xcord,j,j)
      local temp="arena_ground"
      map:changeType(j,i,temp)
    end
  end
  
  map:spawn(Player())
end

return MapParser