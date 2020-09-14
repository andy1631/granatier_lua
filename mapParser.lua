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
  local parser =Xml.parser(handler)
  parser:parse(self.xmlString)
  local t=handler.root.Arena
  local x=t._attr.colCount
  local y=t._attr.rowCount
  map=Map(x,y)
end

return MapParser